{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	# Enable networking, with DHCP and a bridge device
	networking.hostName = "dent";

	networking.useDHCP = false;
	networking.interfaces.enp42s0.useDHCP = true;
	networking.interfaces.br0.useDHCP = true;
	networking.bridges = {
		"br0" = {
			interfaces = [ "enp42s0" ];
		};
	};

	time.timeZone = "America/Denver";

	# amdgpu
	boot.initrd.kernelModules = [ "amdgpu" ];
	hardware.opengl.extraPackages = with pkgs; [
		rocm-opencl-icd
		rocm-opencl-runtime
		amdvlk
	];

	hardware.opengl.extraPackages32 = with pkgs; [
		driversi686Linux.amdvlk
	];

	hardware.opengl.driSupport = true;
	hardware.opengl.driSupport32Bit = true;

	environment.systemPackages = with pkgs; [
		clinfo
		blender-hip
		rocmPackages.clr
	];

	systemd.tmpfiles.rules = [
		"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
	];
}
