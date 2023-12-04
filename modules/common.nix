{ config, pkgs, lib, inputs, ... }:

{
	# Enable the nix command and flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	services.avahi = {
		enable = true;
		nssmdns = true;
		openFirewall = true;
	};

	security.sudo.wheelNeedsPassword = false;

	# Automatic Upgrades
	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = false;

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS			= "en_US.UTF-8";
		LC_IDENTIFICATION	= "en_US.UTF-8";
		LC_MEASUREMENT		= "en_US.UTF-8";
		LC_MONETARY			= "en_US.UTF-8";
		LC_NAME				= "en_US.UTF-8";
		LC_NUMERIC			= "en_US.UTF-8";
		LC_PAPER			= "en_US.UTF-8";
		LC_TELEPHONE		= "en_US.UTF-8";
		LC_TIME				= "en_US.UTF-8";
	};

	# Enable bluetooth
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	services.blueman.enable = true;

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound with pipewire.
	sound.enable				= true;
	hardware.pulseaudio.enable	= false;
	security.rtkit.enable		= true;
	services.pipewire = {
		enable					= true;
		alsa.enable				= true;
		alsa.support32Bit		= true;
		pulse.enable			= true;

		# jack.enable			= true;
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
		description = "Mpris proxy";
		after = [ "network.target" "sound.target" ];
		wantedBy = [ "default.target" ];
		serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
	};

	programs.zsh = {
		enable = true;
		interactiveShellInit = ''
			source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
		'';
	};

	# Needed for auto completion to work for zsh
	environment.pathsToLink = [ "/share/zsh" ];

	environment.shellAliases = {
		vi = "nvim";
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		home-manager

		zsh
		zsh-syntax-highlighting
		zsh-vi-mode

		psmisc
		usbutils
		pciutils
		hwinfo
		lsof
		file

		gnumake
		dtach
		direnv

		curl
		stow
		inotify-tools
		polkit
		polkit_gnome
		bluez
		man-pages
		man-pages-posix
		kitty.terminfo
	];
	documentation.dev.enable = true;

	programs.neovim = {
		enable								= true;
		defaultEditor						= true;
		viAlias								= true;
		vimAlias							= true;
	};

	programs.git = {
		enable								= true;
		lfs.enable							= true;
	};

	# Firmware Updater
	services.fwupd.enable = true;

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable								= true;
		settings = {
			PasswordAuthentication			= false;
			KbdInteractiveAuthentication	= false;
		};
	};

	# Enable spotifyd, but without creds so anyone can control these machines
	# from a real spotify client.
	services.spotifyd = {
		enable								= true;
		settings = {
			use_mpris						= true;
			device_type						= "computer";
			device_name						= "${config.networking.hostName}";
		};
	};

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	networking.firewall.allowedTCPPorts = [
		53317	# Used by local send
		57621	# Used by spotifyd
	];
	networking.firewall.allowedUDPPorts = [
		53317	# Used by local send
		5353	# Used by spotifyd
	];

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.05"; # Did you read the comment?
}
