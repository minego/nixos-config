{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ata_generic" "ehci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_usb_sdmmc" ];
	boot.initrd.kernelModules = [ ];
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [ ];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/fb497512-8861-4c33-bb1d-00ba581bceca";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/FAE2-40E4";
		fsType = "vfat";
	};

	# ZFS pool for media
	fileSystems."/data" = {
		device = "zpool/media";
		fsType = "zfs";
		depends = [ "/" ];
		options = [ "relatime" "nofail" ];
	};

	# Internal media storage drives
#	fileSystems."/mnt/media0" = {
#		device = "/dev/disk/by-uuid/a3cb324b-1f64-40e5-8d89-5d21ca6885b6";
#		fsType = "ext4";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#
#
#	fileSystems."/mnt/media1" = {
#		device = "/dev/disk/by-uuid/6f2e01fa-a22e-4589-9d54-5ff207d8e007";
#		fsType = "ext4";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#	fileSystems."/mnt/media2" = {
#		device = "/dev/disk/by-uuid/2330fe41-7210-4b03-a385-4ba8a4fc629d";
#		fsType = "ext4";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#	
#	# USB disk array media storage drives
#	fileSystems."/mnt/media3" = {
#		device = "/dev/disk/by-uuid/4469726b-ada0-4101-a0ef-eba2c1421bf0";
#		fsType = "auto";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#	fileSystems."/mnt/media4" = {
#		device = "/dev/disk/by-uuid/8c2b6529-bee6-4ed2-ad7e-61d28c9f7726";
#		fsType = "auto";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#	fileSystems."/mnt/media5" = {
#		device = "/dev/disk/by-uuid/611d0f5f-7db6-4676-9583-3bf73e385b94";
#		fsType = "auto";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};
#	fileSystems."/mnt/media6" = {
#		device = "/dev/disk/by-uuid/b8260d70-970c-4ea1-beb8-8107adffcc7a";
#		fsType = "auto";
#		depends = [ "/" ];
#		options = [ "relatime" "nofail" ];
#	};

	# Mergerfs aggregate volume
#	fileSystems."/data" = {
#		device = "/mnt/media?";
#		fsType = "fuse.mergerfs";
#		depends = [
#			"/"
#			"/mnt/media0"
#			"/mnt/media1"
#			"/mnt/media2"
#			"/mnt/media3"
#			"/mnt/media4"
#			"/mnt/media5"
#			"/mnt/media6"
#		];
#		options = [
#			"nofail"
#			"allow_other"
#			"use_ino"
#			"moveonenospc=true"
#			"ignorepponrename=true"
#		];
#	};
#	environment.systemPackages = with pkgs; [
#		mergerfs
#		mergerfs-tools
#	];

	# The 1TB fast nvme m.2 drive
	fileSystems."/mnt/data" = {
		device = "/dev/disk/by-uuid/7c0c654c-ed5a-4ee8-afa7-60ba53934361";
		fsType = "auto";
		depends = [ "/" ];
		options = [ "relatime" "nofail" ];
	};


	swapDevices = [ ];
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
