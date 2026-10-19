{ ... }:
let
  # Public key only (safe to commit). Windows: C:\Users\<you>\.ssh\id_ed25519.pub
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkCwOA/dA46CcYWeE1poqt19imkIYIwectcV0fvIvBH krzysztof@quackzoer-pc"
  ];
in
{
  users.users.krzysztof = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = sshKeys;
  };

  security.sudo.wheelNeedsPassword = false;

  # Refuse to build with the placeholder key, so you can't lock yourself out.
  assertions = [{
    assertion = !(builtins.any (k: builtins.match ".*REPLACE_ME.*" k != null) sshKeys);
    message = "modules/users.nix: put your real SSH public key in sshKeys.";
  }];
}
