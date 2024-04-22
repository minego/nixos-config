{ pkgs, config, lib, ... }:
with lib;

let
	ff = if pkgs.stdenv.isDarwin
		then pkgs.firefox-bin
		else pkgs.firefox-wayland;
in

{
	programs.firefox = {
		enable = true;

		# NOTE: This depends on placing the tridactylrc file with home-manager
#		nativeMessagingHosts.packages = [
#			pkgs.tridactyl-native
#		];
		package = ff;

		policies = {
			ExtensionSettings = with builtins;

			let extension = shortId: uuid: {
				name	= uuid;
				value	= {
					install_url			= "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
					installation_mode	= "normal_installed";
				};
			};

			# TODO
			#	- Automate configuration of extensions, such as surfing keys
			#	- Automate ui settings, such as pinned extensions, and hiding the side bar
			#	- Update default applications so it calls a script that we can
			#	use to look at the URL and decide which profile to use

			in listToAttrs ([
				(extension "bitwarden-password-manager"			"{446900e4-71c2-419f-a6a7-df9c091e268b}")
				(extension "ublock-origin"						"uBlock0@raymondhill.net")
				(extension "protondb-for-steam"					"{30280527-c46c-4e03-bb16-2e3ed94fa57c}")
				(extension "i-dont-care-about-cookies"			"jid1-KKzOGWgsW3Ao4Q@jetpack")
				(extension "sponsorblock"						"sponsorBlocker@ajay.app")

				(extension "oled-borderless-pitch-black"		"{47400ad1-545d-449a-85f6-f9edfc7e590a}")

				(extension "okta-browser-plugin"				"plugin@okta.com")

				(extension "multi-account-containers"			"@testpilot-containers")

				# (extension "tridactyl-vim"						"tridactyl.vim@cmcaine.co.uk")
				(extension "surfingkeys_ff"						"{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}")
				(extension "simple-tab-groups"					"simple-tab-groups@drive4ik")
			]);

			# To find the `shortId` and `uuid` arguments for the `extension()`
			# function:
			#
			#	`shortId` is the value used in the URL to the addon. For
			#	example, the "Firefox Multi-Account Containers" addon's URL is
			#	and the shortId is `multi-account-containers`
			#		https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/
			#
			#	`uuid` can be found by installing the extension manually and
			#	looking for the `Extension ID` value from this page:
			#		about:debugging#/runtime/this-firefox
			#
			# Check for errors by visiting:
			#		about:policies#errors
		} // {
			# Add any other policies here

			# Bitwarden
			"3rdparty".extensions = {
				"{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
					environment.base			= "https://bitwarden.minego.net";
				};
			};

			AppAutoUpdate							= false;
			BackgroundAppUpdate						= false;
			DisableFirefoxStudies					= true;
			DisableProfileImport					= true;

			DisableSetDesktopBackground				= true;
			DisplayMenuBar							= "default-off";
			DisablePocket							= true;
			DisableTelemetry						= true;
			OfferToSaveLogins						= false;
			EnableTrackingProtection = {
				Value								= true;
				Locked								= true;
				Cryptomining						= true;
				Fingerprinting						= true;
				EmailTracking						= true;
				# Exceptions = ["https://example.com"]
			};
			EncryptedMediaExtensions = {
				Enabled = true;
				Locked = true;
			};

			FirefoxHome = {
				Search								= false;
				TopSites							= false;
				SponsoredTopSites					= false;
				Highlights							= false;
				Pocket								= false;
				SponsoredPocket						= false;
				Snippets							= false;
				Locked								= true;
			};

			FirefoxSuggest = {
				WebSuggestions						= false;
				SponsoredSuggestions				= false;
				ImproveSuggest						= false;
				Locked								= true;
			};

			PasswordManagerEnabled					= false;
			ShowHomeButton							= false;

			UserMessaging = {
				ExtensionRecommendations			= false;
				FeatureRecommendations				= false;
				MoreFromMozilla						= false;
				SkipOnboarding						= true;
				UrlbarInterventions					= false;
				WhatsNew							= false;
				Locked								= true;
			};
			UseSystemPrintDialog = true;

		};

		preferences = {
			"extensions.pocket.enabled"				= false;
			"extensions.screenshots.disabled"		= false;

			"browser.uitour.enabled"				= false;
			"signon.rememberSignons"				= false;
			"app.update.auto"						= false;
			"browser.aboutConfig.showWarning"		= false;
			"browser.warnOnQuit"					= false;
			"browser.quitShortcut.disabled"			= false;

			"browser.theme.dark-private-windows"	= true;

			# Restore previous session
			"browser.startup.page"					= 3;

			# Make new tabs blank
			"browser.newtabpage.enabled"			= false;

			# Enable hardware video acceleration
			"media.ffmpeg.vaapi.enabled"			= true;

			"dom.forms.autocomplete.formautofill"	= false;
			"dom.payments.defaults.saveAddress"		= false;
			"ui.systemUsesDarkTheme"				= true;

			# Don't stop me from using extensions on mozilla pages!
			"extensions.webextensions.restrictedDomains" = "";
		};
	};

	xdg.mime = {
		enable = true;

		defaultApplications = {
			"text/html"					= "firefox.desktop";
			"x-scheme-handler/http"		= "firefox.desktop";
			"x-scheme-handler/https"	= "firefox.desktop";
			"x-scheme-handler/about"	= "firefox.desktop";
			"x-scheme-handler/unknown"	= "firefox.desktop";
		};
	};

	# Enable xinput2 in firefox
	environment.sessionVariables = {
		MOZ_USE_XINPUT2 = "1";

		BROWSER			= "${pkgs.firefox}/bin/firefox";
		DEFAULT_BROWSER	= "${pkgs.firefox}/bin/firefox";

		# Make wayland applications behave
		NIXOS_OZONE_WL	= "1";

		MALLOC_CHECK_	= "2";	# stupid linux malloc
	};
}

