{ ... }: {
	imports = [
		./nginx.nix
		./homepage.nix
		./vaultwarden.nix
		./plex.nix
		./sabnzbd.nix
		./radarr.nix
		./sonarr.nix
		./jellyseerr.nix
	];
}

