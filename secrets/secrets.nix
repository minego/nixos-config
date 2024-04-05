# Usage:
#
#	1. Add an entry in the main list below, and set the list of public keys
#	that should be allowed to decrypt it.
#
#	2. Create the actual encrypted file with:
#		`agenix -e "$name.age"
#
#	3. Add an entry to the host's `age.secrets` config:
#		"${name}" = {
#			file	= ../../secrets/${name}.age;
#			owner	= "root";
#			group	= "users";
#			mode	= "400";
#		};
#
#	4. Reference the resulting file where appropriate in the nix config:
#		config.age.secrets.${name}.path;

let
	hotblack						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfrwQzGDRICpbmMHns9QaAxjtEkG5IEzpAJBvdgEbB3";
	m_hotblack						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi";

	hosts							= [ hotblack ];
	users							= [ m_hotblack ];
in
{
	"hotblack-dashboard-env.age".publicKeys		= users ++ hosts;
	"hotblack-cloudflare-user.age".publicKeys	= users ++ hosts;
	"hotblack-cloudflare-key.age".publicKeys	= users ++ hosts;

	"foscam-password.age".publicKeys				= users ++ hosts;
}


