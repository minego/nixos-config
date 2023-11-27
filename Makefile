all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

switch:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

switch-offline:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --option substitute false

update:
	@nix flake update
	@nixos-rebuild build
	@nix store diff-closures /run/current-system ./result
	@echo ================================================================================
	@echo "Press enter or wait 30 seconds to continue, or ctrl-c to cancel" 
	@bash -c 'read -t 30 -p "... " ignore' || true
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --upgrade

test:
	@nix flake check

rollback:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --rollback

remote-dent:
	@nixos-rebuild switch --fast --flake .#dent --target-host dent --build-host dent --use-remote-sudo

remote-hotblack:
	@nixos-rebuild switch --fast --flake .#hotblack --target-host hotblack --build-host hotblack --use-remote-sudo

remote-lord:
	@nixos-rebuild switch --fast --flake .#lord --target-host lord --build-host lord --use-remote-sudo
