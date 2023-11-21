{ swapmods, mackeys, ... }:
{ config, pkgs, lib, inputs, ... }:

let
	caps2escPkg	= pkgs.interception-tools-plugins.caps2esc;
	mackeysPkg	= mackeys.packages.${pkgs.system}.default;
	swapmodsPkg	= swapmods.packages.${pkgs.system}.default;
in
{
	# Enable the nix command and flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	security.sudo.wheelNeedsPassword = false;

	# Automatic Upgrades
	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = false;

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Enable networking
	networking.networkmanager.enable = true;
	programs.nm-applet.enable = true;

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

	programs.zsh = {
		enable = true;
		interactiveShellInit = ''
			source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
		'';
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.m = {
		isNormalUser	= true;
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";
		extraGroups		= [ "networkmanager" "wheel" ];

		packages = with pkgs; [
			zsh
			firefox-wayland
			tridactyl-native
			thunderbird
			kitty
			neofetch
			acpi
			starship
			codespell
			mdcat
			ripgrep
			eza
			unzip
			bemenu
			wdisplays
			slack
			bitwarden
			steam
		];
	};

	environment.shellAliases = {
		vi = "nvim";
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = [
		pkgs.zsh
		pkgs.psmisc
		pkgs.zsh-syntax-highlighting
		pkgs.zsh-vi-mode
		pkgs.git
		pkgs.gnumake
		pkgs.neovim
		pkgs.dtach
		pkgs.gcc
		pkgs.go
		pkgs.curl
		pkgs.stow
	];

	# Interception-Tools
	services.interception-tools = {
		enable = true;
		plugins = [
			caps2escPkg
			mackeysPkg
			swapmodsPkg
		];
		udevmonConfig = ''
- JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${swapmodsPkg}/bin/swapmods | ${mackeysPkg}/bin/mackeys | ${caps2escPkg}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  DEVICE:
    NAME: AT Translated Set 2 keyboard
- JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${mackeysPkg}/bin/mackeys | ${caps2escPkg}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  DEVICE:
    NAME: ".*((k|K)(eyboard|EYBOARD)).*"
		'';
	};

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.05"; # Did you read the comment?
}
