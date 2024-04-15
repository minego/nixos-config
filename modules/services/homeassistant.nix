{ config, pkgs, lib, inputs, ... }:
with lib;

{
	options.services.home-assistant = {
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.home-assistant = rec {
			config.http = {
				server_port				= 8123;
				server_host				= "127.0.0.1";
				trusted_proxies			= [ "127.0.0.1" ];
				use_x_forwarded_for		= true;
			};
			publicURL					= "https://home.${config.services.nginx.hostname}";
			internalURL					= "http://${config.http.server_host}:${toString config.http.server_port}";

			enable						= true;

			extraComponents = [
				# Components required to complete the onboarding
				"esphome"
				"met"
				"radio_browser"
				"cast"
				"camera"
				"plex"
				"bond"
				"smartthings"
				"vesync"
				"google_cloud"
				"google_translate"
				"sonarr"
				"radarr"
				"sabnzbd"
				"samsungtv"
				"brother"
				"camera"
				"cloudflare"
				"cert_expiry"
				"file"
				"github"
				"hddtemp"
				"media_player"
				"octoprint"
				"tailscale"
				"unifi"
				"youtube"
				"homekit"
				"homekit_controller"
				"foscam"
				"tuya"
				"whisper"
				"piper"
				"nest"
				"wyoming"
				"ipp"
				"spotify"
				"androidtv_remote"
				"unifiprotect"
				"glances"
				"onvif"
			];

			customComponents = with pkgs.home-assistant-custom-components; [
				frigate
			];

			customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
				mushroom
				multiple-entity-row
				mini-media-player
				mini-graph-card
				light-entity-card

				(pkgs.stdenv.mkDerivation rec {
					pname			= "frigate-hass-card";
					version			= "v5.2.0";

					src = pkgs.fetchzip {
						url			= "https://github.com/dermotduffy/${pname}/releases/download/${version}/${pname}.zip";
						hash		= "sha256-g8Rg6Y3KN1DLexqEPUt61PotpeBSCo3rD4iSz97ml+U=";
					};

					installPhase	= ''
                        mkdir -p $out
                        cp -v * $out
                        '';
				})
			];

			config = {
				# Includes dependencies for a basic setup
				# https://www.home-assistant.io/integrations/default_config/
				default_config = {};

				# Needed to use the custom modules
				lovelace.mode = "yaml";

				"automation manual"		= [];
				"automation ui"			= "!include automations.yaml";
			};
		};
		networking.firewall.allowedTCPPorts = [ config.services.home-assistant.config.http.server_port ];

		services.wyoming.openwakeword = {
			enable						= true;
			customModelsDirectories		= [ /var/lib/openwakeword ];
			uri							= "tcp://0.0.0.0:10400";
		};

		services.esphome = {
			enable						= true;
			# usePing						= true;
			port						= 6052;
			address						= "0.0.0.0";
			openFirewall				= true;
		};

		# I hate this, but it seems to be required for many home assistant
		# modules...
		# https://nixos.wiki/wiki/Home_Assistant
		nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

		services.nginx.virtualHosts."home.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.services.home-assistant.internalURL;
				proxyWebsockets			= true;
				recommendedProxySettings= true;
				extraConfig				= ''
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    '';
			};

			extraConfig = ''
                proxy_buffering off;
                ssl_session_cache builtin:1000;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
                ssl_prefer_server_ciphers on;
                ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
                ssl_session_tickets off;
                ssl_ecdh_curve secp384r1;
                resolver_timeout 10s;
                gzip on;
                gzip_vary on;
                gzip_min_length 1000;
                gzip_proxied any;
                gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
                gzip_disable "MSIE [1-6]\.";
                '';

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	};
}

