{ config, pkgs, lib, ... }:
with lib;

{
	options.services.mosquitto = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.mosquitto = rec {
			port						= 1883;
			internalURL					= "http://127.0.0.1:${toString port}";

			enable						= true;
			listeners = [{
				acl						= [ "pattern readwrite #" ];
				omitPasswordAuth		= true;
				settings.allow_anonymous= true;
				address					= "127.0.0.1";
			}];
		};

		networking.firewall = {
			allowedTCPPorts				= [ 1883 ];
		};
	};
}

