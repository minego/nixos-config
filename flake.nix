{
	description = "Micah N Gorrell's NixOS Flake";

	# Inputs
	# https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

	inputs = {
		nixpkgs.url							= "github:NixOS/nixpkgs/nixos-unstable";
		home-manager.url					= "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows	= "nixpkgs";
	};

	outputs = inputs@{ nixpkgs, home-manager, ... }: {
		nixosConfigurations = {
			"lord" = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./configuration.nix

					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs		= true;
						home-manager.useUserPackages	= true;
					}
				];
			};
		};
	};
}
