{ config, pkgs, lib, ... }:
with lib;

{
	# Common modules (Linux and Darwin)
	imports = [
		./common.nix
		./gui
	];
}

