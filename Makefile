UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	NIXOS_REBUILD := sudo nixos-rebuild
endif
ifeq ($(UNAME_S),Darwin)
	NIXOS_REBUILD := darwin-rebuild
endif

all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

switch:
	$(NIXOS_REBUILD)  switch --flake ./#$(hostname)

switch-offline:
	$(NIXOS_REBUILD) switch --flake ./#$(hostname) --option substitute false

update:
	@nix flake update
	@$(NIXOS_REBUILD) build
	@nix store diff-closures /run/current-system ./result
	@echo ================================================================================
	@echo "Press enter or wait 30 seconds to continue, or ctrl-c to cancel" 
	@bash -c 'read -t 30 -p "... " ignore' || true
	$(NIXOS_REBUILD) switch --flake /etc/nixos#$(hostname) --upgrade

test:
	@nix flake check

rollback:
	$(NIXOS_REBUILD) switch --flake /etc/nixos#$(hostname) --rollback

remote-dent:
	@$(NIXOS_REBUILD) switch --fast --flake .#dent --target-host dent --build-host dent --use-remote-sudo

remote-hotblack:
	@$(NIXOS_REBUILD) switch --fast --flake .#hotblack --target-host hotblack --build-host hotblack --use-remote-sudo

remote-lord:
	@$(NIXOS_REBUILD) switch --fast --flake .#lord --target-host lord --build-host lord --use-remote-sudo
