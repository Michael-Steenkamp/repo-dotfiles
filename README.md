<a id="readme-top"></a>

# Dotfiles

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

## Packages Via Pacman

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
