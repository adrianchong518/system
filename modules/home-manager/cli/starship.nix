{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$username$hostname$directory$vcsh$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$singularity$kubernetes$docker_context$terraform$nix_shell$conda$spack$aws$gcloud$openstack$azure$crystal$cmd_duration$line_break$shlvl$jobs$status$character";

      fill.symbol = " ";

      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
      cmd_duration.format = "[$duration]($style) ";

      nix_shell.format = "\\[[$symbol$state( \\($name\\))]($style)\\] ";
      openstack.format = "\\[[$symbol$cloud(\\($project\\))]($style)\\] ";
      kubernetes.format = "\\[[$symbol$context( \\($namespace\\))]($style)\\] ";
      spack.format = "\\[[$symbol$environment]($style)\\] ";
      terraform.format = "\\[[$symbol$workspace]($style)\\] ";
      aws.format = "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\] ";
      conda.format = "\\[[$symbol$environment]($style)\\] ";
      docker_context.format = "\\[[$symbol$context]($style)\\] ";
      gcloud.format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\] ";

      status.disabled = false;
      shlvl.disabled = false;
    };
  };
}
