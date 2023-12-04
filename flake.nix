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

		mackeys = {
			url = "github:minego/mackeys";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		swapmods = {
			url = "github:minego/swapmods";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		dwl-minego = {
			url = "github:minego/dwl";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, darwin, home-manager, swapmods, mackeys, dwl-minego, ... }@inputs:
	let
		inherit (self) outputs;

		overlays = [
			dwl-minego.overlay
			swapmods.overlay
			mackeys.overlay
			(import ./overlays/fonts.nix)
		];
	in rec {
		nixosConfigurations = {
			dent		= import ./hosts/dent		{ inherit inputs overlays; };
			lord		= import ./hosts/lord		{ inherit inputs overlays; };
			hotblack	= import ./hosts/hotblack	{ inherit inputs overlays; };
		};

		darwinConfigurations = {
			zaphod		= import ./hosts/zaphod		{ inherit inputs overlays; };
		};

		homeConfigurations = {
			dent		= nixosConfigurations.dent.config.home-manager.users.m.home;
			lord		= nixosConfigurations.lord.config.home-manager.users.m.home;
			hotblack	= nixosConfigurations.hotblack.config.home-manager.users.m.home;
		};
	};
}
