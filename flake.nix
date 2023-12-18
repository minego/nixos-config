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

		# My customized neovim package, with configuration
		neovim-minego = {
			url = "github:minego/nvim-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zsh-vi-mode = {
			url = "github:jeffreytse/zsh-vi-mode";
			flake = false;
		};

		# Micro VMs
		microvm = {
			url = "github:astro/microvm.nix";
			inputs.nixpkgs.follows = "nixpkgs";
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
			inputs.neovim-minego.overlay
			(import ./overlays/fonts.nix)

			# Get the latest zsh-vi-mode
			(self: super: {
				zsh-vi-mode = super.zsh-vi-mode.overrideDerivation (oldAttrs: {
					src = inputs.zsh-vi-mode;
				});
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
			# My main desktop computer
			dent		= import ./hosts/dent		{ inherit inputs globals overlays linuxOverlays; };

			# Thinkpad
			lord		= import ./hosts/lord		{ inherit inputs globals overlays linuxOverlays; };

			# Home server
			hotblack	= import ./hosts/hotblack	{ inherit inputs globals overlays linuxOverlays; };

			# NixOS VM running on my macbook pro
			zaphod-vm	= import ./hosts/zaphod-vm	{ inherit inputs globals overlays linuxOverlays; };

			# Gateway VM
			gateway-vm	= import ./hosts/gateway-vm { inherit inputs globals overlays linuxOverlays; };
		};

		# Shortcut to allow accessing the VM as '.#zaphod-vm' instead of the whole path
		packages.aarch64-darwin.zaphod-vm = nixosConfigurations.zaphod-vm.config.system.build.vm;

		darwinConfigurations = {
			# Macbook pro (m2 max)
			zaphod		= import ./hosts/zaphod		{ inherit inputs globals overlays darwinOverlays; };

			# Mac mini (m1)
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
