{ config, pkgs, lib, globals, inputs, ... }:

{
	time.timeZone = lib.mkDefault "America/Denver";

	# Enable the nix command and flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

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
		neovim

		home-manager

		zsh
		zsh-syntax-highlighting
		zsh-vi-mode

		pciutils
		lsof
		file

		gnumake
		dtach
		direnv

		curl
		stow
		man-pages
		man-pages-posix
		kitty.terminfo
	];

	# Enable spotifyd, but without creds so anyone can control these machines
	# from a real spotify client.
	services.spotifyd = {
		enable				= true;
		settings = {
			use_mpris		= true;
			device_type		= "computer";
			device_name		= "${config.networking.hostName}";
		};
	};

	home-manager = {
		useGlobalPkgs		= true;
		useUserPackages		= true;

		extraSpecialArgs	= { inherit globals inputs; };
	};
}
