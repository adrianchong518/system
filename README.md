# Nix System Configuration

This repository contains the system configuration for all my devices (currently one).

This configuration setup is "heavily based on" (copied from)

**NOTE**: There is currently no NixOS configs as this is deemed unnecessary for now as I am not using NixOS.

## System Setup and Bootstrapping

### Installing nix on Non-NixOS systems

Run the installer script:

```bash
./bin/install-nix.sh
```

### Installing homebrew on Darwin

Some packages / brews / casks are not available in nix, so you need to install
`brew` from [brew.sh](https://brew.sh)

### Bootstrapping

#### NixOS (During install)

Clone this repo to `/mnt/etc/nixos/flake` or anywhere you like.

Add a new host to [hosts/nixos](./hosts/nixos).

Run the following to install the system:

```bash
sudo nixos-install --flake .#[host]
```

#### Darwin / Linux

Clone this repository into `~/.system` with

```bash
git clone https://github.com/adrianchong518/system ~/.system
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

The `sysdo` util is also developed by @kclejeune in [kclejeune/system](https://github.com/kclejeune/system),
which I directly "yoinked" and made slight modifications.

In the future, I would most likely write my own utility to fit my needs better.

Read [sysdo.md](./doc/sysdo.md) for documentation and usage.

## References

Here are some nix system configurations that I used as reference:

- [kclejeune/system](https://github.com/kclejeune/system)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
