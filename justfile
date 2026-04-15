set unstable

host := trim_end_match(`hostname`, ".local")
platform := if os() == "linux" {
    if `command -v nixos-rebuild` != "" {
        "nixos"
    } else {
        "hm"
    }
} else if os() == "macos" {
    "darwin"
} else {
    error("Unsupported OS: " + os())
}

nh := require("nh")
rebuild-subcmd := if platform == "nixos" {
    "os"
} else if platform == "hm" {
    "home"
} else if platform == "darwin" {
    "darwin"
} else {
    error("Unsupported platform: " + platform)
}
rebuild-cmd := f"{{nh}} {{rebuild-subcmd}}"

git := require("git")

@_default:
    echo Hostname: '{{YELLOW}}{{host}}{{NORMAL}}'
    echo Platform: '{{YELLOW}}{{platform}}{{NORMAL}}'
    just --list --justfile {{justfile()}}

# Bootstrap the Nix environment
bootstrap:
    @echo Bootstrapping Nix...

alias b := build
# Build the system configuration
build *extra_flags: _check-git
    {{rebuild-cmd}} build . --show-trace {{extra_flags}}

alias s := switch
# Build and switch to the new system configuration
switch *extra_flags: _check-git
    {{rebuild-cmd}} switch . --show-trace {{extra_flags}}

# Update all / supplied flakes
update *flakes:
    nix flake update {{flakes}} {{ if which("gh") != "" { "--option access-tokens \"github.com=$(gh auth token)\"" } else { "" } }}

alias r := run
run package *extra_flags: _check-git
    nix run .#{{package}} -- {{extra_flags}}

@_check-git:
    {{git}} add --all --intent-to-add
