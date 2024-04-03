{ config, pkgs, lib, ... }:
with lib;

{
	options.services.homebridge = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.homebridge = rec {
			port						= 8581;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.homebridge = {
					volumes				= [ "/var/lib/homebridge:/homebridge" ];
					environment.TZ		= "US/Mountain";
					image				= "homebridge/homebridge:latest";
					extraOptions		= [ "--network=host" ];
				};
			};
		};

		networking.firewall = {
			allowedTCPPorts				= [ 5353 8581 51789 ];
			allowedUDPPorts				= [ 5353 ];

			allowedTCPPortRanges		= [{ from = 52100; to = 52150; }];
		};
		systemd.tmpfiles.rules			= [ "d /var/lib/homebridge 0755 root root" ];
	};
}

