{ pkgs, config, lib, ... }:
with lib;

{
	# Options consumers of this module can set
	options.p81 = {
		enable = mkEnableOption {
			description		= "P81";
			default			= true;
		};
	};

	config = mkIf (config.p81.enable && pkgs.stdenv.isLinux) {
		environment.systemPackages = with pkgs; [
			perimeter81
		];
	};
}
