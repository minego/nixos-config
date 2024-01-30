{ config, pkgs, lib, inputs, ... }:
with lib;

{
	config = {
		# Using mkOverride instead of mkDefault to make this higher priority
		# but I still want to be able to use mkForce for a specific host
		boot.kernelPackages = mkOverride 500 pkgs.linuxPackages_latest;

		environment.systemPackages = with pkgs; [
			psmisc
			usbutils
			hwinfo
			inotify-tools
			polkit
			polkit_gnome
			bluez
			remmina

			glxinfo
			foot
			xterm

			# I don't love having these installed, but they make development
			# easier since I don't have to install them for every little thing
			cmake
			ninja
			openssl
			openssl.dev
			pkg-config
		];

		# Automatic Upgrades
		system.autoUpgrade.enable			= false;
		system.autoUpgrade.allowReboot		= false;

		# Bootloader.
		boot.loader.systemd-boot.enable		= mkDefault true;

		boot.tmp.cleanOnBoot				= true;

		documentation.dev.enable			= true;
		security.sudo.wheelNeedsPassword	= false;

		# Enable bluetooth
		hardware.bluetooth.enable			= true;
		hardware.bluetooth.powerOnBoot		= true;
		services.blueman.enable				= true;

		services.fstrim.enable				= true;

		# Enable sound with pipewire.
		sound.enable						= true;
		hardware.pulseaudio.enable			= mkForce false;
		security.rtkit.enable				= true;
		services.pipewire = {
			enable							= mkForce true;
			alsa.enable						= true;
			alsa.support32Bit				= true;
			pulse.enable					= true;

			# jack.enable					= true;
		};

		# Enable additional bluetooth codecs
		environment.etc = {
			"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
				bluez_monitor.properties = {
					["bluez5.enable-sbc-xq"] = true,
					["bluez5.enable-msbc"] = true,
					["bluez5.enable-hw-volume"] = true,
					["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
				}
			'';
		};

		systemd.user.services.mpris-proxy = {
			description						= "Mpris proxy";
			after							= [ "network.target" "sound.target" ];
			wantedBy						= [ "default.target" ];
			serviceConfig.ExecStart			= "${pkgs.bluez}/bin/mpris-proxy";
		};

		# Select internationalisation properties.
		i18n.defaultLocale					= "en_US.UTF-8";

		i18n.extraLocaleSettings = {
			LC_ALL							= "en_US.UTF-8"; 
			LC_ADDRESS						= "en_US.UTF-8";
			LC_IDENTIFICATION				= "en_US.UTF-8";
			LC_MEASUREMENT					= "en_US.UTF-8";
			LC_MONETARY						= "en_US.UTF-8";
			LC_NAME							= "en_US.UTF-8";
			LC_NUMERIC						= "en_US.UTF-8";
			LC_PAPER						= "en_US.UTF-8";
			LC_TELEPHONE					= "en_US.UTF-8";
			LC_TIME							= "en_US.UTF-8";
		};

		networking.firewall.allowedTCPPorts = [
			53317	# Used by local send
		];
		networking.firewall.allowedUDPPorts = [
			53317	# Used by local send
		];

		programs.git = {
			enable								= true;
			lfs.enable							= true;
		};

		services.avahi = {
			enable								= true;
			nssmdns4							= true;
			openFirewall						= true;
		};

		# Firmware Updater
		services.fwupd.enable = true;

		# Enable the OpenSSH daemon.
		services.openssh = {
			enable								= true;
			openFirewall						= true;
			settings = {
				PasswordAuthentication			= false;
				KbdInteractiveAuthentication	= false;
			};
		};
		programs.ssh.startAgent					= true;
		programs.mosh.enable					= true;

		# This value determines the NixOS release from which the default
		# settings for stateful data, like file locations and database versions
		# on your system were taken. It‘s perfectly fine and recommended to leave
		# this value at the release version of the first install of this system.
		# Before changing this value read the documentation for this option
		# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
		system.stateVersion = "23.05"; # Did you read the comment?
	};
}
