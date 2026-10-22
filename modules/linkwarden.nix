{ ... }:
{
  services.linkwarden = {
    enable = true;
    # Only reachable through Caddy (linkwarden.homelab.local).
    host = "127.0.0.1";
    port = 3000;
    # Local PostgreSQL is created automatically.
    database.createLocally = true;
    # Must contain NEXTAUTH_SECRET=<random string>. Create once on the host:
    #   sudo install -m 600 /dev/null /etc/linkwarden.env
    #   echo "NEXTAUTH_SECRET=$(openssl rand -hex 32)" | sudo tee /etc/linkwarden.env
    environmentFile = "/etc/linkwarden.env";
    environment.NEXTAUTH_URL = "http://linkwarden.homelab.local/api/v1/auth";
  };
}
