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

flake := ".#" + host

rebuild-cmd := if platform == "nixos" {
    require("nixos-rebuild")
} else if platform == "hm" {
    require("home-manager")
} else if platform == "darwin" {
    require("darwin-rebuild")
} else {
    error("Unsupported platform: " + platform)
}

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
    {{rebuild-cmd}} build --flake {{flake}} --show-trace {{extra_flags}}

alias s := switch
# Build and switch to the new system configuration
switch *extra_flags: _check-git
    {{ if platform == "nixos" { "sudo" } else { "" } }} {{rebuild-cmd}} switch --flake {{flake}} --show-trace {{extra_flags}}

# Update all / supplied flakes
update *flakes:
    nix flake update {{flakes}}

alias r := run
run package *extra_flags: _check-git
    nix run .#{{package}} -- {{extra_flags}}

@_check-git:
    {{git}} add --all --intent-to-add
