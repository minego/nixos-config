{ config, pkgs, lib, ... }:
with lib;

{
	services.ombi = {
		enable			= true;
		port			= 5005;
		openFirewall	= true;
		group			= "plex";
	};

	# Reverse proxy with subdir
    services.nginx.virtualHosts."${config.services.nginx.hostname}" = {
		locations."/ombi" = {
			proxyPass = "http://127.0.0.1:5005";
			extraConfig = ''
				client_max_body_size 10m;
				client_body_buffer_size 128k;

				# Timeout if the real server is dead
				proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

				# Advanced Proxy Config
				send_timeout 5m;
				proxy_read_timeout 240;
				proxy_send_timeout 240;
				proxy_connect_timeout 240;

				# Basic Proxy Config
				proxy_set_header Host $host:$server_port;
				proxy_set_header X-Real-IP $remote_addr;
				proxy_set_header X-Forwarded-Host $server_name;
				proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
				proxy_set_header X-Forwarded-Proto https;
				proxy_redirect  http://  $scheme://;
				proxy_http_version 1.1;
				proxy_set_header Upgrade $http_upgrade;
				proxy_set_header Connection "upgrade";
				proxy_cache_bypass $cookie_session;
				proxy_no_cache $cookie_session;
				proxy_buffers 32 4k;
				proxy_redirect http://127.0.0.1:5005 https://$host;
			'';
		};
	};

	# Override startup arguments so we can set baseurl, which is required for
	# use with a reverse proxy in a subdir
	systemd.services.ombi.serviceConfig.ExecStart = 
		let cfg = config.services.ombi; in
		lib.mkForce "${lib.getExe pkgs.ombi} --storage '${cfg.dataDir}' --host 'http://*:${toString cfg.port}' --baseurl /ombi";

}

