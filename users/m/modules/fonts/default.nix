{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	fonts.fontconfig.enable = osConfig.gui.enable;
	home.packages = with pkgs; [

	] ++ lib.optionals osConfig.gui.enable [
		# Fonts
		nerdfonts
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		mplus-outline-fonts.githubRelease
		proggyfonts
		terminus_font

		monaspace
		sparklines
	];
}
