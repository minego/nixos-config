{ config, pkgs, lib, ... }:
{
	users.users.m = {
		isNormalUser	= true;
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";
		extraGroups		= [
			"networkmanager"
			"wheel"
			"video"
		];

		packages = with pkgs; [
			zsh
			neofetch
			acpi
			starship
			codespell
			mdcat
			ripgrep
			eza
			unzip
			jq
		];
	};
}
