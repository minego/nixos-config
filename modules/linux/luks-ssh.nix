# https://nixos.wiki/wiki/Remote_LUKS_Unlocking

{ config, pkgs, lib, inputs, ... }:
with lib;

{
	options.luks-ssh = {
		enable			= mkEnableOption "Allow unlocking a LUKS volume via ssh";

		modules			= mkOption{
			default		= [];
			description	= ''
                A list of kernel modules to load for the network driver. This
                can be determined by running:
                	lspci -v | grep -iA8 'network\|ethernet'
                '';
		};
	};

	config = mkIf (config.luks-ssh.enable) {
		boot.initrd.network = {
			enable				= true;
			ssh = {
				enable			= true;
				port			= 22;
				shell			= "/bin/cryptsetup-askpass";
				authorizedKeys	= config.authorizedKeys.keys;
				hostKeys		= [
					"/etc/ssh/ssh_host_ed25519_key"
					"/etc/ssh/ssh_host_rsa_key"
				];
			};
		};

		boot.initrd.availableKernelModules = config.luks-ssh.modules;
	};
}
