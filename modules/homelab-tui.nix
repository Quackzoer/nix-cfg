{ pkgs, ... }:
let
  # GitHub repo that publishes homelab-tui releases (see .github/workflows/release.yml there).
  repo = "Quackzoer/nix-homelab-tui-manager";
  user = "krzysztof";
in
{
  # Bun-compiled executables are dynamically linked against glibc; NixOS needs nix-ld to run them.
  programs.nix-ld.enable = true;

  # Installs homelab-tui from the latest GitHub release if it is not there yet.
  # Later updates are done by the app itself (or `hl update`), so this never overwrites an existing binary.
  systemd.services.homelab-tui-install = {
    description = "Install homelab-tui from the latest GitHub release";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.curl pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
    script = ''
      bin="$HOME/.local/bin/homelab-tui"
      [ -x "$bin" ] && exit 0
      mkdir -p "$(dirname "$bin")"
      curl -fsSL "https://github.com/${repo}/releases/latest/download/homelab-tui-linux-x64" -o "$bin.new"
      chmod +x "$bin.new"
      mv -f "$bin.new" "$bin"
    '';
  };
}
