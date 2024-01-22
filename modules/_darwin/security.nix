{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.security;

  mkSudoTouchIdAuthScript = isEnabled:
    let
      file = "/etc/pam.d/sudo";
      optionText =
        "# nix system: modules.darwin.security.enableSudoTouchIdAuth";
      sed = "${pkgs.gnused}/bin/sed";
    in
    ''
      # remove existing configs first
      if grep '${optionText}' ${file} > /dev/null; then
        ${sed} -i '/${optionText}/d' ${file}
      fi

      ${if isEnabled then ''
        # Enable sudo Touch ID authentication, if not already enabled
        ${sed} -i '2i\
        auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ${optionText}\
        auth       sufficient     pam_tid.so ${optionText}
        ' ${file}
      '' else
        ""}
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
