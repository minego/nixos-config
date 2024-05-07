{ pkgs, ... }:

{
	hardware.steam-hardware.enable = true;

	# Install steam globally, because we're all gonna want it.
	programs.steam = {
		enable							= true;
		remotePlay.openFirewall			= true;
		dedicatedServer.openFirewall	= true;

		gamescopeSession = {
			enable						= true;
			# args						= [ "--fullscreen" "--max-scale" "1" ];
		};
	};

	environment.systemPackages = with pkgs; [
		steam-run
		steam-tui
		protonup-qt
	];

	programs.gamemode.enable			= true;
	programs.gamescope.enable			= true;
}

