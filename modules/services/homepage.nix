{ config, pkgs, lib, ... }:
with lib;

rec {
	services.homepage-dashboard = {
		enable									= true;

		# The default port of 8082 conflicts with frigate, and that isn't
		# currently configurable.
		listenPort								= 8282;

		settings = {
			title								= "minego";
			color								= "neutral";
			headerStyle							= "clean";

			layout = {
				"Shows" = {
					style						= "row";
					columns						= 3;
				};
				"Media" = {
					style						= "row";
					columns						= 3;
				};
				"Security" = {
					style						= "row";
					columns						= 3;
				};
			};
		};

		environmentFile							= config.age.secrets.hotblack-dashboard-env.path;

		services = [{
			"Shows" = [
				{
					"Request Shows" = {
						icon					= "overseerr.png";
						description				= "Manage requested TV shows and Movies";
						href					= config.services.jellyseerr.publicURL;
						siteMonitor				= config.services.jellyseerr.internalURL;

						widget = {
							type				= "jellyseerr";
							url					= config.services.jellyseerr.internalURL;
							enableQueue			= false;
							key					= "{{HOMEPAGE_VAR_OVERSEERR}}";
						};
					};
				}

				{
					"Watch Shows" = {
						icon					= "plex.png";
						description				= "Watch movies and TV shows";
						href					= config.services.plex.publicURL;
						siteMonitor				= config.services.plex.internalURL;

						widget = {
							type				= "plex";
							url					= config.services.plex.internalURL;
							key					= "{{HOMEPAGE_VAR_PLEXKEY}}";
						};
					};
				}

				{
					"Calendar" = {
						icon					= "calendar.png";
						description				= "Calendar";

						widget = {
							type				= "calendar";
							view				= "agenda";
							maxEvents			= 15;

							integrations = [{
								type			= "sonarr";
								service_group	= "Media";
								service_name	= "Manage TV Shows";
							} {
								type			= "radarr";
								service_group	= "Media";
								service_name	= "Manage Movies";
							}];
						};

					};
				}
			];
		} {
			"Media" = [
				{
					"Manage TV Shows" = {
						icon					= "sonarr.png";
						description				= "Manage monitored TV shows";
						href					= config.services.sonarr.publicURL;
						siteMonitor				= config.services.sonarr.internalURL;

						widget = {
							type				= "sonarr";
							url					= config.services.sonarr.internalURL;
							enableQueue			= false;
							key					= "{{HOMEPAGE_VAR_SONARRKEY}}";
						};
					};
				}
				{
					"Manage Movies" = {
						icon					= "radarr.png";
						description				= "Manage monitored Movies";
						href					= config.services.radarr.publicURL;
						siteMonitor				= config.services.radarr.internalURL;

						widget = {
							type				= "radarr";
							url					= config.services.radarr.internalURL;
							enableQueue			= false;
							key					= "{{HOMEPAGE_VAR_RADARRKEY}}";
						};
					};
				}

				{
					"Downloads" = {
						icon					= "sabnzbd.png";
						description				= "Manage downloads";
						href					= config.services.sabnzbd.publicURL;
						siteMonitor				= config.services.sabnzbd.internalURL;

						widget = {
							type				= "sabnzbd";
							url					= config.services.sabnzbd.internalURL;
							key					= "{{HOMEPAGE_VAR_SABNZBDKEY}}";
						};
					};
				}
			];
		} {
			"Security" = [
				{
					"Vaultwarden" = {
						icon					= "bitwarden.png";
						description				= "Manage secrets";
						href					= "https://bitwarden.${config.services.nginx.hostname}/";
						siteMonitor				= "http://127.0.0.1:8222";
					};
				}
			];
		}];

		widgets = [
			{
				resources = {
					label						= "system";
					cpu							= true;
					memory						= true;
				};
			}

			{
				resources = {
					label						= "root";
					disk = [
						"/"
					];
				};
			}

			{
				resources = {
					label						= "data";
					disk = [
						"/mnt/data"
					];
				};
			}

			{
				resources = {
					label						= "Media";
					cpu							= false;
					memory						= false;
					disk = [
						"/data"
					];
				};
			}
		];
	};

	services.nginx.virtualHosts."dashboard.${config.services.nginx.hostname}" = {
		forceSSL								= true;

		locations."/" = {
			proxyPass							= "http://127.0.0.1:${toString config.services.homepage-dashboard.listenPort}";
			recommendedProxySettings			= true;
			extraConfig							= ''
				proxy_http_version 1.1;
				proxy_set_header Upgrade $http_upgrade;
				proxy_set_header Connection "upgrade";
				'';
		};

		extraConfig = ''
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

		sslCertificate							= config.services.nginx.sslCertificate;
		sslCertificateKey						= config.services.nginx.sslCertificateKey;
	};

}

