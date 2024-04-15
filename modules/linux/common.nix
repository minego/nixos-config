{ config, pkgs, lib, inputs, ... }:
with lib;

{
	options.kernel = {
		latest = mkEnableOption {
			default			= true;
			description		= "Default to installking pkgs.linuxPackages_latest";
		};

		zen = mkEnableOption {
			default			= false;
			description		= "Default to installking pkgs.linuxPackages_zen";
		};
	};

	config = mkMerge [
	(mkIf config.kernel.latest {
		boot.kernelPackages = mkOverride 500 pkgs.linuxPackages_latest;
	})
	(mkIf config.kernel.zen {
		boot.kernelPackages = mkOverride 500 pkgs.linuxPackages_zen;
	})
	{
		environment.systemPackages = with pkgs; [
			psmisc
			usbutils
			hwinfo
			ethtool
			inotify-tools
			polkit
			polkit_gnome
			bluez
			remmina

			glxinfo
			foot
			xterm
			glances

			wally-cli # Firmware for the ZSA moonlander keyboard

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
		hardware.pulseaudio.enable			= mkForce false;
		security.rtkit.enable				= true;
		services.pipewire = {
			enable							= mkForce true;
			alsa.enable						= true;
			alsa.support32Bit				= true;
			pulse.enable					= true;

			# jack.enable					= true;
		};

#		# Enable additional bluetooth codecs
#		environment.etc = {
#			"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
#				bluez_monitor.properties = {
#					["bluez5.enable-sbc-xq"] = true,
#					["bluez5.enable-msbc"] = true,
#					["bluez5.enable-hw-volume"] = true,
#					["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
#				}
#			'';
#		};

		systemd.user.services.mpris-proxy = {
			description						= "Mpris proxy";
			after							= [ "network.target" "sound.target" ];
			wantedBy						= [ "default.target" ];
			serviceConfig.ExecStart			= "${pkgs.bluez}/bin/mpris-proxy";
		};

		# Prevent failig to do a switch because networkmanager takes too long
		systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

		hardware.keyboard = {
			qmk.enable						= true;
			zsa.enable						= true;
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

		# Driver needed for the EdgeTPU Coral dev board
		boot.extraModulePackages = with config.boot.kernelPackages; [
			gasket
		];

		# Allow access to the esp home m5 atom echo devices for setting up
		# their firmware with esphome (through chrome)
		services.udev.extraRules				= ''
			SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="00??", GROUP="plugdev", MODE="0666"
			SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="????", GROUP="plugdev", MODE="0666"
		'';

		# This value determines the NixOS release from which the default
		# settings for stateful data, like file locations and database versions
		# on your system were taken. It‘s perfectly fine and recommended to leave
		# this value at the release version of the first install of this system.
		# Before changing this value read the documentation for this option
		# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
		system.stateVersion = "23.05"; # Did you read the comment?
	}];
}
