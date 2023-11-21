{ dwl, ... }:
{ config, pkgs, ... }:

{
	services.xserver = {
		enable = true;

		displayManager.sddm = {
			enable = true;
		};
	};

	environment.systemPackages = [
		pkgs.xdg-utils
		pkgs.wayland
		dwl.packages.${pkgs.system}.default
	];

	fonts.packages = [
		pkgs.nerdfonts
		pkgs.noto-fonts
		pkgs.noto-fonts-cjk
		pkgs.noto-fonts-emoji
		pkgs.liberation_ttf
		pkgs.fira-code
		pkgs.fira-code-symbols
		pkgs.mplus-outline-fonts.githubRelease
		pkgs.dina-font
		pkgs.proggyfonts
	];

	# Make wayland behave
	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	xdg.portal.wlr.enable = true;
}

