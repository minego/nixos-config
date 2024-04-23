{ inputs, config, pkgs, lib, ... }:
with lib;

{
	options.services.shinobi = {
		port							= lib.mkOption { type = lib.types.port; };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = rec {
		services.shinobi = {
			port						= 5001;
			internalURL					= "http://127.0.0.1:${toString port}";
		};

		virtualisation = {
			oci-containers = {
				containers.shinobi = {
					environment.TZ		= "US/Mountain";
					image				= "registry.gitlab.com/shinobi-systems/shinobi:dev";

					volumes				= [
						"/var/lib/shinobi/config:/config"
						"/var/lib/shinobi/customAutoLoad:/home/Shinobi/libs/customAutoLoad"
						"/var/lib/shinobi/plugins:/home/Shinobi/plugins"
						"/data/NVR:/home/Shinobi/videos"
						"/var/lib/shinobi/mysql:/var/lib/mysql"
						"/etc/localtime:/etc/localtime:ro"
						"/etc/resolv.conf:/etc/resolv.conf:ro"
						"/run/agenix/foscam-password:/run/agenix/foscam-password:ro"
					];

					extraOptions		= [
						"--device=/dev/apex_0"			# PCIe Coral
						"--device=/dev/dri/renderD128"	# intel hwaccel
						"--shm-size=512m"

						"--gpus=all"					# Let shinobi use the quatro
					];

					ports				= [
						"${toString services.shinobi.port}:8080"
					];
				};
			};
		};

		networking.firewall = {
			allowedTCPPorts				= [ services.shinobi.port ];
		};
		systemd.tmpfiles.rules			= [ "d /var/lib/shinobi 0755 root root" ];
	};
}

