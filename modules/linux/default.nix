{ config, pkgs, lib, ... }:
with lib;

{
	imports = [
		./common.nix
		./laptop.nix
		./gui.nix
		./printer.nix

		./8bitdo.nix
		./interception-tools.nix
		./libvirt.nix

		./amdgpu.nix
		./nvidia.nix

		./syncthing.nix
		./samba.nix
	];
}

