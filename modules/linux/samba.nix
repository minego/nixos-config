{ config, pkgs, lib, fetchzip, ... }:
with lib;

{
	# Options consumers of this module can set
	options.samba = {
		enable = mkEnableOption "Samba";
	};
	config = mkIf (config.samba.enable && pkgs.stdenv.isLinux) {
		networking.firewall.allowedTCPPorts = [
			5357 # wsdd
		];
		networking.firewall.allowedUDPPorts = [
			3702 # wsdd
		];

		services.samba-wsdd.enable				= true; # make shares visible for windows 10 clients
		services.samba = {
			enable								= true;
			openFirewall						= true;
			securityType						= "user";
			extraConfig = ''
                workgroup = MINEGO
                server string = ${config.networking.hostName}
                netbios name = ${config.networking.hostName}
                security = user 
                hosts allow = 172.31. 127.0.0.1 localhost
                hosts deny = 0.0.0.0/0
                guest account = nobody
                map to guest = bad user
                '';
			shares = {
				src = {
					path						= "/home/m/src";
					browseable					= "yes";
					"read only"					= "no";
					"guest ok"					= "no";
					"create mask"				= "0644";
					"directory mask"			= "0755";
					"force user"				= "m";
					# "force group"				= "staff";
				};
			};
		};
	};
}

