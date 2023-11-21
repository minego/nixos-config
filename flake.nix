{
	description = "Micah N Gorrell's NixOS Flake";

	# Inputs
	# https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		dwl = {
			url = "github:minego/dwl/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		mackeys = {
			url = "github:minego/mackeys/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		swapmods = {
			url = "github:minego/swapmods/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {
		self,
		nixpkgs,

		dwl,
		mackeys,
		swapmods,
		... 
	}@inputs:
	{
		nixosConfigurations = {
			lord = inputs.nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";

				modules = [
					(import ./common.nix inputs)
					(import ./hosts/lord/configuration.nix inputs)
				];

				specialArgs = { inherit inputs; };
			};
		};
	};
}
