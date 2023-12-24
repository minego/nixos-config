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
				"dent"		= { id = "L4KCXPG-5LK5DFR-I3RSZOD-T43RKOG-GKU7HTK-QSMRU33-TIQP3TX-EKO2YQN"; };
				"zaphod2"	= { id = "HAS6HSV-BOM63S2-YJMIQNC-COLZMBU-F2BPIL7-ULY3AL7-CERGJEY-BHAXUQX"; };
				"lord"		= { id = "GFOMJN4-SPH4YOO-36L2UQM-22FNFKN-AWFT5YT-C5AHAUK-7CGH4MF-Q3BA4QJ"; };
				"pixel7"	= { id = "L4KCXPG-5LK5DFR-I3RSZOD-T43RKOG-GKU7HTK-QSMRU33-TIQP3TX-EKO2YQN"; };
			};

			folders = {
				"Notes" = {	# Name of folder in Syncthing, also the folder ID
					enable	 = true;
					id		= "notes";
					path	= "/home/m/notes";
					devices	= [ "dent" "lord" "pixel7" ];
				};
			};
		};
	};
}
