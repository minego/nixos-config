{ config, pkgs, lib, osConfig, inputs, ... }:
with lib;

{
	options.colors = {
		light = {
			black	= mkOption { default = "000000"; };
			red		= mkOption { default = "ff2a6d"; };
			green	= mkOption { default = "bcea3b"; };
			yellow	= mkOption { default = "faff00"; };
			blue	= mkOption { default = "02a9ea"; };
			magenta	= mkOption { default = "A61B47"; };
			cyan	= mkOption { default = "05d9e8"; };
			white	= mkOption { default = "999999"; };
		};

		dark = {
			black	= mkOption { default = "222222"; };
			red		= mkOption { default = "D9245D"; };
			green	= mkOption { default = "96BA2F"; };
			yellow	= mkOption { default = "D5D900"; };
			blue	= mkOption { default = "0285B8"; };
			magenta	= mkOption { default = "8C173C"; };
			cyan	= mkOption { default = "04ACB8"; };
			white	= mkOption { default = "ffffff"; };
		};
	};
}
