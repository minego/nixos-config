{ pkgs, config, lib, ... }:
with lib;

let
	cfg = config.binary-cache;
in {
	options.binary-cache = {
		enable		= mkEnableOption "Binary Cache";
	};

	config = mkIf cfg.enable {
		# Server the binary cache over ssh
		nix.sshServe.enable		= true;
		nix.sshServe.keys		= [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL m@dent"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeoTPiXAOmtOWU5oAajvYX+QBOUVF3yyObGii16BQ/+ m@lord"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi m@hotblack"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV m@zaphod"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyOr1jFfS3I12H73/phT6OLCcz5joIYOVOQgiR1OpHv m@random"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpCf3ELP19jIwlrm9zMiPhzHUAQQ1shXgIrbrYmPpnj phone"
		];
	};
}
