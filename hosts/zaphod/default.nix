{ inputs, overlays, ... }:

let
	lib = inputs.nixpkgs.lib;
	darwin = inputs.darwin;
in

darwin.lib.darwinSystem rec {
	system = "aarch64-darwin";
	pkgs = import inputs.nixpkgs { system = system; };
	modules = [
		{
			nixpkgs.overlays = overlays;
			nixpkgs.hostPlatform = lib.mkDefault system;

			# Modules
			gui.enable		= false;
			"8bitdo".enable	= false;
			amdgpu.enable	= false;
			nvidia.enable	= false;

			networking.hostName = "zaphod";
			time.timeZone = "America/Denver";

			# Auto upgrade nix package and the daemon service.
			services.nix-daemon.enable = true;
			nix.package = inputs.pkgs.nix;

			home-manager = {
				useGlobalPkgs	= true;
				useUserPackages	= true;
			};

			imports = [
				../../modules
				../../users/m
				inputs.home-manager.nixosModules.home-manager
			];
		}
	];
}
