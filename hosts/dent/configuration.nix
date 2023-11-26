{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

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

	networking.hostName = "dent";

	# Enable Network Manager
	networking.networkmanager.enable = true;
	programs.nm-applet.enable = true;

	time.timeZone = "America/Denver";
}
