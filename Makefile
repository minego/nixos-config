HOSTNAME	:= $(shell hostname -s)
UNAME_S		:= $(shell uname -s)
UNAME_M		:= $(shell uname -m)

ifeq ($(UNAME_S),Linux)
	TOOL	:= sudo nixos-rebuild
endif
ifeq ($(UNAME_S),Darwin)
	TOOL	:= darwin-rebuild
endif

# Using the "replace" mode with tpwrules/nixos-apple-silicon doesn't work
# in "pure" mode. The "overlay" option works as well, but rebuilds the world.
ARGS		:= --impure

all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

install: switch

build:
	$(TOOL) build --flake ./#$(HOSTNAME) $(ARGS)
	nvd diff /run/current-system result

switch:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --show-trace

testdwl:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --override-input dwl-minego-customized ../dwl/

switch-debug: check
	$(TOOL) switch --flake ./#$(HOSTNAME) --option eval-cache false --show-trace $(ARGS)

switch-offline:
	$(TOOL) switch --flake ./#$(HOSTNAME) --option substitute false $(ARGS)

# Build an image for the phone
marvin-image:
	nix build ./#marvin-image $(ARGS)

# Build an image for the steam deck
wonko-installer:
	nix build .#nixosConfigurations.wonko.config.formats.install-iso $(ARGS)

wonko-image:
	nix build .#nixosConfigurations.wonko.config.formats.raw-efi $(ARGS)

update:
	@nix flake update
	$(TOOL) build --flake ./#$(HOSTNAME) --upgrade $(ARGS)
	nvd diff /run/current-system result
	$(TOOL) switch --flake ./#$(HOSTNAME) --upgrade $(ARGS)

check:
	@nix flake check --show-trace $(ARGS)

test: check
	$(TOOL) dry-build --flake ./#$(HOSTNAME)

rollback:
	$(TOOL) switch --flake ./#$(HOSTNAME) --rollback

gateway-vm:
	$(TOOL) build-vm --flake ./#gateway-vm
