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

	dent							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpnfpoW0qVQ52DgebLZiUt9XV+9tnRKqbJl3qTwNnAO";
	m_dent							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL";

	zaphod2							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjIL6OCooExk6DM8BjDLKLYD89VpCQJbxo1BD/vis2a";
	m_zaphod2						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV";

	hosts							= [ hotblack dent zaphod2 ];
	users							= [ m_hotblack m_dent m_zaphod2 ];
in
{
	"hotblack-dashboard-env.age".publicKeys		= [ hotblack m_hotblack ];
	"hotblack-cloudflare-user.age".publicKeys	= [ hotblack m_hotblack ];
	"hotblack-cloudflare-key.age".publicKeys	= [ hotblack m_hotblack ];
	"foscam-password.age".publicKeys			= [ hotblack m_hotblack ];
	"frigateplus-key.age".publicKeys			= [ hotblack m_hotblack ];

	"chromium-sync-oauth.age".publicKeys		= users ++ hosts;
}


