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
				# omitPasswordAuth		= true;
				# settings.allow_anonymous= true;

				users.root = {
					acl					= [ "readwrite #" ];
					hashedPassword		= "$7$101$APJzdO3OCXwsme7Z$/K7wIHgUJJjVcmELyHWSfaIJDw0+TmmSCAQ2F4rCTkORc0/IHgTfGSKRnJFIG+vexOhPJr6jMYz1sCIO+fyBQg==";
				};
			}];
		};

		networking.firewall = {
			allowedTCPPorts				= [ 1883 ];
		};
	};
}

