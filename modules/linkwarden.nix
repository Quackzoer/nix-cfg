{ pkgs, ... }:
let
  secretFile = "/var/lib/linkwarden-secret.env";
in
{
  services.linkwarden = {
    enable = true;
    # Web UI on the LAN: http://<host-ip>:3000
    host = "0.0.0.0";
    port = 3000;
    openFirewall = true;
    # Needed to create the first account. Set to false afterwards so nobody else on the LAN can sign up.
    enableRegistration = true;
    # Local PostgreSQL is created automatically.
    database.createLocally = true;
    # Contains NEXTAUTH_SECRET; generated on first boot by the service below.
    environmentFile = secretFile;
    # Must match the address you open in the browser, or login redirects break.
    environment.NEXTAUTH_URL = "http://192.168.1.10:3000/api/v1/auth";
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
