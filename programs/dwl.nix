{ config, pkgs, lib, dwl-source, ... }:
with lib;
let
	cfg = config.programs.dwl;

	dwlPackage = import ../packages/dwl.nix
	{
		inherit pkgs;
		inherit (cfg) patches cmd;
		inherit dwl-source;
	};
in {
	options.programs.dwl = {
		enable = mkEnableOption "dwl";
		package = mkOption {
			type = types.package;
			default = dwlPackage;
		};

		patches = mkOption {
			default = [ ];
		};
	};

	config = mkIf cfg.enable {
		home.packages = [ cfg.package ];
	};

}
