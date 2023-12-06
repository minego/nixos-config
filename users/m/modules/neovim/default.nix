{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	config = {
		home.packages = with pkgs; [
			neovim-remote
			neovim-remote
			codespell
		];

		programs.neovim = {
			enable			= true;
			defaultEditor	= true;
			viAlias			= true;
			vimAlias		= true;

			plugins = [
				pkgs.vimPlugins.nvim-treesitter.withAllGrammars
			];
		};

		home.file.neovim = {
			source = "${pkgs.neovim-config}";
			target = "./.config/nvim";
		};
	};
}

