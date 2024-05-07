{ pkgs, ... }:

{
	systemd.services.glances = {
		enable					= true;
		description				= "Glances Server";

		after					= [ "network-pre.target" ];
		wantedBy				= [ "multi-user.target" ];

		script = ''
			${pkgs.glances}/bin/glances -s -p 61209
		'';
	};

	networking.firewall = {
		allowedTCPPorts				= [ 61209 ];
	};
}
