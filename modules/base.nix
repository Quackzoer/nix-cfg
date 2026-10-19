{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:Quackzoer/nix-cfg#wyse";
    flags = [ "--refresh" ];     # always re-fetch the repo, never use cached copy
    dates = "*:0/5";             # every 5 minutes
    allowReboot = false;
    operation = "boot";
  };

  environment.systemPackages = with pkgs; [ git vim htop ];
}
