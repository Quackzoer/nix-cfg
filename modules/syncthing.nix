{ ... }:
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

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
