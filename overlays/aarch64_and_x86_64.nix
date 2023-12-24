self: super:
let
	x86pkgs = import <nixpkgs> {
		localSystem			= "x86_64-linux";
		overlays			= [];
		config.allowUnfree	= true;
	};
in
{
	slack			= x86pkgs.slack;
	spotify			= x86pkgs.spotify;
}
