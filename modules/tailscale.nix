{ pkgs, config, lib, ... }:
with lib;

{
	services.tailscale = {
		enable					= mkDefault true;
		openFirewall			= true;

		# Set to "server" or "both" with mkForce if needed for specific machines
		useRoutingFeatures		= mkDefault "client";
	};

	systemd.services.tailscale-autoconnect = {
		description				= "Automatic connection to Tailscale";

		# make sure tailscale is running before trying to connect to tailscale
		after					= [ "network-pre.target" "tailscale.service" ];
		wants					= [ "network-pre.target" "tailscale.service" ];
		wantedBy				= [ "multi-user.target" ];

		# set this service as a oneshot job
		serviceConfig.Type		= "oneshot";

		script = with pkgs; ''
            # wait for tailscaled to settle
            sleep 2
            
            # check if we are already authenticated to tailscale
            status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
            if [ $status = "Running" ]; then
				echo "Already connected"
                exit 0
            fi

            if [ $status = "NeedsLogin" ]; then
				echo "Login is required; Run 'sudo tailscale up' manually once."
                exit 0
            fi
            
            ${tailscale}/bin/tailscale up --timeout 10s
            '';
	};

}
