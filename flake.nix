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
					./modules/common.nix
					./modules/laptop.nix
					./modules/libvirt.nix
					./modules/docker.nix
					./modules/gui.nix
					./modules/syncthing.nix
					./modules/interception-tools.nix
					./users/m.nix
				];
			};

			dent = inputs.nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {inherit inputs outputs;};

				modules = [
					./hosts/dent/configuration.nix
					./modules/common.nix
					./modules/8bitdo.nix
					./modules/libvirt.nix
					./modules/docker.nix
					./modules/gui.nix
					./modules/syncthing.nix
					./modules/interception-tools.nix
					./users/m.nix
				];
			};

		};
	};
}
