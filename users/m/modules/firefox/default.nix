{ config, pkgs, lib, osConfig, ... }:
with lib;

{

	options = {
		firefox = {
			enable = lib.mkEnableOption {
				description		= "Enable Firefox.";
				default			= false;
			};
		};
	};

	config = lib.mkIf (osConfig.gui.enable && config.firefox.enable) {
		home.packages = with pkgs; [
			tridactyl-native
		];

		programs.firefox = {
			enable				= true;

			package				=
				if
					pkgs.stdenv.isDarwin
				then
					pkgs.firefox-bin
				else
					pkgs.firefox-wayland;


			profiles.default = {
				id				= 0;
				name			= "default";
				isDefault		= true;

				search = {
					default		= "Google";
					force		= true;
					order = [
						"Google"
						"Nix Packages"
						"NixOS Wiki"
					];

					engines = {
						"Nix Packages" = {
							urls = [{
								template = "https://search.nixos.org/packages";
								params = [
									{ name = "type"; value = "packages"; }
									{ name = "query"; value = "{searchTerms}"; }
								];
							}];

							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
							definedAliases = [ "@np" ];
						};

						"NixOS Wiki" = {
							urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];

							iconUpdateURL = "https://nixos.wiki/favicon.png";
							updateInterval = 24 * 60 * 60 * 1000; # every day
							definedAliases = [ "@nw" ];
						};

						"Bing".metaData.hidden = true;
						"Twitter".metaData.hidden = true;
						"Facebook".metaData.hidden = true;

						"Google".metaData.alias = "@g";
					};
				};

				extensions = with pkgs.nur.repos.rycee.firefox-addons; [
					bitwarden
					tridactyl
					ublock-origin
					okta-browser-plugin
					sponsorblock
					don-t-fuck-with-paste
					i-dont-care-about-cookies
				];
				settings = {
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

					# Disable autofill
					"dom.forms.autocomplete.formautofill"	= false;

					# Disable address save
					"dom.payments.defaults.saveAddress"		= false;

					"extensions.pocket.enabled"				= false;

					"ui.systemUsesDarkTheme"				= true;

					# Enable hardware video acceleration
					"media.ffmpeg.vaapi.enabled"			= true;

					# Reject cookie popups
					"cookiebanners.ui.desktop.enabled"		= true;

					"devtools.command-button-screenshot.enabled" = true;
				};

				extraConfig = "";
			};
		};

		xdg.mimeApps = mkIf pkgs.stdenv.isLinux {
			enable = true;

			defaultApplications = {
				"text/html"					= "firefox.desktop";
				"x-scheme-handler/http"		= "firefox.desktop";
				"x-scheme-handler/https"	= "firefox.desktop";
				"x-scheme-handler/about"	= "firefox.desktop";
				"x-scheme-handler/unknown"	= "firefox.desktop";
			};
		};

		# Let firefox call tridactyl's native thingy, so the config can be loaded
		home.file.tridactyl-native = {
			source = "${pkgs.tridactyl-native}//lib/mozilla/native-messaging-hosts/tridactyl.json";
			target = "./.mozilla/native-messaging-hosts/tridactyl.json";
		};
		xdg.configFile."tridactyl/tridactylrc".source = ./../../dotfiles/tridactylrc;

		home.sessionVariables = {
			KEYTIMEOUT		= "1";
			VISUAL			= "nvim";
			EDITOR			= "nvim";
			LC_CTYPE		= "C";
		};
	};
}
