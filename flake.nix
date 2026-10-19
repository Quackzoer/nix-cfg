{
  description = "Homelab (Dell Wyse 5070)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      mkWyse = hardware: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/wyse hardware ];
      };
    in
    {
      # Real machine: fails to build until hardware-configuration.nix is generated.
      nixosConfigurations.wyse = mkWyse ./hosts/wyse/hardware-configuration.nix;

      # CI only: same config with a stub hardware file, so all other modules get checked.
      nixosConfigurations.wyse-ci = mkWyse ./hosts/wyse/ci-hardware.nix;
    };
}
