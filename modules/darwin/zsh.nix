# Based on https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-unstable/nixos/modules/programs/zsh/zsh.nix
# but modified to fit my needs and provide things that are missing from nix-darwin
#
# This module defines global configuration for the zshell.

{ config, lib, options, pkgs, ... }:

with lib;

let
	cfge	= config.environment;
	cfg		= config.programs.zsh;
	opt		= options.programs.zsh;

	zshAliases = concatStringsSep "\n" (
		mapAttrsFlatten (k: v: "alias -- ${k}=${escapeShellArg v}")
		(filterAttrs (k: v: v != null) cfg.shellAliases)
	);
in

{
	options = {
		programs.zsh = {
			histSize = mkOption {
				default = 2000;
				description = lib.mdDoc ''
				Change history size.
				'';
				type = types.int;
			};

			histFile = mkOption {
				default = "$HOME/.zsh_history";
				description = lib.mdDoc ''
				Change history file.
				'';
				type = types.str;
			};
			setOptions = mkOption {
				type = types.listOf types.str;
				default = [
					"HIST_IGNORE_DUPS"
					"SHARE_HISTORY"
					"HIST_FCNTL_LOCK"
				];
				example = [ "EXTENDED_HISTORY" "RM_STAR_WAIT" ];
				description = lib.mdDoc ''
				Configure zsh options. See
				{manpage}`zshoptions(1)`.
				'';
			};
			shellAliases = mkOption {
				default = { };

				description = lib.mdDoc ''
				Set of aliases for zsh shell, which overrides {option}`environment.shellAliases`.
				See {option}`environment.shellAliases` for an option format description.
				'';
				type = with types; attrsOf (nullOr (either str path));
			};
		};
	};

  config = mkIf cfg.enable {
    environment.etc.zshrc.text =
      ''
        # Setup command line history.
        # Don't export these, otherwise other shells (bash) will try to use same HISTFILE.
        SAVEHIST=${toString cfg.histSize}
        HISTSIZE=${toString cfg.histSize}
        HISTFILE=${cfg.histFile}

        ${optionalString (cfg.setOptions != []) ''
          # Set zsh options.
          setopt ${concatStringsSep " " cfg.setOptions}
        ''}

        # Setup aliases.
        ${zshAliases}
      '';

  };
}
