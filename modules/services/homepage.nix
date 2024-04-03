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
					"Overseerr" = {
						icon					= "overseerr.png";
						description				= "Manage requested TV shows and Movies";
						href					= config.services.jellyseerr.publicURL;
						siteMonitor				= config.services.jellyseerr.internalURL;

						# widget = {
						# 	type				= "overseerr";
						# 	url					= config.services.jellyseerr.internalURL;
						# 	enableQueue			= false;
						# 	key					= "{{HOMEPAGE_VAR_OVERSEERR}}";
						# };
					};
				}
				{
					"Sonarr" = {
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
					"Radarr" = {
						icon					= "radarr.png";
						description				= "Manage monitored TV shows";
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
					"Sabnzbd" = {
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
}

