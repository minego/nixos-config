{ inputs, config, pkgs, lib, ... }:
with lib;

{
	options.services.frigate = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.frigate = rec {
			port						= 8125;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.frigate = {
					environment.TZ		= "US/Mountain";
					image				= "ghcr.io/blakeblackshear/frigate:stable";

					volumes				= [
						"/var/lib/frigate:/config"
						"/data/NVR:/media/frigate"
						"/etc/localtime:/etc/localtime:ro"
						"/etc/resolv.conf:/etc/resolv.conf:ro"
						"/run/agenix/foscam-password:/run/agenix/foscam-password:ro"
					];

					extraOptions		= [
						"--device=/dev/apex_0"			# PCIe Coral
						"--device=/dev/dri"				# intel hwaccel
						"--shm-size=512m"

						# "--gpus=all"					# Let frigate use the quatro
					];

					ports				= [
						"8125:5000"
						"5000:5000"
						"8556:8554" # RTSP feeds
						"8555:8555/tcp" # WebRTC over tcp
						"8555:8555/udp" # WebRTC over udp
					];
				};
			};
		};

		networking.firewall = {
			allowedTCPPorts				= [ 8125 ];
		};
		systemd.tmpfiles.rules			= [ "d /var/lib/frigate 0755 root root" ];
	};
}

