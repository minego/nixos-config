{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	config = mkIf (osConfig.gui.enable && config.programs.kitty.enable) {
		programs.kitty = {
			font = {
				name		= "Monaspace Neon";
				package		= pkgs.monaspace;
				size		= 11;
			};

			extraConfig = ''
				font_features    MonaspaceNeon-Light        +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
				font_features    MonaspaceNeon-Regular      +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
				font_features    MonaspaceNeon-Bold         +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
				font_features    MonaspaceNeon-Italic       +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
				font_features    MonaspaceNeon-Bold-Italic  +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
			'';

			keybindings = {
				"kitty_mod+c"			= "copy_to_clipboard";
				"ctrl+insert"			= "copy_to_clipboard";
				"kitty_mod+v"			= "paste_from_clipboard";
				"kitty_mod+s"			= "paste_from_selection";
				"shift+insert"			= "paste_from_clipboard";
				"kitty_mod+o"			= "pass_selection_to_program";

				"alt+shift+c"			= "copy_to_clipboard";
				"alt+shift+v"			= "paste_from_clipboard";

				"super+c"				= "copy_to_clipboard";
				"super+v"				= "paste_from_clipboard";

				"kitty_mod+up"			= "scroll_line_up";
				"kitty_mod+k"			= "scroll_line_up";
				"kitty_mod+down"		= "scroll_line_down";
				"kitty_mod+j"			= "scroll_line_down";
				"kitty_mod+u"			= "scroll_page_up";
				"kitty_mod+d"			= "scroll_page_down";
				"kitty_mod+h"			= "show_scrollback";

				"kitty_mod+e"			= "new_window";

				"kitty_mod+equal"		= "change_font_size all +1.0";
				"kitty_mod+minus"		= "change_font_size all -1.0";
				"kitty_mod+backspace"	= "change_font_size all 0";
			};

			settings = {
				term					= "xterm-kitty";
				kitty_mod				= "ctrl+shift";

				linux_display_server	= "wayland";
				macos_option_as_alt		= true;

				macos_quit_when_last_window_closed	= true;
				macos_traditional_fullscreen		= false;

				confirm_os_window_close	= 0;
				cursor_shape			= "block";
				scrollback_lines		= 2000;

				url_style				= "curly";

				copy_on_select			= false;
				focus_follows_mouse		= false;
				sync_to_monitor			= true;
				enable_audio_bell		= false;

				inactive_text_alpha		= "0.9";
				background_opacity		= "1";

				clipboard_control		= "write-clipboard write-primary read-clipboard read-primary";

				# Colors
				background				= "#000000";

				foreground				= "#eeeeee";
				selection_foreground	= "#000000";
				selection_background	= "#ffffff";
				url_color				= "#ff2a6d";
				cursor					= "#ff2a6d";
				cursor_text_color		= "#111111";

				# black
				color0					= "#000000";
				color8					= "#222222";

				# red
				color1					= "#ff2a6d";
				color9					= "#D9245D";

				# green
				color2					= "#bcea3b";
				color10					= "#96BA2F";

				# yellow
				color3					= "#faff00";
				color11					= "#D5D900";

				# blue
				color4					= "#02a9ea";
				color12					= "#0285B8";

				# magenta
				color5					= "#A61B47";
				color13					= "#8C173C";

				# cyan
				color6					= "#05d9e8";
				color14					= "#04ACB8";

				# white
				color7					= "#999999";
				color15					= "#ffffff";
			};
		};

		# The monaspace fonts don't specify the right spacing, and that makes
		# kitty refuse to treat them as mono space fonts, even though they are.
		xdg.configFile."fontconfig/conf.d/10-kitty-fonts.conf".text = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
            <fontconfig>
            
            	<match target="scan">
            		<test name="family">
            			<string>Monaspace Krypton</string>
            		</test>
            		<edit name="spacing">
            			<int>100</int>
            		</edit>
            	</match>
            
            	<match target="scan">
            		<test name="family">
            			<string>Monaspace Argon</string>
            		</test>
            		<edit name="spacing">
            			<int>100</int>
            		</edit>
            	</match>
            
            	<match target="scan">
            		<test name="family">
            			<string>Monaspace Neon</string>
            		</test>
            		<edit name="spacing">
            			<int>100</int>
            		</edit>
            	</match>
            
            </fontconfig>
		'';
	};
}
