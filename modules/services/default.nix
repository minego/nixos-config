{ inputs, ... }: {
	imports = [
		# Main web page, and used for reverse proxy for other services
		./nginx.nix

		# Simple dashboard landing page
		./homepage.nix

		# Secrets
		./vaultwarden.nix

		# View and stream Movies and TV shows
		./plex.nix

		# Usenet Downloader
		./sabnzbd.nix

		# Manage Movies
		./radarr.nix

		# Manage TV Shows
		./sonarr.nix

		# Manage media requests
		./jellyseerr.nix

		# MQTT broker
		./mosquitto.nix

		# Wyze Bridge is a video bridge and provides streaming RSTP camera streams 
		./wyzebridge.nix

		# Home Assistant OS - This just provides the reverse proxy setup, since
		# hoas itself runs as a full vm in libvirt
		./haos.nix

		# Frigate network video recorder (NVR)
		./frigate.nix







		# TODO Cleanup

		# Home Assistant - Home automation, voice control, smart devices, etc
		# ./homeassistant.nix

		# Homebridge emulates Apple's HomeKit, and can be used by
		# home-assistant. It provides plugins, and is used here to provide Wyze
		# integration for home-assistant.
		# ./homebridge.nix

		# Whisper converts speech into text, used by home-assistant
		# ./whisper.nix

		# Whisper converts text into speech, used by home-assistant
		# ./piper.nix

		# Frigate network video recorder (NVR)
		# ./frigate-nix.nix
	];
}

