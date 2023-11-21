{ dwl, swapmods, mackeys, ... }:
{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ];

	networking.hostName = "lord";
	time.timeZone = "America/Denver";
	boot.initrd.luks.devices."luks-7c93fd91-b48e-49bb-9de9-28832248b424".device = "/dev/disk/by-uuid/7c93fd91-b48e-49bb-9de9-28832248b424";
}
