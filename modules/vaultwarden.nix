{ config, pkgs, ... }:
{
	services.vaultwarden = {
		enable			= true;
		dbBackend		= "sqlite";

		config = {
			DATA_FOLDER			= "/var/lib/vaultwarden/data/";
			ROCKET_ADDRESS		= "0.0.0.0";
			ROCKET_PORT			= 8222;
		};
	};

	networking.firewall.allowedTCPPorts = [ 8222 ];
}

