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

		nur = {
			url = github:nix-community/NUR;
			# inputs.nixpkgs.follows = "nixpkgs";
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

		# Official Firefox builds for Darwin
        nixpkgs-firefox-darwin = {
			url = "github:bandithedoge/nixpkgs-firefox-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		neovim-config = {
			url = "github:minego/dotfiles.neovim";
			flake = false;
		};
	};

	outputs = { nixpkgs, ... }@inputs:
	let
		inherit (nixpkgs) lib;

		overlays = [
			inputs.dwl-minego.overlay
			inputs.swapmods.overlay
			inputs.mackeys.overlay
			inputs.nur.overlay
			(import ./overlays/fonts.nix)

			(self: super: {
				neovim-config = inputs.neovim-config;
			})
		];

		linuxOverlays = [
		];

		darwinOverlays = [
			inputs.nixpkgs-firefox-darwin.overlay
		];

		globals = rec {
			user		= "m";
			fullName	= "Micah N Gorrell";
			email		= "m@minego.net";
		};
	in rec {
		nixosConfigurations = {
			dent		= import ./hosts/dent		{ inherit inputs globals overlays linuxOverlays; };
			lord		= import ./hosts/lord		{ inherit inputs globals overlays linuxOverlays; };
			hotblack	= import ./hosts/hotblack	{ inherit inputs globals overlays linuxOverlays; };
		};

		darwinConfigurations = {
			zaphod		= import ./hosts/zaphod		{ inherit inputs globals overlays darwinOverlays; };
			random		= import ./hosts/random		{ inherit inputs globals overlays darwinOverlays; };
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
