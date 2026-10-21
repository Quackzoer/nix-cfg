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

## hardware-configuration.nix must come from the server

`hosts/wyse/hardware-configuration.nix` describes the machine's disks, so it cannot be written by hand. The file in
this repo starts as a **placeholder that fails the build on purpose** (`hl deploy` / `nixos-rebuild` stop with
"hardware-configuration.nix is still the placeholder"). Replace it with the real one, then commit and push it:

```powershell
# from this repo on your PC (the file is generated on the box, usually in /etc/nixos)
scp krzysztof@wyse:/etc/nixos/hardware-configuration.nix hosts/wyse/hardware-configuration.nix
git add hosts/wyse/hardware-configuration.nix
git commit -m "Add real hardware-configuration for the Wyse"
git push
```

Check the file lists your real `fileSystems."/"` (eMMC) and `/data` (SSD) before committing. Redo this only if the
hardware or disk layout changes.

## flake.lock (pins nixpkgs)

Without a committed `flake.lock`, every deploy uses the newest nixpkgs. You don't need Nix on your PC to create it:
generate it on the server and copy it back.

```powershell
ssh krzysztof@wyse "rm -rf /tmp/cfg && git clone -q https://github.com/Quackzoer/nix-cfg /tmp/cfg && cd /tmp/cfg && nix --extra-experimental-features 'nix-command flakes' flake lock"
scp krzysztof@wyse:/tmp/cfg/flake.lock flake.lock
git add flake.lock
git commit -m "Add flake.lock"
git push
```

To upgrade nixpkgs later, run the same commands with `flake update` instead of `flake lock`, then commit the new
`flake.lock` and `hl deploy`.

## Update
```bash
ssh krzysztof@wyse 'cd ~/nix-config && git pull && sudo nixos-rebuild switch --flake .#wyse'
```

## sudo

`sudo` always asks for the `krzysztof` password. Set it with `passwd` on the box **before** applying a config that
enables it, otherwise sudo cannot be used (`sudo passwd krzysztof` works while sudo is still passwordless).

Deploy from the desktop with `hl deploy` after pushing (it runs `nixos-rebuild switch --flake github:...#wyse --refresh`).

Never commit secrets (tokens, PATs). Keep them under /var/lib/secrets on the box.

## Private repos (GitHub token)

`modules/github-auth.nix` makes Nix read `/etc/nix/access-tokens`, which is **not** in this repo. Install the token
from your desktop with `hl github login` (see `docs/github-auth.md` in nix-homelab-tui-manager), then `hl deploy`.
Install the token before the first deploy that uses a private flake input.
