{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ];

	# Enable networking, with DHCP and a bridge device
	networking.hostName = "hotblack";

	networking.useDHCP = false;
	networking.interfaces.eno1.useDHCP = true;
	networking.interfaces.br0.useDHCP = true;
	networking.bridges = {
		"br0" = {
			interfaces = [ "eno1" ];
		};
	};

	time.timeZone = "America/Denver";

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	# Load nvidia driver for Xorg and Wayland
	services.xserver.videoDrivers = ["nvidia"];

	hardware.nvidia = {
		# Modesetting is required.
		modesetting.enable = true;

		# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
		powerManagement.enable = false;

		# Fine-grained power management. Turns off GPU when not in use.
		# Experimental and only works on modern Nvidia GPUs (Turing or newer).
		powerManagement.finegrained = false;

		# Use the NVidia open source kernel module (not to be confused with the
		# independent third-party "nouveau" open source driver).
		# Support is limited to the Turing and later architectures. Full list of 
		# supported GPUs is at: 
		# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
		# Only available from driver 515.43.04+
		# Currently alpha-quality/buggy, so false is currently the recommended setting.
		open = false;

		# Enable the Nvidia settings menu,
		# accessible via `nvidia-settings`.
		nvidiaSettings = true;

		# Optionally, you may need to select the appropriate driver version for your specific GPU.
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	# Enable support for scanners
	hardware.sane.enable = true;
	users.users.m.extraGroups = [ "scanner" "lp" ];
}
