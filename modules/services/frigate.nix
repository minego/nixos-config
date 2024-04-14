{ inputs, config, pkgs, lib, ... }:
with lib;

let
	frigate-patched = pkgs.frigate.overrideDerivation(oldAttrs: {
			patches = oldAttrs.patches ++ [
				(pkgs.fetchpatch2 {
					# https://github.com/blakeblackshear/frigate/pull/10967
					name = "frigate-wsdl-path.patch";
					url = "https://github.com/blakeblackshear/frigate/commit/b65656fa8733c1c2f3d944f716d2e9493ae7c99f.patch";
					hash = "sha256-taPWFV4PldBGUKAwFMKag4W/3TLMSGdKLYG8bj1Y5mU=";
				})
			];
		});
in
{
	containers.frigate = rec {
		autoStart					= true;
		privateNetwork				= true;
		hostAddress					= "192.168.1.1";
		localAddress				= "192.168.111.1/32";

		ephemeral					= true;
		bindMounts = {
			"/etc/resolv.conf" = {
				hostPath			= "/etc/resolv.conf";
				isReadOnly			= true;
			};  

			"/var/lib/frigate" = {
				hostPath			= "/var/lib/frigate";
				isReadOnly			= false;
			};

			"/var/log" = {
				hostPath			= "/var/log/frigate";
				isReadOnly			= false;
			};

			# TODO: Why does this fail if I use the variable?
			# "${config.age.secrets.foscam-password.path}" = {
			"/run/agenix/foscam-password" = {
				isReadOnly			= true;
			};
		};

		forwardPorts = [{
			containerPort			= 80;
			hostPort				= 8125;
			protocol				= "tcp";
		}];


		# Reference article for NixOS containers:
		#		https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
		config = { config, pkgs, lib, ... }: {
			system.stateVersion		= "23.05";

			systemd.services.frigate.serviceConfig = {
				EnvironmentFile = "/run/agenix/foscam-password";
			};

			environment.systemPackages = with pkgs; [
				frigate-patched
			];

			services.frigate = rec {
				enable				= true;

				# Override to get the fix for the onvif wsdl shit
				package				= frigate-patched;

				# Frigate upstream itself sets up nginx with a reverse proxy, and
				# uses the hostname specified here.
				hostname			= "frigate";

				settings = {
					mqtt = {
						enabled		= true;
						host		= "${hostAddress}";
						port		= 1883;
					};

					cameras = rec {
						kitchen = {
							onvif = {
								host	= "kitchen-camera.minego.net";
								port	= 888;
								user	= "minego";
								password= "{FRIGATE_FOSCAM_PASS}";
							};
							ffmpeg.inputs = [{
								path	= "rtsp://minego:{FRIGATE_FOSCAM_PASS}@kitchen-camera.minego.net:88/videoSub";
								roles	= [ "detect" "record" ];
							}];
						};

						garage = {
							onvif = {
								host	= "garage-camera.minego.net";
								port	= 80;
							};
							ffmpeg.inputs = [{
								path	= "rtsp://minego:{FRIGATE_FOSCAM_PASS}@garage-camera.minego.net/stream1";
								roles	= [ "detect" ];
							} {
								path	= "rtsp://minego:{FRIGATE_FOSCAM_PASS}@garage-camera.minego.net/stream0";
								roles	= [ "record" ];
							}];
						};


						# livingroom.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/living-room-cam";
						# 	roles	= [ "detect" "record" ];
						# }];
						# frontdoor.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/front-door";
						# 	roles	= [ "detect" "record" ];
						# }];
						# frontporch.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/front-porch";
						# 	roles	= [ "detect" "record" ];
						# }];
						# backyard.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/backyard";
						# 	roles	= [ "detect" "record" ];
						# }];
						# garagedoor.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/garage-door";
						# 	roles	= [ "detect" "record" ];
						# }];
						# printers.ffmpeg.inputs = [{
						# 	path	= "rtsp://${hostAddress}:8554/printers";
						# 	roles	= [ "detect" "record" ];
						# }];
					};
				};
			};

			services.udev.extraRules = ''
                SUBSYSTEM=="usb",ATTRS{idVendor}=="1a6e",GROUP="frigate"
                SUBSYSTEM=="usb",ATTRS{idVendor}=="18d1",GROUP="frigate"
                '';

			networking = {
				firewall = {
					# Container ports
					allowedTCPPorts		= [ 80 ];
				};
			};
		};
	};

	networking.firewall = {
		# Host ports
		allowedTCPPorts				= [ 8125 ];
	};
}

