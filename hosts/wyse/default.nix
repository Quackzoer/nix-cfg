{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/docker.nix
    ../../modules/syncthing.nix
  ];

  networking.hostName = "wyse";

  # Do not change after first install.
  system.stateVersion = "26.05";
}
