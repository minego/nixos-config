{ config, pkgs, lib, ... }:
with lib;

{
	options.services.mosquitto = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = rec {
		services.mosquitto = {
			port						= 1883;
			internalURL					= "http://127.0.0.1:${toString port}";

			enable						= true;
			listeners = [{
				acl						= [ "pattern readwrite #" ];
				address					= "0.0.0.0";
				port					= config.services.mosquitto.port;

				users.m = {
					acl					= [ "readwrite #" ];
					passwordFile		= config.age.secrets.mosquitto.path;
				};
			}];
		};

		networking.firewall = {
			allowedTCPPorts				= [ config.services.mosquitto.port ];
		};
	};
}

