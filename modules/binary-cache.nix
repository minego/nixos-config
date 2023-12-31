{ pkgs, config, lib, ... }:
with lib;

# Note: Just enabling this won't actually setup the binary cache, since that
# requires some manual steps, like generating the key.
#
# https://nixos.wiki/wiki/Binary_Cache

let
	cfg = config.binary-cache;
in {
	options.binary-cache = {
		enable		= mkEnableOption "Binary Cache";
		server		= mkEnableOption "Serve this machine's binary cache";
		consume		= mkEnableOption "Use binarycache.minego.net as a binary cache";
	};

	config = mkIf cfg.enable {
		# Enable nix-serve itself
		services.nix-serve = if cfg.server
			then {
				enable = true;
				secretKeyFile = "/var/cache-priv-key.pem";
			} else {};

		# Enable nginx with a virtual host for 'binarycache.minego.net'
		services.nginx = if cfg.server
			then {
				enable = true;
				recommendedProxySettings = true;

				virtualHosts = {
					"binarycache.minego.net" = {
						locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
					};
				};
			} else {};

		# Open the firewall if needed
		networking.firewall.allowedTCPPorts = if cfg.server then [ 80 ] else [];

		# Use the binary cache at binarycache.minego.net
		nix = if cfg.consume
			then {
				settings = {
					substituters = [
						"http://binarycache.minego.net"
						"https://nix-community.cachix.org"
						"https://cache.nixos.org/"
					];
					trusted-public-keys = [
						"binarycache.minego.net-1:Pd90bPhD57JrslIi4oWU4keokwrS01x6VGJv3OyFI3Y=%"
						"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
					];
				};
			} else { };
	};
}

