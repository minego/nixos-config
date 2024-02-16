{ config, pkgs, lib, inputs, ... }:

{
	services.syncthing = {
		enable			= true;
		user			= "m";
		dataDir			= "/home/m/Documents";
		configDir		= "/home/m/Documents/.config/syncthing";

		overrideDevices	= true;     # overrides any devices added or deleted through the WebUI
		overrideFolders	= true;     # overrides any folders added or deleted through the WebUI

		settings = {
			devices = {
				"dent"		= { id = "6FZOYPY-GJDXGSF-EXZCLND-W4HHXVG-XCIABQO-KXQ4YTB-XGMWF7A-K4WDGQE"; };
				"zaphod2"	= { id = "HAS6HSV-BOM63S2-YJMIQNC-COLZMBU-F2BPIL7-ULY3AL7-CERGJEY-BHAXUQX"; };
				"pixel7"	= { id = "L4KCXPG-5LK5DFR-I3RSZOD-T43RKOG-GKU7HTK-QSMRU33-TIQP3TX-EKO2YQN"; };
				"zem"		= { id = "TFBJXJ5-XKVNFHI-HVJ5X3N-ATR3XKF-EIKXFLQ-C6XX4K5-UDZUPS7-OJ2TXQF"; };
				"random"	= { id = "OV3MXZG-LWYH4RW-D7SILOK-YFUVDLG-BXMHKNC-XFQHOKO-66DZL4Y-N6OPWQT"; };
				"wonko"		= { id = "FENARYZ-NAJAM4L-MK5BIUP-SUDBIJI-HGTSNBW-BVGPKTX-JS4UEAC-F534SQY"; };
			};

			folders = {
				"Notes" = {	# Name of folder in Syncthing, also the folder ID
					enable	 = true;
					id		= "notes";
					path	= "/home/m/notes";
					devices	= [ "dent" "pixel7" "zaphod2" "wonko" ];
				};

				"Code" = {
					enable	 = true;
					id		= "code";
					path	= "/home/m/src/shared";
					devices	= [ "dent" "zaphod2" "zem" "random" "wonko" ];
				};
			};
		};
	};

	# Syncthing ports:
	#	8384/TCP			Remote access to GUI - Do NOT open here
	#	22000/TCP+UDP		Sync traffic
	#	21027/UDP			Discovery

	networking.firewall.allowedTCPPorts = [ 22000 ];
	networking.firewall.allowedUDPPorts = [ 22000 21027 ];

	# The .stignore file is created using home-manager, in 'users/m/home.nix'


	environment.systemPackages = with pkgs; [
		# cli tool for Sync Thing
		(pkgs.writeShellScriptBin "stc" ''
            exec ${pkgs.stc-cli}/bin/stc -homedir "${config.services.syncthing.configDir}" "$@"
            ''
		)
	];
}
