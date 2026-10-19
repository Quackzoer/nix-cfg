# Stand-in hardware config used ONLY by the `wyse-ci` flake output so CI can
# evaluate everything else. Never used for the real machine.
{ ... }:
{
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };
  nixpkgs.hostPlatform = "x86_64-linux";
}
