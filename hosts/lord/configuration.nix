{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ];

	networking.hostName = "lord";
	time.timeZone = "America/Denver";
	boot.initrd.luks.devices."luks-7c93fd91-b48e-49bb-9de9-28832248b424".device = "/dev/disk/by-uuid/7c93fd91-b48e-49bb-9de9-28832248b424";

	services.fstrim.enable = lib.mkDefault true;

	boot = {
		kernelParams = [
			# Disable "Panel Self Refresh".  Fix random freezes on the X270.
			"i915.enable_psr=0"
		];

		# acpi_call is needed for tlp to work properly on the thinkpad
		kernelModules = [ "acpi_call" ];
		extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
	};
}
