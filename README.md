# homelab nix-config

NixOS config for the Dell Wyse 5070 (eMMC = `/`, SATA SSD = `/data`).

```
flake.nix
hosts/wyse/        default.nix + hardware-configuration.nix (generated on the box)
modules/           base, users, ssh, docker, syncthing
```

## Fresh install (from the NixOS live ISO, disks already mounted on /mnt)
```bash
nixos-generate-config --root /mnt
export NIX_CONFIG="experimental-features = nix-command flakes"
git clone https://github.com/YOU/nix-config /tmp/cfg && cd /tmp/cfg
cp /mnt/etc/nixos/hardware-configuration.nix hosts/wyse/
git add -A            # flakes only see tracked files
nixos-install --flake .#wyse
```

## Update
```bash
ssh krzysztof@wyse 'cd ~/nix-config && git pull && sudo nixos-rebuild switch --flake .#wyse'
```

Never commit secrets (tokens, PATs). Keep them under /var/lib/secrets on the box.
