# Unofficial Arch Linux Docker Image

[![Build](https://img.shields.io/github/actions/workflow/status/Nevuly/ArchLinux-Docker/build.yml?label=arch%20linux%20docker%20image%20build&logo=github-actions&logoColor=%23FFFFFF&style=for-the-badge&labelColor=%23000000)](https://github.com/Nevuly/ArchLinux-Docker/actions/workflows/build.yml)

Maintainer: Yang Jeong Hun (Nevuly)

## Introduction
This repository builds and publishes an unofficial Arch Linux Docker Image using [Github Actions](https://github.com/Nevuly/ArchLinux-Docker/actions).
**A new image is built weekly on Sunday.**

## Support Architecture Lists
| Architecture | Docker Platform | Distribution |
| ------------ | --------------- | ------------ |
| x86_64 | `linux/amd64` | [Arch Linux](https://archlinux.org) |
| aarch64 | `linux/arm64` | [Arch Linux ARM](https://archlinuxarm.org) |
| powerpc64le | `linux/ppc64le` | [Arch POWER](https://archlinuxpower.org/) |
| riscv64 | `linux/riscv64` | [Arch Linux RISC-V](https://archriscv.felixc.at) |

## Tags
|  Tag   |   Update   |    Type    |              Description               |
| ------ | ---------- | ---------- | -------------------------------------- |
| latest, base | **weekly** | base | Arch Linux with base installed |
| base-devel | **weekly** | base-devel | Arch Linux with base and base-devel installed |
