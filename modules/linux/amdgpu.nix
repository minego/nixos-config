{ config, pkgs, lib, fetchzip, ... }:
with lib;

{
	# Options consumers of this module can set
	options.amdgpu = {
		enable = mkEnableOption "AMD GPU";
	};
	config = mkIf (config.amdgpu.enable && pkgs.stdenv.isLinux) {
		# amdgpu
		boot = {
			initrd.kernelModules = [ "amdgpu" ];
			kernelParams = [ "amdgpu.dpm=1" ];
		};

		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};

		hardware.opengl.extraPackages = with pkgs; [
			rocm-opencl-icd
			rocm-opencl-runtime
			amdvlk
		];

		hardware.opengl.extraPackages32 = with pkgs; [
			driversi686Linux.amdvlk
		];

		environment.systemPackages = with pkgs; [
			clinfo
			blender-hip
			rocmPackages.clr
		];

		systemd.tmpfiles.rules = [
			"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
		];
	};
}

