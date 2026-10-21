{ ... }:
{
  # GitHub token for fetching private repos (flake inputs, `hl deploy`, system.autoUpgrade).
  #
  # The token itself is NOT in this repo. `hl github login` (from the client app) installs it as
  # /etc/nix/access-tokens (root:wheel, mode 0640) in nix.conf syntax:
  #   access-tokens = github.com=<token>
  # `!include` (with the exclamation mark) means "skip silently if the file does not exist",
  # so the config also works before a token was installed.
  nix.extraOptions = ''
    !include /etc/nix/access-tokens
  '';
}
