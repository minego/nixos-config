{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	fonts.fontconfig.enable = osConfig.gui.enable;
	home.packages = with pkgs; [

	] ++ lib.optionals pkgs.stdenv.isDarwin [
		# Fonts for Linux are handled in `modules/linux/gui.nix`
		monaspace
		sparklines
		nerdfonts
	];
}
