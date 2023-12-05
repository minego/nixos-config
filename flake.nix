{
	description = "Micah N Gorrell's NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = github:nix-community/home-manager;
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Plugin for Interception Tools
		mackeys = {
			url = "github:minego/mackeys";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Plugin for Interception Tools
		swapmods = {
			url = "github:minego/swapmods";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# My branch of DWL
		dwl-minego = {
			url = "github:minego/dwl";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Use official Firefox binary for macOS
		firefox-darwin = {
			url = "github:bandithedoge/nixpkgs-firefox-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, ... }@inputs:
	let
		overlays = [
			inputs.dwl-minego.overlay
			inputs.swapmods.overlay
			inputs.mackeys.overlay
			(import ./overlays/fonts.nix)
		];

		globals = rec {
			user		= "m";
			fullName	= "Micah N Gorrell";
			email		= "m@minego.net";
		};
	in rec {
		nixosConfigurations = {
			dent		= import ./hosts/dent		{ inherit inputs globals overlays; };
			lord		= import ./hosts/lord		{ inherit inputs globals overlays; };
			hotblack	= import ./hosts/hotblack	{ inherit inputs globals overlays; };
		};

		darwinConfigurations = {
			zaphod		= import ./hosts/zaphod		{ inherit inputs globals overlays; };
			random		= import ./hosts/random		{ inherit inputs globals overlays; };
		};

		homeConfigurations = {
			# NixOS
			dent		= nixosConfigurations.dent.config.home-manager.users.${globals.user}.home;
			lord		= nixosConfigurations.lord.config.home-manager.users.${globals.user}.home;
			hotblack	= nixosConfigurations.hotblack.config.home-manager.users.${globals.user}.home;

			# Darwin
			zaphod		= nixosConfigurations.zaphod.config.home-manager.users.${globals.user}.home;
			random		= nixosConfigurations.random.config.home-manager.users.${globals.user}.home;
		};
	};
}
