{ pkgs, ... }:

{
	systemd.services.glances-server = {
		enable					= true;
		description				= "Glances Server";

		after					= [ "network-pre.target" ];
		wantedBy				= [ "multi-user.target" ];

		script = ''
			${pkgs.glances}/bin/glances -s -p 61209
		'';
	};

	systemd.services.glances-web = {
		enable					= true;
		description				= "Glances Web";

		after					= [ "network-pre.target" ];
		wantedBy				= [ "multi-user.target" ];

		# The web server listens on 61208
		script = ''
			${pkgs.glances}/bin/glances -w
		'';
	};

	networking.firewall = {
		allowedTCPPorts				= [ 61208 61209 ];
	};
}
