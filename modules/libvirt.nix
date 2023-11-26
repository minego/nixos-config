{ config, pkgs, ... }:
{
	# Enable dconf
	programs.dconf.enable = true;

	# Add my user to libvirtd group
	users.users.m.extraGroups = [ "libvirtd" ];

	# Install necessary packages
	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		spice
		spice-gtk
		spice-protocol
		win-virtio
		win-spice
	];

	# Manage the virtualisation services
	virtualisation = {
		libvirtd = {
			enable = true;
			onShutdown = "suspend";
			onBoot = "ignore";

			qemu = {
				swtpm.enable = true;
				ovmf.enable = true;
				ovmf.packages = [ pkgs.OVMFFull.fd ];
			};
		};
		spiceUSBRedirection.enable = true;
	};
	services.spice-vdagentd.enable = true;
	boot.extraModprobeConfig = "options kvm_intel nested=1";


	environment.etc = {
		"ovmf/edk2-x86_64-secure-code.fd" = {
			source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
		};

		"ovmf/edk2-i386-vars.fd" = {
			source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
		};
	};
}

