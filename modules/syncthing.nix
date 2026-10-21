{ config, ... }:
let
  cfg = config.services.syncthing;
in
{
  services.syncthing = {
    enable = true;
    user = "krzysztof";
    dataDir = "/data/syncthing";
    configDir = "/data/syncthing/.config";
    openDefaultPorts = true;
    # Web UI on LAN. Set a GUI password on first visit,
    # or use 127.0.0.1:8384 and an SSH tunnel instead.
    guiAddress = "0.0.0.0:8384";
  };

  # /data is a separate SSD: make sure the folders exist with the right owner
  # and that Syncthing only starts once the disk is mounted.
  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    "d ${cfg.configDir} 0700 ${cfg.user} ${cfg.group} - -"
  ];
  systemd.services.syncthing.unitConfig.RequiresMountsFor = cfg.dataDir;

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
