{ config, pkgs, lib, fetchzip, ... }:
with lib;

let
	cfg = config.gui;
in
{
	# Options consumers of this module can set
	options.amdgpu = {
		enable = mkEnableOption "Enable everything needed for systems with an AMD GPU";
	};
	config = mkIf cfg.enable {
		# amdgpu
		boot.initrd.kernelModules = [ "amdgpu" ];

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

