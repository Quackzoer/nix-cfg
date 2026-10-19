{
  description = "Homelab (Dell Wyse 5070)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.wyse = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/wyse ];
    };
  };
}
