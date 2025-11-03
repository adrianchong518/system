{
  allowUnsupportedSystem = true;
  allowUnfree = true;
  allowBroken = false;
  nvidia.acceptLicense = true;

  # HACK: should be made into per system
  cudaSupport = true;
  cudaForwardCompat = false;
  cudaCapabilities = [ "8.9" ];
}

