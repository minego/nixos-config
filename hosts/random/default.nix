{ inputs, overlays, darwinOverlays, ... }:

let
	lib		= inputs.darwin.lib;
	system	= "aarch64-darwin";
	pkgs	= inputs.nixpkgs.legacyPackages.${system};
in
lib.darwinSystem rec {
	modules = [
		{
			nixpkgs.hostPlatform = system;
			nixpkgs.overlays = overlays ++ darwinOverlays;

			# Modules
			gui.enable			= true;

			networking.hostName	= "random";

			imports = [
				../../users/m/darwin.nix
				../../modules/common.nix
				../../modules/darwin/common.nix
				inputs.home-manager.darwinModules.home-manager
			];
		}
	];
}
