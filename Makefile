HOSTNAME	:= $(shell hostname -s)
UNAME_S		:= $(shell uname -s)
UNAME_M		:= $(shell uname -m)

ifeq ($(UNAME_S),Linux)
	TOOL	:= sudo nixos-rebuild
endif
ifeq ($(UNAME_S),Darwin)
	TOOL	:= darwin-rebuild
endif
ARGS		:= --impure

all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

install: switch

build:
	$(TOOL) build --flake ./#$(HOSTNAME) $(ARGS)
	nvd diff /run/current-system result

switch:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS)

switch-debug: check
	$(TOOL) switch --flake ./#$(HOSTNAME) --option eval-cache false --show-trace $(ARGS)

switch-offline:
	$(TOOL) switch --flake ./#$(HOSTNAME) --option substitute false $(ARGS)

# Build for the phone
build-marvin:
	nix build ./#marvin-image

update:
	@nix flake update
	$(TOOL) switch --flake ./#$(HOSTNAME) --upgrade $(ARGS)
	nvd diff /run/current-system result

check:
	@nix flake check --show-trace

test: check
	$(TOOL) dry-build --flake ./#$(HOSTNAME)

rollback:
	$(TOOL) switch --flake ./#$(HOSTNAME) --rollback

gateway-vm:
	$(TOOL) build-vm --flake ./#gateway-vm
