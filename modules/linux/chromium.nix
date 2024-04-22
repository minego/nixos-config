{ pkgs, config, lib, ... }:
with lib;

{
	# I guess `programs.chromium.enable` doesn't add the package? Weird...
	environment.systemPackages = with pkgs; [
		chromium
	];

	programs.chromium = {
		enable									= true;

		# View details about chrome policies by visiting:
		#		chrome://policy/
		extraOpts = {
			BrowserSignin						= 0;
			SyncDisabled						= true;
			PasswordManagerEnabled				= false;
			BuiltInDnsClientEnabled				= false;
			MetricsReportingEnabled				= true;
			SpellcheckEnabled					= true;
			SpellcheckLanguage					= [ "en-US" ];

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
		];
	};

	xdg.mime = {
		enable = true;

#		defaultApplications = {
#			"text/html"					= "chromium.desktop";
#			"x-scheme-handler/http"		= "chromium.desktop";
#			"x-scheme-handler/https"	= "chromium.desktop";
#			"x-scheme-handler/about"	= "chromium.desktop";
#			"x-scheme-handler/unknown"	= "chromium.desktop";
#		};
	};

#	environment.sessionVariables = {
#		BROWSER			= "${pkgs.firefox}/bin/firefox";
#		DEFAULT_BROWSER	= "${pkgs.firefox}/bin/firefox";
#	};
}
