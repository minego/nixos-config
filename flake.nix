{
	description = "Micah N Gorrell's NixOS Flake";

	# Inputs
	# https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

	inputs = {
		nixpkgs.url							= "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = inputs@{ nixpkgs, ... }: {
		nixosConfigurations = {
			"lord" = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./configuration.nix
				];
			};
		};
	};
}
