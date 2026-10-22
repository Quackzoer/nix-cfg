{ pkgs, ... }:
let
  secretFile = "/var/lib/linkwarden-secret.env";
in
{
  services.linkwarden = {
    enable = true;
    # Only reachable through Caddy (linkwarden.homelab.local).
    host = "127.0.0.1";
    port = 3000;
    # Local PostgreSQL is created automatically.
    database.createLocally = true;
    # Contains NEXTAUTH_SECRET; generated on first boot by the service below.
    environmentFile = secretFile;
    environment.NEXTAUTH_URL = "http://linkwarden.homelab.local/api/v1/auth";
  };

  # Generate the secret once, only if it doesn't exist yet. Never overwritten,
  # so sessions survive rebuilds.
  systemd.services.linkwarden-secret = {
    description = "Generate Linkwarden NEXTAUTH_SECRET";
    wantedBy = [ "linkwarden.service" ];
    before = [ "linkwarden.service" ];
    unitConfig.ConditionPathExists = "!${secretFile}";
    path = [ pkgs.openssl ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    script = ''
      echo "NEXTAUTH_SECRET=$(openssl rand -hex 32)" > ${secretFile}
    '';
  };
}
