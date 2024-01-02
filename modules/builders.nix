{ config, pkgs, lib, ... }:
with lib;

{
	options.builders = {
		enable		= mkEnableOption "Enable builds using remote builders";

		dent		= mkEnableOption "Use dent as a builder";
		hotblack	= mkEnableOption "Use hotblack as a builder";
	};

	config = mkIf (config.builders.enable) {
		nix.buildMachines = []
		++ lib.optionals(config.builders.dent) [{
			hostName			= "dent-builder";
			systems				= ["x86_64-linux" "aarch64-linux"];
			protocol			= "ssh-ng";

			maxJobs				= 32;
			speedFactor			= 8;
			supportedFeatures	= [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			mandatoryFeatures	= [ ];
		}]
		++ lib.optionals(config.builders.hotblack) [{
			hostName			= "hotblack-builder";
			systems				= ["x86_64-linux" "aarch64-linux"];
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
		#		sudo cp ~/.ssh/id_ed25519* /root/.ssh/
		#		sudo ssh-keygen -p -N "" -f /root/.ssh/id_ed25519
		#
		#
		# Additionally the remote builder needs to sign packages, so it needs a
		# key for that purpose and that needs to be trusted by the local box.
		#
		#	cd /var
		#	nix-store --generate-binary-cache-key binarycache.example.com cache-priv-key.pem cache-pub-key.pem
		#	chown nix-serve cache-priv-key.pem
		#	chmod 600 cache-priv-key.pem
		#	sudo $(which nix) store sign --all -k cache-priv-key.pem
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
			];
			trusted-substituters = [
				"ssh-ng://dent-builder"
				"ssh://hotblack-builder"
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
            '';

		# Allow others to use this machine as a binary cache too
		nix.sshServe = {
			enable		= true;
			protocol	= "ssh-ng";
			keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL m@dent"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeoTPiXAOmtOWU5oAajvYX+QBOUVF3yyObGii16BQ/+ m@lord"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi m@hotblack"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV m@zaphod"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyOr1jFfS3I12H73/phT6OLCcz5joIYOVOQgiR1OpHv m@random"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpCf3ELP19jIwlrm9zMiPhzHUAQQ1shXgIrbrYmPpnj phone"
			];
		};
	};
}

