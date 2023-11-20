{ pkgs, patches, dwl-source, cmd, ... }:
pkgs.dwl.overrideAttrs (finalAttrs: previousAttrs: {
	src = dwl-source;
	inherit patches;
})
