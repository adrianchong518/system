{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.starship;
in {
  options.modules.shell.starship = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    hm.programs.starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        format =
          "$username$hostname$directory$vcsh$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$singularity$kubernetes$docker_context$terraform$nix_shell$conda$spack$aws$gcloud$openstack$azure$crystal$cmd_duration$line_break$shlvl$jobs$status$character";

        fill.symbol = " ";

        git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
        cmd_duration.format = "[$duration]($style) ";

        nix_shell.format = "\\[[$symbol$state( \\($name\\))]($style)\\] ";
        openstack.format = "\\[[$symbol$cloud(\\($project\\))]($style)\\] ";
        kubernetes.format =
          "\\[[$symbol$context( \\($namespace\\))]($style)\\] ";
        spack.format = "\\[[$symbol$environment]($style)\\] ";
        terraform.format = "\\[[$symbol$workspace]($style)\\] ";
        aws.format =
          "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\] ";
        conda.format = "\\[[$symbol$environment]($style)\\] ";
        docker_context.format = "\\[[$symbol$context]($style)\\] ";
        gcloud.format =
          "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\] ";

        status.disabled = false;
        shlvl.disabled = true;

        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
          vimcmd_symbol = "[<](bold green)";
          vimcmd_replace_one_symbol = "[<](bold purple)";
          vimcmd_replace_symbol = "[<](bold purple)";
          vimcmd_visual_symbol = "[<](bold yellow)";
        };

        aws.symbol = "a  ";
        gcloud.symbol = "g  ";
        openstack.symbol = "o  ";
        conda.symbol = " ";
        directory.read_only = " 󰌾";
        docker_context.symbol = " ";
        git_branch.symbol = " ";
        git_commit.tag_symbol = " ";
        hg_branch.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        nix_shell.symbol = " ";
        spack.symbol = "🅢 ";
        shlvl.symbol = " ";
      };
    };

  };
}
