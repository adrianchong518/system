{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.security;

  mkSudoTouchIdAuthScript = isEnabled:
    let
      file = "/etc/pam.d/sudo";
      optionText = "# nix system: modules.darwin.security.enableSudoTouchIdAuth";
      sed = "${pkgs.gnused}/bin/sed";
    in
    if isEnabled then ''
      # Enable sudo Touch ID authentication, if not already enabled
      if ! grep 'pam_tid.so' ${file} > /dev/null; then
        ${sed} -i '2i\
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ${optionText}\
      auth       sufficient     pam_tid.so ${optionText}
        ' ${file}
      fi
    '' else ''
      # Disable sudo Touch ID authentication, if added by nix-darwin
      if grep '${optionText}' ${file} > /dev/null; then
        ${sed} -i '/${optionText}/d' ${file}
      fi
    '';
in
{
  options.modules.darwin.security = with types; {
    enableSudoTouchIdAuth = mkBoolOpt false;
  };

  config = {
    system.activationScripts.pam.text = ''
      # PAM settings
      echo >&2 "setting up pam..."
      ${mkSudoTouchIdAuthScript cfg.enableSudoTouchIdAuth}
    '';
  };
}
