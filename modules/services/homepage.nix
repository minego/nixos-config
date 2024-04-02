{ config, pkgs, lib, ... }:
with lib;

{
	services.homepage-dashboard = {
		enable									= true;

		settings = {
			title								= "minego";
			color								= "neutral";
			headerStyle							= "clean";

			layout = {
				Media = {
					style						= "row";
					columns						= 3;
				};
				Security = {
					style						= "row";
					columns						= 3;
				};
			};
		};

		environmentFile							= config.age.secrets.hotblack-dashboard-env.path;

		services = [{
			"Media" = [
				{
					"Plex" = {
						icon					= "plex.png";
						description				= "Watch movies and TV shows";
						href					= "http://plex.minego.net";
						siteMonitor				= "http://127.0.0.1:32400";

						widget = {
							type				= "plex";
							url					= "http://127.0.0.1:32400";
							key					= "{{HOMEPAGE_VAR_PLEXKEY}}";
						};
					};
				}

				{
					"Sonarr" = {
						icon					= "sonarr.png";
						description				= "Manage monitored TV shows";
						href					= "http://minego.net/sonarr";
						siteMonitor				= "http://127.0.0.1:8989";

						widget = {
							type				= "sonarr";
							url					= "http://127.0.0.1:8989";
							enableQueue			= false;
							key					= "{{HOMEPAGE_VAR_SONARRKEY}}";
						};
					};
				}

				{
					"Radarr" = {
						icon					= "radarr.png";
						description				= "Manage monitored movies";
						href					= "http://minego.net/radarr";
						siteMonitor				= "http://127.0.0.1:7878";

						widget = {
							type				= "radarr";
							url					= "http://127.0.0.1:7878";
							enableQueue			= false;
							key					= "{{HOMEPAGE_VAR_RADARRKEY}}";
						};
					};
				}

				{
					"Sabnzbd" = {
						icon					= "sabnzbd.png";
						description				= "Manage downloads";
						href					= "http://minego.net/sabnzbd";
						siteMonitor				= "http://127.0.0.1:8080";

						widget = {
							type				= "sabnzbd";
							url					= "http://127.0.0.1:8080";
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
						href					= "https://bitwarden.minego.net/";
						siteMonitor				= "http://127.0.0.1:8222";
					};
				}

				{
					"Tailscale" = {
						icon					= "tailscale.png";
						description				= "VPN";
						href					= "https://tailscale.com";

						widget = {
							type				= "tailscale";
							deviceid			= "nAmEwoA9mW11CNTRL"; # hotblack
							key					= "{{HOMEPAGE_VAR_TAILSCALE_KEY}}";
						};
					};
				}
			];
		} {
			"Calendar" = [
				{
					"Calendar" = {
						icon					= "calendar.png";
						description				= "Calendar";

						widget = {
							type				= "calendar";
							view				= "agenda";
							maxEvents			= 30;

							integrations = [
								{
									type				= "sonarr";
									service_group		= "Media";
									service_name		= "Sonarr";
								}
								{
									type				= "radarr";
									service_group		= "Media";
									service_name		= "Radarr";
								}
							];
						};

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
					disk = [
						"/"
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
}

