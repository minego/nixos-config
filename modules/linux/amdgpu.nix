{ pkgs, ... }:

{
	# amdgpu
	boot = {
		initrd.kernelModules				= [ "amdgpu" ];
		kernelParams						= [ "amdgpu.dpm=1" ];
	};
	environment.variables.AMD_VULKAN_ICD	= "RADV";

	hardware.opengl = {
		enable								= true;
		driSupport							= true;
		driSupport32Bit						= true;
	};

	hardware.opengl.extraPackages = with pkgs; [
#		amdvlk
		rocmPackages.clr.icd
	];

#	hardware.opengl.extraPackages32 = with pkgs; [
#		driversi686Linux.amdvlk
#	];

	environment.systemPackages = with pkgs; [
		clinfo
		blender-hip
		rocmPackages.clr
		vulkan-tools # For tools such as vulkaninfo
	];

	systemd.tmpfiles.rules = 
		let
			rocmEnv = pkgs.symlinkJoin {
				name						= "rocm-combined";
				paths = with pkgs.rocmPackages; [
					rocblas
					hipblas
					clr
				];
			};
	in [
		"L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
	];
}

