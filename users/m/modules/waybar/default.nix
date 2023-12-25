{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	config = mkIf (config.dwl.enable && osConfig.gui.enable && pkgs.stdenv.isLinux) {
		home.packages = with pkgs; [
			waybar

			# Needed by the waybar-dwl helper script
			inotify-tools

			# Used with "custom/audio_idle_inhibitor" below
			sway-audio-idle-inhibit
		];

		# Waybar
		programs.waybar = rec {
			enable = osConfig.gui.enable && config.dwl.enable;

			style = "${./waybar.css}";

			settings = [{
				layer =		"bottom";
				position =	"top";
				height =	24;

				modules-left = [
					"custom/dwl_tag#0" "custom/dwl_tag#1" "custom/dwl_tag#2"
					"custom/dwl_tag#3" "custom/dwl_tag#4" "custom/dwl_tag#5"
					"custom/dwl_tag#6" "custom/dwl_tag#7" "custom/dwl_tag#8"
					"custom/dwl_tag#9" "custom/dwl_layout" "custom/dwl_title"
				];
				modules-center = [];
				modules-right = [
					"mpris"
					"custom/cpuusage" "custom/cpuhist"
					"pulseaudio" "network"
					"battery" "battery#1"
					"bluetooth" "tray"

					"custom/audio_idle_inhibitor"
					"clock"
					"custom/notification"
				];

				backlight = {
					device					= "intel_backlight";
					format					= "{percent}% {icon}";
					format-icons			= ["" ""];
				};

				idle_inhibitor = {
					format					= " {icon} ";
					format-icons = {
						activated			= "󰅶";
						deactivated			= "󰾪";
					};
				};

				"custom/audio_idle_inhibitor" = {
					format					= "{icon}";
					exec					= "sway-audio-idle-inhibit --dry-print-both-waybar";
					return-type				= "json";
					format-icons = {
						output				= "󰅶";
						output-input		= "󰅶";
						none				= "󰾪";
					};
				};

				tray.spacing				=  15;

				clock = {
					format					= "{:%I:%M %p}";
					format-alt				= "{:%Y-%m-%d}";
				};

				cpu.format					 = "{usage}% ";

				"custom/cpuusage" = {
					format					= "{}";
					return-type				= "json";
					exec					= "${./cpuusage}";
				};

				"custom/cpuhist" = {
					format					= "{} ";
					return-type				= "json";
					exec					= "${./cpuhist}";
				};

				memory.format				= "{}% ";

				"battery" = {
					format					= "{icon}";
					tooltip-format			= "{capacity}% {timeTo}";
					states = {
						warning				= 30;
						critical			= 15;
					};

					format-icons = {
						charging			= ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
						discharging			= ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
						plugged				= ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
					};
				};

				"battery#1" = {
					format					= "{icon}";
					bat						= "BAT2";
					tooltip-format			= "{capacity}% {timeTo}";
					states = {
						warning				= 30;
						critical			= 15;
					};

					format-icons = {
						charging			= ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
						discharging			= ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
						plugged				= ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
					};
				};

				network = {
					tooltip-format-wifi		= "{essid} ({signalStrength}%)";
					format-wifi				= "{icon}";
					format-ethernet			= ""; # Hide this on ethernet

					format-icons			= ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
					format-disconnected		= "󰤫";
				};

				pulseaudio = {
					format					= "{volume}% {icon} {format_source}";
					format-icons			= [ "󰕿" "󰖀" "󰕾" ];

					format-source			= "";
					format-source-muted		= "󰍭";
					scroll-step				= 5;

					on-click				= "pavucontrol";
				};

				mpris = {
					format					= "{status_icon} {title} <span style='italic'>by</span> {artist}";
					format-paused			= " ";
					status-icons = {
						playing				= "▶";
						paused				= "⏸";
					};
				};

				bluetooth = {
					on-click				= "blueberry";

					format										= "";
					format-connected							= " {device_alias}";
					format-connected-battery					= " {device_alias} {device_battery_percentage}%";
					tooltip-format								= "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
					tooltip-format-connected					= "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
					tooltip-format-enumerate-connected			= "{device_alias}\t{device_address}";
					tooltip-format-enumerate-connected-battery	= "{device_alias}\t{device_address}\t{device_battery_percentage}%";

				};

				"custom/dwl_tag#0" = {
					exec										= "${./waybar-dwl.sh} '' 0";
					on-click									= "wtype -M alt 1 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#1" = {
					exec										= "${./waybar-dwl.sh} '' 1";
					on-click									= "wtype -M alt 2 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#2" = {
					exec										= "${./waybar-dwl.sh} '' 2";
					on-click									= "wtype -M alt 3 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#3" = {
					exec										= "${./waybar-dwl.sh} '' 3";
					on-click									= "wtype -M alt 4 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#4" = {
					exec										= "${./waybar-dwl.sh} '' 4";
					on-click									= "wtype -M alt 5 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#5" = {
					exec										= "${./waybar-dwl.sh} '' 5";
					on-click									= "wtype -M alt 6 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#6" = {
					exec										= "${./waybar-dwl.sh} '' 6";
					on-click									= "wtype -M alt 7 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#7" = {
					exec										= "${./waybar-dwl.sh} '' 7";
					on-click									= "wtype -M alt 8 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#8" = {
					exec										= "${./waybar-dwl.sh} '' 8";
					on-click									= "wtype -M alt 9 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_tag#9" = {
					exec										= "${./waybar-dwl.sh} '' 9";
					on-click									= "wtype -M alt 0 -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_layout" = {
					exec										= "${./waybar-dwl.sh} '' layout";
					on-click									= "wtype -M alt ' ' -m alt";
					format										= "{}";
					return-type									= "json";
				};
				"custom/dwl_title" = {
					exec										= "${./waybar-dwl.sh} '' title";
					format										= "{}";
					escape										= true;
					return-type									= "json";
				};

				"custom/notification" = {
					tooltip										= false;
					format										= "  {icon}   ";
					format-icons = {
						notification							= "<span foreground='#ff2a6d'><sup></sup></span>";
						none									= "";
						dnd-notification						= "<span foreground='#ff2a6d'><sup></sup></span>";
						dnd-none								= "";
						inhibited-notification					= "<span foreground='#ff2a6d'><sup></sup></span>";
						inhibited-none							= "";
						dnd-inhibited-notification				= "<span foreground='#ff2a6d'><sup></sup></span>";
						dnd-inhibited-none						= "";
					};
					return-type									= "json";
					exec-if										= "which swaync-client";
					exec										= "swaync-client -swb";
					on-click									= "swaync-client -t -sw";
					on-click-right								= "swaync-client -d -sw";
					escape										= true;
				};
			}];
		};
	};
}
