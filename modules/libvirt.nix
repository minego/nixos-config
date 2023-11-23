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
			qemu = {
				swtpm.enable = true;
				ovmf.enable = true;
				ovmf.packages = [ pkgs.OVMFFull.fd ];
			};
		};
		spiceUSBRedirection.enable = true;
	};
	services.spice-vdagentd.enable = true;
}

