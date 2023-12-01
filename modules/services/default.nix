{ ... }: {
	imports = [
		./nginx.nix
		./plex.nix
		./radarr.nix
		./sabnzbd.nix
		./sonarr.nix
		./vaultwarden.nix
	];
}

