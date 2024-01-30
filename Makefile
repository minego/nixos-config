HOSTNAME	:= $(shell hostname -s)
UNAME_S		:= $(shell uname -s)
UNAME_M		:= $(shell uname -m)

ifeq ($(UNAME_S),Linux)
	TOOL	:= sudo nixos-rebuild
endif
ifeq ($(UNAME_S),Darwin)
	TOOL	:= darwin-rebuild
endif

all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

install: switch

switch:
	$(TOOL) switch --flake ./#$(HOSTNAME)

switch-debug: check
	$(TOOL) switch --flake ./#$(HOSTNAME) --option eval-cache false --show-trace

switch-offline:
	$(TOOL) switch --flake ./#$(HOSTNAME) --option substitute false

# Build for the phone
build-marvin:
	nix build ./#marvin-image

update:
	@nix flake update
	$(TOOL) switch --flake ./#$(HOSTNAME) --upgrade

check:
	@nix flake check --show-trace

test: check
	$(TOOL) dry-build --flake ./#$(HOSTNAME)

rollback:
	$(TOOL) switch --flake ./#$(HOSTNAME) --rollback

gateway-vm:
	$(TOOL) build-vm --flake ./#gateway-vm
