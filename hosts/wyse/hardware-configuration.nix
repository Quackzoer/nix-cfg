# PLACEHOLDER - overwritten during install:
#   nixos-generate-config --root /mnt
#   cp /mnt/etc/nixos/hardware-configuration.nix hosts/wyse/
# Then commit the generated file.
{ ... }:
{
  assertions = [{
    assertion = false;
    message = "hosts/wyse/hardware-configuration.nix is still the placeholder. Generate it on the Wyse.";
  }];
}
