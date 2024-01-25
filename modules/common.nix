{ config, pkgs, lib, globals, inputs, ... }:
with lib;

{
	options.authorizedKeys.keys = mkOption{
		description	= ''
            A list of trusted ssh keys that should be used trusted by the
            default user (m) and a handful of other things such as remote
            LUKS unlocking, and remote nix builders.
            '';

		default = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL m@dent"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeoTPiXAOmtOWU5oAajvYX+QBOUVF3yyObGii16BQ/+ m@lord"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi m@hotblack"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV m@zaphod"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyOr1jFfS3I12H73/phT6OLCcz5joIYOVOQgiR1OpHv m@random"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6XNKufvADcA5zNAp5mYVBA2kQ2OIXIOq9enSyUmJsM m@marvin"
		];
	};

	config = {
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

			nix-output-monitor
			asciinema
		];

		home-manager = {
			useGlobalPkgs		= true;
			useUserPackages		= true;

			extraSpecialArgs	= { inherit globals inputs; };
		};
	};
}
