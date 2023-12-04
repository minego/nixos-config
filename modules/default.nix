{ pkgs, lib, ... }:
with lib;

{
	imports = [
		./common.nix

		./laptop.nix
		./printer.nix
		./syncthing.nix
	] ++ lib.optionals pkgs.stdenv.isLinux [
		./gui.nix
		./8bitdo.nix
		./interception-tools.nix
		./libvirt.nix

		./amdgpu.nix
		./nvidia.nix
	] ++ lib.optionals pkgs.stdenv.isDarwin [

	];
}

