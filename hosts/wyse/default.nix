{ ... }:
{
  imports = [
    ../../modules/base.nix
    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/docker.nix
    ../../modules/syncthing.nix
    ../../modules/linkwarden.nix
    ../../modules/homelab-tui.nix
    ../../modules/github-auth.nix
  ];

  networking.hostName = "wyse";

  # Do not change after first install.
  system.stateVersion = "26.05";
}
