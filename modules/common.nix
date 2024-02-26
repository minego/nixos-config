{ config, pkgs, lib, inputs, ... }:
with lib;

{
	options = {
		me = mkOption {
			description		= "Details about my default user";

			default = {
				user		= "m";
				fullName	= "Micah N Gorrell";
				email		= "m@minego.net";
			};
		};

		# This option exists so that my homebrew config can tell if the gui
		# module was enabled. It should NOT be enabled directly in a host's
		# config though.
		#
		# Instead, it should be on by default for Darwin since that always has
		# a gui enabled, and it should be turned on for Linux by importing
		# `modules/linux/gui.nix` which will set this option.
		gui.enable = lib.mkEnableOption {
			description		= "GUI";
			default			= if pkgs.stdenv.isDarwin then true else false;
		};
	};

	options.authorizedKeys.keys = mkOption {
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
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpCf3ELP19jIwlrm9zMiPhzHUAQQ1shXgIrbrYmPpnj phone"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6avo8bo4p2UsXer2yUPkS5s4E/m5fMkhX9WnzrffwJ m@wonko"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJ7500iF9Quza4AIpfXulyqljvL70nR75cFbf2j4IUL m@trillian"
		];
	};

	imports = [
		./zsh.nix
	];

	config = {
		time.timeZone = lib.mkDefault "America/Denver";

		# Enable the nix command and flakes
		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		environment.shellAliases = {
			vi				= "nvim";
			t				= "todo.sh";
			todo			= "todo.sh";
		};

		environment.variables = {
			KEYTIMEOUT		= "1";
			VISUAL			= "nvim";
			EDITOR			= "nvim";
			SUDO_EDITOR		= "nvim";
			LC_CTYPE		= "C";
		};

		# List packages installed in system profile. To search, run:
		# $ nix search wget
		environment.systemPackages = with pkgs; [
			neovim

			home-manager
			nvd

			pciutils
			lsof
			file

			gnumake
			dtach
			direnv

			curl
			httpie
			stow
			man-pages
			man-pages-posix
			kitty.terminfo

			nix-output-monitor
			asciinema

			(pkgs.writeShellScriptBin "todo.sh" ''
				export TODOTXT_CFG_FILE=${writeText "config" ""}
                export TODO_DIR="$HOME/notes/"
                export TODO_FILE="$TODO_DIR/todo.txt"
                export DONE_FILE="$TODO_DIR/done.txt"
                export REPORT_FILE="$TODO_DIR/report.txt"
                exec ${pkgs.todo-txt-cli}/bin/todo.sh $@
                '')
		];

		home-manager = {
			useGlobalPkgs		= true;
			useUserPackages		= true;

			extraSpecialArgs	= { inherit inputs; };
		};
	};
}
