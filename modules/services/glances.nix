{ pkgs, config, lib, ... }:
with lib;

rec {
	systemd.services.glances = {
		enable					= true;
		description				= "Glances Server";

		after					= [ "network-pre.target" ];
		wantedBy				= [ "multi-user.target" ];

		script = with pkgs; ''
			${glances}/bin/glances -s
		'';
	};
}
