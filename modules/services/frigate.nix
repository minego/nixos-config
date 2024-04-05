{ config, pkgs, lib, ... }:
with lib;

{
	containers.frigate = {
		autoStart					= true;
		privateNetwork				= true;
		hostAddress					= "192.168.1.1";
		localAddress				= "192.168.111.1/32";

		ephemeral					= true;
		bindMounts = {
			"/var/lib/frigate" = {
				hostPath			= "/var/lib/frigate";
				isReadOnly			= false;
			};

			"/var/log" = {
				hostPath			= "/var/log/frigate";
				isReadOnly			= false;
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

			services.frigate = rec {
				enable				= true;

				# Frigate upstream itself sets up nginx with a reverse proxy, and
				# uses the hostname specified here.
				hostname			= "frigate";

				settings = {
					mqtt = {
						enabled		= true;
						host		= "hotblack.minego.net";
						port		= 1883;
					};

					cameras = {
						livingroom.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/living-room-cam";
							roles	= [ "detect" "record" ];
						}];
						frontdoor.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/front-door";
							roles	= [ "detect" "record" ];
						}];
						frontporch.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/front-porch";
							roles	= [ "detect" "record" ];
						}];
						backyard.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/backyard";
							roles	= [ "detect" "record" ];
						}];
						garagedoor.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/garage-door";
							roles	= [ "detect" "record" ];
						}];
						printers.ffmpeg.inputs = [{
							path	= "rtsp://hotblack.minego.net:8554/printers";
							roles	= [ "detect" "record" ];
						}];
					};
				};
			};

			services.udev.extraRules = ''
                SUBSYSTEM=="usb",ATTRS{idVendor}=="1a6e",GROUP="frigate"
                SUBSYSTEM=="usb",ATTRS{idVendor}=="18d1",GROUP="frigate"
                '';

			networking.firewall = {
				# Container ports
				allowedTCPPorts		= [ 80 ];
			};
		};
	};

	networking.firewall = {
		# Host ports
		allowedTCPPorts				= [ 8125 ];
	};
}

