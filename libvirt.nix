{ ... }:
{ pkgs, ... }:
{
	virtualisation.libvirtd.enable	= true;
	programs.virt-manager.enable	= true;

	# Add each user to the group as needed
	# users.users._.extraGroups = [ "libvirtd" ];
}
