{ pkgs, config, lib, ... }:
with lib;

{
	# Options consumers of this module can set
	options.p81 = {
		enable = mkEnableOption "P81";
	};

	config = mkIf (config.p81.enable && pkgs.stdenv.isLinux) {
		environment.systemPackages = with pkgs; [
			perimeter81
		];
	};
}
