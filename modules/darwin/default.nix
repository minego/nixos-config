{ config, pkgs, lib, ... }:
with lib;

{
	imports = [
		./common.nix
		./gui.nix
	];
}

