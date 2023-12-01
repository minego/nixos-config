{ config, pkgs, lib, ... }:
rec {
	users.users.m = {
		isNormalUser	= true;
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";
		extraGroups		= [
			"networkmanager"
			"wheel"
			"video"
		];
	};

    home-manager.users.m = {
		home = {
			username		= "m";
			homeDirectory	= "/home/m";
		};


		home.packages = with pkgs; [
			zsh
			zsh-syntax-highlighting
			zsh-vi-mode

			neofetch
			fzf
			acpi
			starship
			codespell
			mdcat
			ripgrep
			eza
			unzip
			jq
		];

		home.file = {
			neovim = {
				recursive = true;
				source = pkgs.fetchFromGitHub {
					owner	= "minego";
					repo	= "dotfiles.neovim";
					rev		= "e02dbb9";
					sha256	= "sha256-a2qZzSlJa2QbwB/dN71NCJNQwQaAdEJMAisVmexrWwI=";
				};
				target = "./.config/nvim";
			};
		};

		home.sessionVariables = {
		};

		programs.neovim = {
			enable			= true;
			defaultEditor	= true;
			viAlias			= true;
			vimAlias		= true;
		};

		programs.git = {
			enable = true;
			lfs.enable = true;

			extraConfig = {
				url."git@gitlab.com:".insteadOf = [ "https://gitlab.com" ];
				init.defaultBranch = "main";
				pull.rebase = true;
			};

			userEmail = "m@minego.net";
			userName = "Micah N Gorrell";

			includes = [
				{
					condition = "gitdir:~/src/vaas/";
					contents.user = {
						email = "micah.gorrell@venafi.com";
						name = "Micah N Gorrell";
					};
				}

				{
					condition = "gitdir:~/src/venafi/";
					contents.user = {
						email = "micah.gorrell@venafi.com";
						name = "Micah N Gorrell";
					};
				}
			];
		};

		programs.home-manager.enable = true;
		home.stateVersion = "23.11";
	};
}
