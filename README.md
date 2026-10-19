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

## sudo

`sudo` always asks for the `krzysztof` password. Set it with `passwd` on the box **before** applying a config that
enables it, otherwise sudo cannot be used (`sudo passwd krzysztof` works while sudo is still passwordless).

Deploy from the desktop with `hl deploy` after pushing (it runs `nixos-rebuild switch --flake github:...#wyse --refresh`).

Never commit secrets (tokens, PATs). Keep them under /var/lib/secrets on the box.
