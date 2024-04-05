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
				hostPath			= "/var/log";
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
					# Note that frigate may also use these ports:
					#		127.0.0.1:5001	api servers
					#		127.0.0.1:5002	mqtt-ws servers
					#		127.0.0.1:8082	jsmpeg
					#		127.0.0.1:1984	go2rtc

					mqtt = {
						enabled		= true;
						host		= "127.0.0.1";
						port		= 1883;
					};

					cameras			= {};
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

	services.nginx.virtualHosts."frigate.${config.services.nginx.hostname}" = {
		forceSSL					= true;

		locations."/" = {
			proxyPass				= "http://frigate/";
			recommendedProxySettings= true;
			extraConfig				= ''
				proxy_http_version 1.1;
				proxy_set_header Upgrade $http_upgrade;
				proxy_set_header Connection "upgrade";
				'';
		};

		extraConfig = ''
			resolver_timeout 10s;
			gzip on;
			gzip_vary on;
			gzip_min_length 1000;
			gzip_proxied any;
			gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
			gzip_disable "MSIE [1-6]\.";
			'';

		sslCertificate				= config.services.nginx.sslCertificate;
		sslCertificateKey			= config.services.nginx.sslCertificateKey;
	};

}

