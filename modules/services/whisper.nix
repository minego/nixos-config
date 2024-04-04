{ config, pkgs, lib, ... }:
with lib;

{
	options.services.whisper = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.whisper = rec {
			port						= 10300;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.whisper = {
					volumes				= [ "/var/lib/whisper:/data" ];
					environment.TZ		= "US/Mountain";
					image				= "rhasspy/wyoming-whisper";
					extraOptions		= [ "--network=host" ];
					cmd					= [ "--model" "tiny-int8" "--language" "en" ];
				};
			};
		};

		networking.firewall = {
			allowedTCPPorts				= [ 10300 ];
		};
		systemd.tmpfiles.rules			= [ "d /var/lib/whisper 0755 root root" ];
	};
}

