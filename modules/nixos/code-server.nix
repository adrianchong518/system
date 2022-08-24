{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.vscode-server.nixosModule
  ];

  services.vscode-server.enable = true;
}
