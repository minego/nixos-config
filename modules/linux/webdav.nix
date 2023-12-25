{ config, pkgs, lib, fetchzip, ... }:
with lib;

{
	# Options consumers of this module can set
	options.webdav = {
		enable = mkEnableOption "webdav";
	};
	config = mkIf (config.webdav.enable && pkgs.stdenv.isLinux) {
		networking.firewall.allowedTCPPorts = [
			4918
		];

		services.webdav-server-rs = {
			enable					= true;

			settings = {
				server.listen		= [ "0.0.0.0:4918" "[::]:4918" ];

				accounts = {
					auth-type		= "pam";
					acct-type		= "unix";
				};
				location = [{
					route			= [ "/src/venafi" ];
					directory		= "/home/m/src/venafi";
					handler			= "filesystem";
					methods			= [ "webdav-ro" ];

					autoindex		= true;
					auth			= "true";
					setuid			= true;
				}];

				pam = {
					service			= "other";
				};
			};
		};
	};
}

