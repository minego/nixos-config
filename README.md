# nixos-config
My personal nixos configuration

## Checkout this repo in /etc/nixos and then apply with a command such as:
```
make switch
```

## Adding a new machine

Each machine has an entry in `flake.nix` that imports machine specific options
and hardware specific options.

```
cd ~/
git checkout git@github.com:minego/nixos-config.git
cd nixos-config
mkdir -p hosts/${hostname}/
cp /etc/nixos/hardware-configuration.nix hosts/${hostname}/
cp hosts/lord/configuration.nix hosts/${hostname}

echo "Add the relevant bits to \"flake.nix\" and \"hosts/${hostname}/configuration.nix\"

cd ..
sudo mv /etc/nixos /etc/nixos.bk
sudo mv nixos-config /etc/nixos

cd /etc/nixos
echo "Run \"make switch\" when done"

```
