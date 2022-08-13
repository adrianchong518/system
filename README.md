# Nix System Configuration

This repository contains the system configuration for all my devices (currently one).

This configuration setup is "heavily based on" (copied from) [kclejeune/system](https://github.com/kclejeune/system)

## System Setup and Bootstrapping

### Installing nix on Non-NixOS systems

Run the installer script:

```bash
./bin/install-nix.sh
```

### Bootstrapping

#### NixOS

Run the following:

```bash
sudo nixos-install --flake github:kclejeune/system#[host]
```

#### Darwin / Linux

Clone this repository into `~/.nixpkgs` with

```bash
git clone https://github.com/adrianchong518/system ~/.nixpkgs
```

You can bootstrap a new nix-darwin system using

```bash
nix --extra-experimental-features "nix-command flakes" develop -c sysdo bootstrap --darwin [host]
```

or a home-manager configuration using

```bash
nix --extra-experimental-features "nix-command flakes" develop -c sysdo bootstrap --home-manager [host]
```

## `sysdo` CLI Tool

This `sysdo` util is also developed by @kclejeune in [kclejeune/system](https://github.com/kclejeune/system),
which I directly "yoinked".

Read [sysdo.md](./doc/sysdo.md) for documentation and usage.
