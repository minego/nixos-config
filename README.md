# nixos-config
My personal nixos configuration

## Clone this repo in /etc/nixos and then apply with a command such as:
```
make switch
```

## Adding a new machine

Each machine has an entry in `flake.nix` that imports machine specific options
and hardware specific options.

```
git checkout git@github.com:minego/nixos-config.git
cd nixos-config

mkdir -p hosts/$(hostname)/
nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
cp hosts/dent/default.nix hosts/${hostname}/

echo "Add the host to flake.nix and tweak hosts/$(hostname)/default.nix, then run 'make switch'"
```
