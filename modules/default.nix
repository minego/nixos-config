{ ... }: {
	imports = [
		./common.nix

		./gui.nix
		./8bitdo.nix
		./interception-tools.nix

		./laptop.nix
		./printer.nix
		./libvirt.nix
		./syncthing.nix

		./amdgpu.nix
		./nvidia.nix
	];
}

