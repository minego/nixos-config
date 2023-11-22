all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

switch:
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

update:
	@nix flake update
	@sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --upgrade

test:
	@sudo nixos-rebuild test --flake /etc/nixos#$(hostname)
