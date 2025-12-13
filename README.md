<div align="center">

<h1> :black_circle::file_folder: </h1>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Commit][commit-shield]][commit-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

</div>

> [!WARNING]
> **Status:** Work in Progress
>
> A management guide for my Arch Linux configuration, featuring **Hyprland**, **Neovim**, and **Fish Shell**.

---

<details>
<summary><h2>:bookmark_tabs: Table of Contents</h2></summary>

### :desktop_computer: [Base System Overview](#1-base-system-overview)

### :package: [Core Dependencies & AUR](#2-core-dependencies--aur)

### :art: [Software Stack](#4-software-stack)

### :hammer: [Development Environment](#5-development-environment)

### :rocket: [CLI & Shell Enhancements](#6-cli--shell-enhancements)

### :electric_plug: [Post-Installation Services](#7-post-installation-services)

### :coffee: [Daily Drivers & Social](#8-daily-drivers--social)

### :gear: [Dotfiles Setup](#3-dotfiles-setup-bare-repo-method)

</details>

---

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/f2ab18cd-b7f8-419e-9efc-ea3fe2c26392" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/f2190f7f-a885-41ae-93ae-ab10bb28d218" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/33a99c0c-4cef-40f3-ae41-be7e4fe0c854" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/70214f7f-e03f-41ed-973b-90df79b2841d" width="500" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/3972a322-3232-47dc-9bc6-b2687bd0f74b" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/a1ba2c42-ac8a-405b-a928-56ddabf2dd0b" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/8b7a824e-4816-43ca-81cb-51d8f67f096b" width="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/69dcd4bf-1789-40cf-bdf0-92e1b7014157" width="500" /></td>
  </tr>
</table>

## 1. Base System Overview

_Reference links for core components used via ArchInstall._

| Component           | Choice         | Documentation                                                                                                   |
| :------------------ | :------------- | :-------------------------------------------------------------------------------------------------------------- |
| **Bootloader**      | rEFInd         | [Guide](https://www.reddit.com/r/archlinux/comments/13d7rec/setting_up_secure_boot_while_dual_booting_windows/) |
| **Window Manager**  | Hyprland       | [Wiki](https://wiki.archlinux.org/title/Hyprland)                                                               |
| **Display Manager** | Ly             | [Wiki](https://wiki.archlinux.org/title/Ly)                                                                     |
| **Audio**           | Pipewire       | [Wiki](https://wiki.archlinux.org/title/PipeWire)                                                               |
| **Network**         | NetworkManager | [Wiki](https://wiki.archlinux.org/title/NetworkManager)                                                         |

### System & Drivers

| Component        | Package                       | Description                                        |
| :--------------- | :---------------------------- | :------------------------------------------------- |
| **GPU Drivers**  | `nvidia-open-dkms`            | Open source Nvidia drivers (Required for Hyprland) |
| **Portal**       | `xdg-desktop-portal-hyprland` | Required for Screen Sharing & File Dialogs         |
| **Bluetooth UI** | `blueman` `overskride`        | GUI for managing Bluetooth devices                 |

---

## 2. Core Dependencies & AUR

> [!TIP]
> Install these first to ensure the environment is ready for the dotfiles.

### System Basics

```bash
sudo pacman -S --needed git base-devel openssh less brightnessctl
```

```bash
# Random Wallpaper Script Dependency
sudo pacman -S pacman-contrib

# Window Detection Dependency (JSON processor)
sudo pacman -S jq
```

Terminal

```
sudo pacman -S kitty fish
```

AUR Helpers

```
# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay

# cargo
sudo pacman -S cargo
# Run this once in Fish
fish_add_path ~/.cargo/bin
```

---

## 3. Software Stack

- Desktop environment

```
# Core DE components (DE, Wallpaper, SearchBar, TaskBar, Notifications)
sudo pacman -S hyprland hyprpaper rofi waybar dunst

# Widget System
yay -S eww-git
# Dependencies
sudo pacman -S power-profiles-daemon
systemctl enable --now power-profiles-daemon.service
sudo pacman -S python-psutil
ln -sf ~/.cache/wal/colors-eww.scss ~/.config/eww/colors.scss

# Utilities (Screenshot, Clipboard, Brightness)
sudo pacman -S grim slurp wl-clipboard brightnessctl
```

- Audio & Multimedia

```
# Audio control
sudo pacman -S pavucontrol pamixer

# File Manager
sudo pacman -S yazi dolphin

# Video
sudo pacman -S mpv
```

- Appearance & Fonts

> [!NOTE]
> Required for Icons in Waybar and Neovim.

```
# Auto-theming
yay -S wallust
sudo pacman -S imagemagick

# Fonts (Recommended)
sudo pacman -S ttf-jetbrains-mono-nerd noto-fonts-cjk otf-font-awesome
```

- Input Method (Chinese Support)

```
sudo pacman -S fcitx5 fcitx5-configtool fcitx5-rime
```

---

## 4. Development Environment

- Neovim & Dependencies

```
sudo pacman -S neovim unzip nodejs npm
```

- Language Servers & Formatters

  | Language   | Tools                       | Documentation                                                                     |
  | :--------- | :-------------------------- | :-------------------------------------------------------------------------------- |
  | **Lua**    | stylua                      | [GitHub](https://github.com/JohnnyMorganz/StyLua)                                 |
  | **Python** | python-black & python-isort | [GitHub](https://github.com/psf/black) & [GitHub](https://github.com/PyCQA/isort) |
  | **Shell**  | shfmt                       | [GitHub](https://github.com/mvdan/sh)                                             |
  | **Wb/JS**  | prettier                    | [Web](https://prettier.io/)                                                       |
  | **C/C++**  | clang                       | [Wiki](https://wiki.archlinux.org/title/Clang)                                    |

```
sudo pacman -S stylua python-black python-isort shfmt prettier clang
```

---

## 5. CLI & Shell Enhancements

**Modern replacements for standard GNU tools.**

```bash
# Prompt & Navigation
sudo pacman -S starship zoxide fzf

# Search & Utilities
sudo pacman -S ripgrep fd jq fastfetch
```

---

## 6. Post-Installation Services

> [!IMPORTANT]
> Enable these services to ensure the system boots correctly.

```
# Enable Display Manager
sudo systemctl enable ly.service

# Enable Network Manager (if not already)
sudo systemctl enable NetworkManager

# Enable Bluetooth
sudo systemctl enable bluetooth
```

---

## 7. Daily Drivers & Social

```
# Browser
sudo pacman -S firefox

# Social
sudo pacman -S discord

# Office Suite
sudo pacman -S libreoffice-fresh

# PDF Reader
sudo pacman -S okular

# Media Player
sudo pacman -S vlc

# Timer
cargo install timr-tui

# Music Player
yay -S spotify-player
```

---

## 8. Dotfiles Setup (Bare Repo Method)

> [!IMPORTANT]
> This sets up the tracking of configuration files. Perform this before installing extensive software to ensure configs are in place.

1. Setup Git Identity

```
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
git config --global core.editor neovim
```

2. Prepare Shell & Alias

> [!IMPORTANT]
> Ensure fish is installed, then clone the bare repo:

```
# Install Fish
sudo pacman -S fish

# Clone Bare Repo
git clone --bare <YOUR_REPO_URL> $HOME/.dotfiles
```

3. Handle Existing Config Conflicts

> [!NOTE]
> This script backs up existing config files to a .todelete folder to prevent Git checkout errors.

```
# Enter Fish Shell
fish

# Define the alias for the current session
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Create backup directory
mkdir -p $HOME/.todelete

# Move conflicting files
config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p $HOME/.todelete/$(dirname {}) && mv {} $HOME/.todelete/{}'

# Checkout Dotfiles
config checkout
config config --local status.showUntrackedFiles no
```

4. SSH Setup (Optional)

```
mkdir -p $HOME/.ssh
ssh-keygen -t ed25519 -C "user@device"
# Save to: /home/user/.ssh/github_ed25519

# Register Key & Set Remote
loadkey github
config remote set-url origin <SSH_URL>
config fetch
config pull --rebase
config push -u origin main
```

---

<div align="center">

**Loved the setup?**
<br>
Consider giving the repo a star! 🌟

[![Stars][stars-shield]][stars-url]
[![Forks][forks-shield]][forks-url]
[![License][license-shield]][license-url]
<br>

[**:arrow_up: Back to Top**](#-black_circlefile_folder-)

</div>

<!-- Reference Style Links -->

[contributors-shield]: https://custom-icon-badges.demolab.com/github/contributors/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=person&color=F2D7EE
[contributors-url]: https://github.com/Michael-Steenkamp/Dotfiles/graphs/contributors
[forks-shield]: https://custom-icon-badges.demolab.com/github/forks/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=repo-forked&color=D3BCC0
[forks-url]: https://github.com/Michael-Steenkamp/Dotfiles/forks
[commit-shield]: https://custom-icon-badges.demolab.com/github/commit-activity/t/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=git-commit&color=A5668B
[commit-url]: https://github.com/Michael-Steenkamp/Dotfiles/graphs/commit-activity
[stars-shield]: https://custom-icon-badges.demolab.com/github/stars/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=star&color=69306D
[stars-url]: https://github.com/Michael-Steenkamp/Dotfiles/stargazers
[issues-shield]: https://custom-icon-badges.demolab.com/github/issues/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=issue-open&color=0E103D
[issues-url]: https://github.com/Michael-Steenkamp/Dotfiles/issues
[license-shield]: https://custom-icon-badges.demolab.com/github/license/Michael-Steenkamp/Dotfiles?style=plastic&logoColor=white&logo=law&color=24264F
[license-url]: https://github.com/Michael-Steenkamp/Dotfiles/blob/main/LICENSE
