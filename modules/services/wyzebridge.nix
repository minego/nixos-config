{ config, pkgs, lib, ... }:
with lib;

{
	options.services.wyzebridge = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.wyzebridge = rec {
			port						= 5001;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.wyzebridge = {
					volumes				= [ "wyzebridge:/config" ];
					environment.TZ		= "US/Mountain";
					image				= "mrlt8/wyze-bridge";
					extraOptions = [ 
						"-p" "8554:8554"
						"-p" "8888:8888"
						"-p" "5001:5000"
						"-p" "8889:8889" # WebRTC
						"-p" "8189:8189" # WebRTC/ICE
					];
				};
			};
		};

		networking.firewall.allowedTCPPorts = [ 5001 8554 8888 8889 8189 ];
	};
}

