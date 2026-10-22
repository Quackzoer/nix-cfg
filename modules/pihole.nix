{ ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black's unified hosts list";
      }
    ];
    settings = {
      dns.upstreams = [ "1.1.1.1" "9.9.9.9" ];
    };
  };

  # Admin UI is served on :8080 (see local-dns.nix) and reached through Caddy at
  # http://pi-hole.homelab.local. Set the password once with:
  #   sudo pihole setpassword
  services.pihole-web.enable = true;
}
