{ config, pkgs, ... }:
{
	services.vaultwarden = {
		enable						= true;
		dbBackend					= "sqlite";

		config = {
			# DATA_FOLDER			= "/var/lib/bitwarden_rs/data";
			ROCKET_ADDRESS			= "127.0.0.1";
			ROCKET_PORT				= 8222;
		};
	};

    services.nginx.virtualHosts."bitwarden.${config.services.nginx.hostname}" = {
		forceSSL					= true;

		locations."/" = {
			proxyPass				= "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
			proxyWebsockets			= true;
			extraConfig				= "proxy_pass_header Authorization;";
		};

		sslCertificate				= config.services.nginx.sslCertificate;
		sslCertificateKey			= config.services.nginx.sslCertificateKey;
	};
}

