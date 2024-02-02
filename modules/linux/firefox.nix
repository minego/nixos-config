{ pkgs, config, lib, ... }:
with lib;

{
	programs.firefox = {
		enable = true;

		nativeMessagingHosts.packages = [
			(pkgs.symlinkJoin {
				name = "tridactyl-native-wrapped";
				paths = [
					(pkgs.writeShellScriptBin "native_main" ''
                        export XDG_CONFIG_HOME="${./.}"
                        ${pkgs.tridactyl-native}/bin/native_main $@
                        '')
					pkgs.tridactyl-native
				];
			})
		];

		package =
			if
				pkgs.stdenv.isDarwin
			then
				pkgs.firefox-bin
			else
				pkgs.firefox-wayland;

		policies = {
			ExtensionSettings = with builtins;

			let extension = shortId: uuid: {
				name	= uuid;
				value	= {
					install_url			= "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
					installation_mode	= "normal_installed";
				};
			};

			in listToAttrs [
				(extension "tridactyl-vim"				"tridactyl.vim@cmcaine.co.uk")
				(extension "ublock-origin"				"uBlock0@raymondhill.net")
				(extension "bitwarden-password-manager"	"{446900e4-71c2-419f-a6a7-df9c091e268b}")
				(extension "simple-tab-groups"			"simple-tab-groups@drive4ik")
				(extension "okta-browser-plugin"		"plugin@okta.com")
				(extension "protondb-for-steam"			"{30280527-c46c-4e03-bb16-2e3ed94fa57c}")
				(extension "i-dont-care-about-cookies"	"jid1-KKzOGWgsW3Ao4Q@jetpack")
				(extension "gitlab-notify"				"{dfc14507-bc0e-4d1b-899e-ba09a445acab}")
				(extension "dark"						"firefox-compact-dark@mozilla.org")
				(extension "sponsorblock"				"sponsorBlocker@ajay.app")
				(extension "container-proxy"			"contaner-proxy@bekh-ivanov.me")
			];

			# To find the UUID, install the extension manually and then visit
			#		about:debugging#/runtime/this-firefox
		} // {
			Settings = {
				"extensions.pocket.enabled"				= false;
				"extensions.screenshots.disabled"		= false;

				"signon.rememberSignons"				= false;
				"app.update.auto"						= false;
				"browser.aboutConfig.showWarning"		= false;
				"browser.warnOnQuit"					= false;
				"browser.quitShortcut.disabled"			= false;

				"browser.theme.dark-private-windows"	= true;
				"browser.toolbars.bookmarks.visibility"	= false;

				# Restore previous session
				"browser.startup.page"					= 3;

				# Make new tabs blank
				"browser.newtabpage.enabled"			= false;

				# Disable welcome splash
				"trailhead.firstrun.didSeeAboutWelcome" = true;

				# Enable hardware video acceleration
				"media.ffmpeg.vaapi.enabled"			= true;

				"dom.forms.autocomplete.formautofill"	= false;
				"dom.payments.defaults.saveAddress"		= false;
				"ui.systemUsesDarkTheme"				= true;
				"cookiebanners.ui.desktop.enabled"		= true;
				"devtools.command-button-screenshot.enabled" = true;

				# Don't stop me from using tridactyl on mozilla pages!
				"extensions.webextensions.restrictedDomains" = "";
			};
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
