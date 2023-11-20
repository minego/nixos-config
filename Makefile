all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

switch:
	@sudo nixos-rebuild switch --flake /etc/nixos#lord --impure

upgrade:
	@sudo nixos-rebuild switch --flake /etc/nixos#lord --impure --upgrade

test:
	@sudo nixos-rebuild test --flake /etc/nixos#lord --impure
