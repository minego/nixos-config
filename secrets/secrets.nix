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
}


