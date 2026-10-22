{ ... }:
let
  domain = "homelab.local";
  # Static / DHCP-reserved LAN IP of this host. Every *.${domain} name resolves here.
  lanIp = "192.168.1.10";
in
{
  # Pi-hole answers any *.homelab.local (and homelab.local itself) with the host's IP.
  services.pihole-ftl.settings.misc.dnsmasq_lines = [
    "address=/${domain}/${lanIp}"
  ];

  # Caddy owns port 80 and routes by hostname, so no ports in URLs.
  # Add a service = add one line here.
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://pi-hole.${domain}".extraConfig = ''
        redir / /admin/
        reverse_proxy 127.0.0.1:8080
      '';
      "http://linkwarden.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:3000
      '';
      # Syncthing rejects unknown Host headers, so present it as localhost.
      "http://syncthing.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:8384 {
          header_up Host localhost
        }
      '';
    };
  };

  # Pi-hole's UI moves off :80 so Caddy can have it.
  services.pihole-web.ports = [ "8080" ];
  services.pihole-ftl.openFirewallWebserver = false;

  networking.firewall.allowedTCPPorts = [ 80 ];
}
