{
	description = "minego's NixOS Configuration";

	inputs = {
		nixpkgs.url				= "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url		= "github:nixos/nixpkgs/nixos-23.11";

		neovim-minego			= { url = github:minego/nixvim;							inputs.nixpkgs.follows = "nixpkgs"; };
		dwl-minego-customized	= { url = github:minego/dwl/main;						inputs.nixpkgs.follows = "nixpkgs"; };
		mackeys					= { url = github:minego/mackeys;						inputs.nixpkgs.follows = "nixpkgs"; };
		swapmods				= { url = github:minego/swapmods;						inputs.nixpkgs.follows = "nixpkgs"; };

		nixos-generators		= { url = github:nix-community/nixos-generators;		inputs.nixpkgs.follows = "nixpkgs"; };
		apple-silicon.url		= "github:tpwrules/nixos-apple-silicon";
		mobile-nixos			= { url = github:NixOS/mobile-nixos;					flake = false; };
		darwin					= { url = "github:LnL7/nix-darwin";						inputs.nixpkgs.follows = "nixpkgs"; };
		jovian-nixos			= { url = github:Jovian-Experiments/Jovian-NixOS;		inputs.nixpkgs.follows = "nixpkgs"; };
		home-manager			= { url = github:nix-community/home-manager;			inputs.nixpkgs.follows = "nixpkgs"; };

		nur.url					= github:nix-community/NUR;
        nixpkgs-firefox-darwin	= { url = github:bandithedoge/nixpkgs-firefox-darwin;	inputs.nixpkgs.follows = "nixpkgs"; };
		zsh-vi-mode				= { url = github:jeffreytse/zsh-vi-mode;				flake = false; };
		nixtheplanet			= { url = github:matthewcroughan/nixtheplanet;			inputs.nixpkgs.follows = "nixpkgs"; };
		p81						= { url = github:devusb/p81.nix;						inputs.nixpkgs.follows = "nixpkgs"; };
		sxmo-nix				= { url = github:chuangzhu/nixpkgs-sxmo;				flake = false; };
	};

	outputs = { nixpkgs, ... }@inputs:
	let
		inherit (nixpkgs) lib;

		overlays = [
			inputs.neovim-minego.overlays.default

			inputs.nur.overlay
			(import ./overlays/fonts.nix)

			# Allow grabbing specific packages from the previous release to
			# deal with things that are broken by unstable.
			(final: _prev: {
				stable = import inputs.nixpkgs-stable {
					system					= final.system;
					config.allowUnfree		= true;
				};
			})

			# Get the latest zsh-vi-mode
			(self: super: {
				zsh-vi-mode = super.zsh-vi-mode.overrideDerivation (oldAttrs: {
					src = inputs.zsh-vi-mode;
				});
			})
		];

		linuxOverlays = [
			inputs.dwl-minego-customized.overlays.default
			inputs.swapmods.overlay
			inputs.mackeys.overlay
			inputs.p81.overlays.default
		];

		darwinOverlays = [
			inputs.nixpkgs-firefox-darwin.overlay
		];
	in rec {
		nixosConfigurations = {
			# My main desktop computer
			dent		= import ./hosts/dent		{ inherit inputs overlays linuxOverlays; };

			# Thinkpad
			lord		= import ./hosts/lord		{ inherit inputs overlays linuxOverlays; };

			# Home server
			hotblack	= import ./hosts/hotblack	{ inherit inputs overlays linuxOverlays; };

			# Macbook pro (m2 max) running NixOS with Asahi
			zaphod2		= import ./hosts/zaphod2	{ inherit inputs overlays linuxOverlays; };

			# Gateway VM
			gateway-vm	= import ./hosts/gateway-vm { inherit inputs overlays linuxOverlays; };

			# PinePhone Pro
			marvin		= import ./hosts/marvin		{ inherit inputs overlays linuxOverlays; };

			# Steam Deck
			wonko		= import ./hosts/wonko		{ inherit inputs overlays linuxOverlays; };
		};

		# Images can be built with `nix build ./#images.foobar`
		images = {
			wonko		= nixosConfigurations.wonko.config.system.build.isoImage;
		};

		darwinConfigurations = {
			# Macbook pro (m2 max)
			zaphod		= import ./hosts/zaphod		{ inherit inputs overlays darwinOverlays; };

			# Mac mini (m1)
			random		= import ./hosts/random		{ inherit inputs overlays darwinOverlays; };
		};

		homeConfigurations = {
			# NixOS
			dent		= nixosConfigurations.dent.config.home-manager.users.m.home;
			hotblack	= nixosConfigurations.hotblack.config.home-manager.users.m.home;
			zaphod2		= nixosConfigurations.zaphod2.config.home-manager.users.m.home;

			# Gavin's NixOS Laptop
			lord-m		= nixosConfigurations.lord.config.home-manager.users.m.home;
			lord-gavin	= nixosConfigurations.lord.config.home-manager.users.gavin.home;

			# Darwin
			zaphod		= nixosConfigurations.zaphod.config.home-manager.users.m.home;
			random		= nixosConfigurations.random.config.home-manager.users.m.home;
		};

		marvin-image	= nixosConfigurations.marvin.config.mobile.outputs.u-boot.disk-image;

		devShells.x86_64-linux.default = let
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
		in pkgs.mkShell rec {
			name		= "minego-nixos-config";
			packages	= with pkgs; [
				nvd gnumake
			];
		};

		devShells.aarch64-linux.default = let
			pkgs = nixpkgs.legacyPackages.aarch64-linux;
		in pkgs.mkShell rec {
			name		= "minego-nixos-config";
			packages	= with pkgs; [
				nvd gnumake
			];
		};
	};
}
