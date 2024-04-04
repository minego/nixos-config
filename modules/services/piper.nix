{ config, pkgs, lib, ... }:
with lib;

{
	options.services.piper = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.piper = rec {
			port						= 10200;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.piper = {
					volumes				= [ "/var/lib/piper:/data" ];
					environment.TZ		= "US/Mountain";
					image				= "rhasspy/wyoming-piper";
					extraOptions		= [ "--network=host" ];
					cmd					= [ "--voice" "en_US-lessac-medium" ];
				};
			};
		};

		networking.firewall = {
			allowedTCPPorts				= [ 10200 ];
		};
		systemd.tmpfiles.rules			= [ "d /var/lib/piper 0755 root root" ];
	};
}

