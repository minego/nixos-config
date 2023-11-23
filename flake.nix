{
	description = "Micah N Gorrell's NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = {
		self,
		nixpkgs,
		... 
	}@inputs:
	let
		inherit (self) outputs;
	in {
		nixosConfigurations = {
			lord = inputs.nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {inherit inputs outputs;};

				modules = [
					./hosts/lord/configuration.nix
					./common.nix
					./laptop.nix
					./libvirt.nix
					./user-m.nix
					./gui.nix
					./interception-tools.nix
				];
			};
		};
	};
}
