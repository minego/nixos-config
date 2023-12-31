HOSTNAME := $(hostname -s)
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_S),Linux)
	TOOL := sudo nixos-rebuild
endif
ifeq ($(UNAME_S),Darwin)
	TOOL := darwin-rebuild
endif

ifneq (, $(shell which nom))
	PIPETO := nom
else
	PIPETO := cat
endif

# Having an asahi host in my config requires being impure
ARGS := --impure

all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

install: switch

switch:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) |& $(PIPETO)

switch-debug:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --option eval-cache false --show-trace |& $(PIPETO)

switch-offline:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --option substitute false |& $(PIPETO)

update:
	@nix flake update |& $(PIPETO)
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --upgrade |& $(PIPETO)

test:
	@nix flake check

rollback:
	$(TOOL) switch --flake ./#$(HOSTNAME) $(ARGS) --rollback |& $(PIPETO)

gateway-vm:
	$(TOOL) build-vm --flake ./#gateway-vm $(ARGS) |& $(PIPETO)
