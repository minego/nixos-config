{ pkgs, config, lib, ... }:
with lib;

{
	# Enabling sync for chromium:
	#	https://www.learningtopi.com/sbc/chromium-sync/
	#
	#	NOTE: Each google account used for sync MUST be a member of both groups
	#	listed on that page. Read the instructions carefully when adding a new
	#	account.
	#
	#	The wrapper below reads the secrets from the .age file and sets them
	#	as environment variables before starting chromium.
	environment.systemPackages = with pkgs; [
		(pkgs.symlinkJoin {
			name								= "chromium";
			paths = [
				(pkgs.writeShellScriptBin "chromium" ''
					. ${config.age.secrets.chromium-sync-oauth.path}

					exec ${pkgs.chromium}/bin/chromium $@
					'')

				chromium
			];
		})

		chromium
	];

	programs.chromium = {
		enable									= true;

		# View details about chrome policies by visiting:
		#		chrome://policy/
		extraOpts = {
			# BrowserSignin						= 0;
			SyncDisabled						= false;
			PasswordManagerEnabled				= false;
			BuiltInDnsClientEnabled				= true;
			MetricsReportingEnabled				= false;
			SpellcheckEnabled					= true;
			SpellcheckLanguage					= [ "en-US" ];

			FullRestoreEnabled                  = true;
			FullRestoreMode                     = 1; # Always restore the last session
			RestoreOnStartup                    = 1; # Restore the last session

			"3rdparty".extensions = {
				# Bitwarden
				"nngceckbapebfimnlniiiahkandclblb" = {
					environment.base			= "https://bitwarden.minego.net";
				};

				# Surfingkeys
				"gfbliohnnapiefjpjlpjnehglfpaknnc" = {
					incognito					= true;
					newAllowFileAccess			= true;

					preferences = {
						showModeStatus			= true;
						showProxyInStatusBar	= true;
						omnibarPosition			= "bottom";
						caseSensitive			= false;
						smartCase				= true;

						proxy = {
						};
					};
				};
			};
		};

		extensions = [
			"gfbliohnnapiefjpjlpjnehglfpaknnc" # Surfingkeys
			"nngceckbapebfimnlniiiahkandclblb" # Bitwarden
			"gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
			"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
			"dofmpfndepckmehaaoplniohdibnplmg" # Tab Group Focus (Open new tabs in the current tab group)
			"glnpjglilkicbckjpbgcfkogebgllemb" # Okta
			"epmieacohbnladjdcjinfajhepbfaakl" # Blackout
			"ebboehhiijjcihmopcggopfgchnfepkn" # CHROLED - Borderless, pure black theme
			"padekgcemlokbadohgkifijomclgjgif" # Proxy SwitchyOmega
			"fnaicdffflnofjppbagibeoednhnbjhg" # floccus (bookmark and tab sync)
		];
	};

	xdg.mime = {
		enable = true;

		defaultApplications = {
			"text/html"					= "chromium.desktop";
			"x-scheme-handler/http"		= "chromium.desktop";
			"x-scheme-handler/https"	= "chromium.desktop";
			"x-scheme-handler/about"	= "chromium.desktop";
			"x-scheme-handler/unknown"	= "chromium.desktop";
		};
	};

	environment.sessionVariables = {
		BROWSER			= "${pkgs.firefox}/bin/firefox";
		DEFAULT_BROWSER	= "${pkgs.firefox}/bin/firefox";
	};
}
