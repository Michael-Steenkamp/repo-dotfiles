<a id="readme-top"></a>

# Dotfiles

> [!WARNING]
> Incomplete

<!-- Badges -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Commit][commit-shield]][commit-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

---

## System Via ArchInstall

### `Bootloader` | <a href="https://www.reddit.com/r/archlinux/comments/13d7rec/setting_up_secure_boot_while_dual_booting_windows/">REFIND</a>

### `Netowkrk` | <a href="https://wiki.archlinux.org/title/NetworkManager#Configuration">NETWORK MANAGER</a>

### `Audio` | <a href="https://wiki.archlinux.org/title/PipeWire">PIPEWIRE</a>

### `Window Manager` | <a href="https://wiki.archlinux.org/title/Hyprland">HYPRLAND</a>

### `Bluetooth` | <a href="https://wiki.archlinux.org/title/Blueman">BLUEMAN</a>

## Packages

### `Network`

<details>
<summary><a href="https://wiki.archlinux.org/title/NetworkManager#Configuration">NM-CONNECTION-EDITOR</a></summary>

```
sudo pacman nm-connection-editor
```

</details>

### `Audio`

<details>
<summary><a href="https://archlinux.org/packages/extra/x86_64/pavucontrol/">PAVUCONTROL</a> | <a href="https://github.com/cdemoulins/pamixer">PAMIXER</a></summary>

```
sudo pacman pavucontrol pamixer
```

</details>

### `Display Manager`

<details>
<summary><a href="https://wiki.archlinux.org/title/Ly">LY</a></summary>

```
sudo pacman ly && sudo systemctl start ly.service
```

</details>

### `Menu`

<details>
<summary><a href="https://github.com/davatorium/rofi">ROFI</a></summary>

```
sudo pacman rofi
```

</details>

### `Text Editor`

<details>
<summary><a href="https://neovim.io/">NVIM</a></summary>

```
sudo pacman nvim
```

### `LSP`

Dependencies

```
sudo pacman -S unzip nodejs npm
```

### `Formatters`

<details>
<summary></summary>

### `Lua`

<details>
<summary><a href="https://github.com/JohnnyMorganz/StyLua">STYLUA</a></summary>

```
sudo pacman -S stylua
```

</details>

### `Python`

<details>
<summary><a href="https://github.com/psf/black">PYTHON-BLACK</a> | <a href="https://github.com/PyCQA/isort">PYTHON-ISORT</a></summary>

```
sudo pacman -S python-black python-isort
```

</details>

### `Shell`

<details>
<summary><a href="https://github.com/mvdan/sh">SHFMT</a></summary>

```
sudo pacman shfmt
```

</details>

### `Web/JS`

<details>
<summary><a href="https://prettier.io/">PRETTIER</a></summary>

```
sudo pacman -S prettier
```

</details>

### `C/C++`

<details>
<summary><a href="https://wiki.archlinux.org/title/Clang">CLANG</a></summary>

```
sudo pacman -S clang
```

</details>
</details>
</details>

### `Base Developement`

<details>
<summary><a href="">BASE-DEVEL</a></summary>

```
sudo pacman
```

</details>

### `File Pager Utility`

<details>
<summary><a href="https://archlinux.org/packages/core/x86_64/less/">LESS</a></summary>

```
sudo pacman less
```

</details>

### `Version Control`

<details>
<summary><a href="https://wiki.archlinux.org/title/Git">GIT</a></summary>

```
sudo pacman git
```

### Initial Setup

```
git config --global user.name ""
```

```
git config --global user.email ""
```

```
git config --global core.editor neovim
```

### Dotfiles Setup (After fish installation)

Check config.fish | Ensure alias is present inside 'is-interactive'

```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Clone Repo

```
git clone --bare <url> $HOME/.dotfiles
```

Run fish

```
fish
```

Run Command | Only show tracked files (files excluded from .gitignore)

```
config config --local status.showUntrackedFiles no
```

Finish Setup

```
mkdir -p $HOME/.todelete
```

```
config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p $HOME/.todelete/$(dirname{}) && mv {} $HOME/.todelete/{}'
```

```
rm -rf $HOME/.todelete
```

```
config config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
```

</details>

### `SSH Client`

<details>
<summary><a href="https://wiki.archlinux.org/title/OpenSSH">OPENSSH</a></summary>

```
sudo pacman -S openssh
```

### Setup

```
mkdir -p $HOME/.ssh
```

```
ssh-keygen -t ed25519 -C "user@device"
```

Save File

```
/home/user/.ssh/github_ed25519
```

First Push

```
loadkey github
config fetch
config pull --rebase
config remote set-url origin <url>
config push -u origin <main/master>
```

</details>

### `AUR Helper`

<details>
<summary><a href="https://github.com/Jguer/yay">YAY</a></summary>

Dependencies

```
sudo pacman -S --needed git base-devel
```

Installation

```
git clone https://aur.archlinux.org/yay.git
```

```
cd yay
```

```
makepkg -si
```

```
yay -S wallust
```

Cleanup

```
rm -rf yay/
```

</details>

### `Keyboard Language`

<details>
<summary><a href="https://wiki.archlinux.org/title/Fcitx5">FCITX5</a></summary>

```
sudo pacman -S fcitx5 fcitx5-configtool
```

### `Chinese Support`

<details>
<summary><a href="https://wiki.archlinux.org/title/Rime">FCITX5-RIME</a></summary>

```
sudo pacman -S fcitx5-rime
```

</details>
</details>

### `Auto-Theme`

<details>
<summary><a href="https://codeberg.org/explosion-mental/wallust">WALLUST</a></summary>

```
yay -S wallust
```

</details>

### `Wallpaper`

<details>
<summary><a href="https://github.com/hyprwm/hyprpaper">HYPRPAPER</a></summary>

```
sudo pacman -S hyprpaper
```

Dependency | for using random-wallpaper.sh script found in ~/.config/hypr/scripts/

```
sudo pacman -S pacman-contrib
```

</details>

### `File Manager`

<details>
<summary><a href="https://github.com/sxyazi/yazi">YAZI</a></summary>

```
sudo pacman -S yazi
```

</details>

### `Monitor Brightness`

<details>
<summary><a href="https://wiki.archlinux.org/title/Backlight#xbacklight">BRIGHTNESSCTL</a></summary>

```
sudo pacman -S brightnessctl
```

</details>

### `Screenshot`

<details>
<summary><a href="https://github.com/emersion/grim">GRIM</a> | <a href="https://github.com/emersion/slurp">SLURP</a> | <a href="https://github.com/jtheoof/swappy">SWAPPY</a></summary>

```
sudo pacman -S grim slurp swappy
```

</details>

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
