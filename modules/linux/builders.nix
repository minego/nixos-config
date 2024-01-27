{ config, pkgs, lib, ... }:
with lib;

{
	options.builders = {
		enable		= mkEnableOption "Enable builds using remote builders";
		cache		= mkEnableOption "Host a binary cache for other machines";

		dent		= mkEnableOption "Use dent as a builder";
		zaphod		= mkEnableOption "Use zaphod as a builder";
		hotblack	= mkEnableOption "Use hotblack as a builder";
	};

	config = mkIf (config.builders.enable) {
		nix.buildMachines = []
		++ lib.optionals(config.builders.dent) [{
			hostName			= "dent-builder";
			systems				= ["x86_64-linux"];
			protocol			= "ssh-ng";

			maxJobs				= 32;
			speedFactor			= 8;
			supportedFeatures	= [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			mandatoryFeatures	= [ ];
		}]
		++ lib.optionals(config.builders.zaphod) [{
			hostName			= "zaphod-builder";
			systems				= ["aarch64-linux"];
			protocol			= "ssh-ng";

			maxJobs				= 8;
			speedFactor			= 2;
			supportedFeatures	= [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			mandatoryFeatures	= [ ];
		}]
		++ lib.optionals(config.builders.hotblack) [{
			hostName			= "hotblack-builder";
			systems				= ["x86_64-linux"];
			protocol			= "ssh-ng";

			maxJobs				= 8;
			speedFactor			= 5;
			supportedFeatures	= [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			mandatoryFeatures	= [ ];
		}];

		nix.distributedBuilds	= true;

		# optional, useful when the builder has a faster internet connection than yours
		nix.extraOptions		= "builders-use-substitutes = true";

		# This requires root having a key that is trusted by the builders, and
		# does not prompt for a passphrase.
		#
		# This can be done by creating a new key and adding it to the trusted
		# list or by doing something like:
		#
		#		sudo mkdir -p /root/.ssh
		#		sudo cp ~/.ssh/id_ed25519* /root/.ssh/
		#		sudo ssh-keygen -p -N "" -f /root/.ssh/id_ed25519
		#
		#
		# Additionally the remote builder needs to sign packages, so it needs a
		# key for that purpose and that needs to be trusted by the local box.
		#
		#	cd /var
		#	sudo nix-store --generate-binary-cache-key binarycache.$(hostname -s) cache-priv-key.pem cache-pub-key.pem
		#	sudo chown nix-serve cache-priv-key.pem
		#	sudo chmod 600 cache-priv-key.pem
		#	sudo $(which nix) store sign --all -k /var/cache-priv-key.pem
		#	cat cache-pub-key.pem
		#
		# The public key should then be added to the list below:
		#

		nix.settings = {
			trusted-users = [
				"root"
				"@wheel"
			];

			trusted-public-keys = [
				"dent:Zemx3xLrAPvvAFOiK9QUjeTSoKrZ/TclqQ+WIyYSpFU="
				"hotblack:Jrz20HhPde23eQOdKxyfqNtQ6GbSCIVMTLwRdkUbVds="
				"binarycache.zaphod2:+Ld5Ku7ZRYWG62/b5z6ZLT2e7VENzrHV32uf9Wk3puU="
				"binarycache.hotblack:ksw182xvbAMU33TF80hjCJgyzWTHmoVWS6IKHg1PmAM="
			];
			trusted-substituters = []
			++ lib.optionals(config.builders.dent) [
				"ssh-ng://dent-builder"
			]
			++ lib.optionals(config.builders.hotblack) [
				"ssh://hotblack-builder"
			]
			++ lib.optionals(config.builders.zaphod) [
				"ssh://zaphod-builder"
			];
		};

		programs.ssh.extraConfig= ''
            Host dent-builder
              IdentityFile		/root/.ssh/id_ed25519
              User				m
              Hostname			dent
            
            Host hotblack-builder
              IdentityFile		/root/.ssh/id_ed25519
              User				m
              Hostname			hotblack

            Host zaphod-builder
              IdentityFile		/root/.ssh/id_ed25519
              User				m
              Hostname			zaphod
            '';

		# Allow others to use this machine as a binary cache too
		nix.sshServe = mkIf (config.builders.cache) {
			enable				= true;
			protocol			= "ssh-ng";
			keys				= config.authorizedKeys.keys;
		};

		services.nix-serve = mkIf (config.builders.cache) {
			enable				= true;
			secretKeyFile		= "/var/cache-priv-key.pem";
		};

		services.nginx = mkIf (config.builders.cache) {
			enable				= true;
			recommendedProxySettings = true;

			virtualHosts = {
				"binarycache.${config.networking.hostName}" = {
					locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
				};
			};
		};
	};
}

