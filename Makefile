all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

switch:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

update:
	@nix flake update
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --upgrade

test:
	@nix flake check
	@sudo nixos-rebuild test --flake /etc/nixos#$(hostname)

rollback:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --rollback

remote-dent:
	@nixos-rebuild switch --fast --flake .#dent --target-host dent --build-host dent --use-remote-sudo

remote-hotblack:
	@nixos-rebuild switch --fast --flake .#hotblack --target-host hotblack --build-host hotblack --use-remote-sudo

remote-lord:
	@nixos-rebuild switch --fast --flake .#lord --target-host lord --build-host lord --use-remote-sudo
