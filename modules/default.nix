{ pkgs, lib, ... }:
with lib;

{
	imports = [
		./common.nix

		./laptop.nix
		./printer.nix
		./syncthing.nix

		./gui
	] ++ lib.optionals pkgs.stdenv.isLinux [
		./gui/linux.nix
	] ++ lib.optionals pkgs.stdenv.isDarwin [
		./gui/darwin.nix
	] ++ [
		./8bitdo.nix
		./interception-tools.nix
		./libvirt.nix

		./amdgpu.nix
		./nvidia.nix
	];
}

