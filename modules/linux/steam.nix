{ pkgs, ... }:

{
	hardware.steam-hardware.enable = true;

	# Install steam globally, because we're all gonna want it.
	programs.steam = {
		enable							= true;
		remotePlay.openFirewall			= true;
		dedicatedServer.openFirewall	= true;

		gamescopeSession.enable			= true;
	};

	environment.systemPackages = with pkgs; [
		steam-run
		steam-tui
	];

	programs.gamemode.enable			= true;
}

