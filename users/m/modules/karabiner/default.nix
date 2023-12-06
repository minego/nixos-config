{ config, pkgs, lib, osConfig, inputs, ... }:
with lib;

let
	appmenu_sh = pkgs.writeShellScriptBin "app-menu" ''
        KITTY_APP="${pkgs.kitty}/Applications/kitty.app"
        KITTEN="$KITTY_APP/Contents/MacOS/kitten"
        
        case "$1" in
        	open)
        		for SOCK in /tmp/kitty.sock-*; do
        			# Tell kitty to open a new window
        			$KITTEN @ launch --type os-window --cwd "$HOME" \
        				--to unix:$SOCK								\
        				--os-window-state fullscreen				\
        				--var "hide_window_decorations=yes"			\
        															\
        				$0 menu
        		done
        		;;
        
        	menu)
        		declare -a APP_DIRS=(
        			"$HOME/Applications/Home Manager Apps"
        			"/Applications"
        		)
        
        
        		OPTION=$(
        			(
        				for APP_DIR in "''${APP_DIRS[@]}"; do
        					ls -1 "$APP_DIR"
        				done
        			) | grep "\.app$" | sed 's/\.app$//' | ${pkgs.fzf}/bin/fzf --reverse
        		)
        
        
        		for APP_DIR in "''${APP_DIRS[@]}"; do
        			APP="$APP_DIR/$OPTION.app"
        			if [ -d "$APP" ]; then
        				echo "Opening App: \"$APP\""
        				open "$APP"
        
        				exit 0
        			fi
        		done
        
        		echo "Uh, not sure how we got here..."
        		exit 1
        		;;
        
        	*)
        		echo "Usage: $0 <open|menu>"
        		echo
        		echo "   'open' will open a new window, and then display a menu"
        		echo "   'menu' will simply display a menu in the current terminal"
        		;;
        esac
        
        '';

	kitty_sh = pkgs.writeShellScriptBin "new-kitty-window" ''
        KITTY_APP="${pkgs.kitty}/Applications/kitty.app"
        KITTEN="$KITTY_APP/Contents/MacOS/kitten"
        
        for SOCK in /tmp/kitty.sock-*; do
        	$KITTEN @ launch --type os-window --cwd "$HOME" --to unix:$SOCK
        	if [ $? -eq 0 ]; then
        		exit 0
        	fi
        done
        
        if [ $? -ne 0 ]; then
        	open $KITTY_APP
        fi
        '';

	karabiner-json = pkgs.substituteAll {
		src		= ./karabiner.json;
		kitty	= kitty_sh;
		appmenu	= appmenu_sh;
	};
in {
	config = mkIf (osConfig.gui.enable && pkgs.stdenv.isDarwin) {
		home.packages = with pkgs; [
			karabiner-elements
		];

		xdg.configFile = {
			# "karabiner/karabiner.json".source					= ./karabiner.json;
			"karabiner/karabiner.json".source					= karabiner-json;
			"karabiner/assets/custom-capslock.json".source		= ./custom-capslock.json;
			"karabiner/assets/fn-num-to-function.json".source	= ./fn-num-to-function.json;
		};
	};
}
