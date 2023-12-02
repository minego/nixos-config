{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	fonts.fontconfig.enable = true;
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

		(pkgs.stdenv.mkDerivation {
			name	= "monaspace";
			version	= "1.000";

			src		= pkgs.fetchFromGitHub {
				owner	= "githubnext";
				repo	= "monaspace";
				rev		= "2bddc16670ec9cf00435a1725033f241184dedd1";
				sha256	= "sha256-YgpK+a66s8YiJg481uFlRKUvu006Z2sMOpuvPFcDJH4=";
			};

			installPhase = ''
				mkdir -p $out/share/fonts/OTF/
				cp -r fonts/otf/* $out/share/fonts/OTF/
			'';
		})

		(pkgs.stdenv.mkDerivation {
			name	= "sparklines";
			version	= "2.0";

			src		= pkgs.fetchzip {
				url			= "https://github.com/aftertheflood/sparks/releases/download/v2.0/Sparks-font-complete.zip";
				stripRoot	= false;
				hash		= "sha256-xp/rCZpitX2IZO1Tvl3Me1WSPsxy55BDDuoQzQGBlII=";
			};

			installPhase = ''
				mkdir -p $out/share/fonts/OTF/
				cp -r Sparks/*.otf $out/share/fonts/OTF/
			'';
		})
	];
}
