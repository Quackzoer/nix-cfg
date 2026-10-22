{ ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallWebserver = true;
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

  # Admin UI at http://<host>/admin. Set the password once with:
  #   sudo pihole setpassword
  services.pihole-web = {
    enable = true;
    ports = [ "80" ];
  };
}
