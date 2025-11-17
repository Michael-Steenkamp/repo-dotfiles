# Arch Guide - Packages & Applications
## System:
``` Bootloader ``` | <a href="https://www.reddit.com/r/archlinux/comments/13d7rec/setting_up_secure_boot_while_dual_booting_windows/">refind</a>

``` Network ``` | <a href="https://wiki.archlinux.org/title/NetworkManager#Configuration">networkmanager</a> <a href="https://wiki.archlinux.org/title/NetworkManager#Configuration">nm-connection-editor</a>

``` Audio ``` | <a href="https://wiki.archlinux.org/title/PipeWire">pipewire</a> <a href="https://archlinux.org/packages/extra/x86_64/pavucontrol/">pavucontrol</a>

``` Window Manager ``` | <a href="https://wiki.archlinux.org/title/Hyprland">hyprland</a>

``` Bluetooth ``` | <a href="https://wiki.archlinux.org/title/Blueman">blueman</a>

``` Display Manager ``` | <a href="https://wiki.archlinux.org/title/Ly">ly</a>
### Setup
```
sudo systemctl start ly.service
```

## Essential:
``` Text Editor ``` | <a href="https://neovim.io/">nvim</a> <a href="https://linux.die.net/man/1/nano">nano</a>

``` Base Development ``` | <a href="">base-devel</a>

``` File Pager Utility ``` | <a href="https://archlinux.org/packages/core/x86_64/less/">less</a>

``` Version Control ``` | <a href="https://wiki.archlinux.org/title/Git">git</a>
### Initial Setup:
```
git config --global user.name ""
```
```
git config --global user.email ""
```
```
git config --global core.editor neovim
```
### Dotfiles Setup:
#### Clone dotfiles repo
```
git clone --bare https://github.com/Michael-Steenkamp/Dotfiles.git $HOME/.dotfiles
```
#### Run fish and then terminate
```
fish
exit
```
#### Modify config.fish
```
nvim $HOME/.config/fish/config.fish
```
#### Add line to config.fish
```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
#### Reload Terminal
#### Run Fish and run command
```
fish
config config --local status.showUntrackedFiles no
```
#### Make temp directory
```
mkdir -p $HOME/.todelete
```
```
config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p $HOME/.todelete/$(dirname{}) && mv {} $HOME/.todelete/{}'
```
```
rm -rf $HOME/.todelete
```


``` SSH Client ``` | <a href="https://wiki.archlinux.org/title/OpenSSH">openssh</a>
### Setup Client
```
mkdir -p $HOME/.ssh
```
```
ssh-keygen -t ed25519 -C "user@device"
```
#### File to save
```
/home/user/.ssh/github_ed25519
```

#### Steps for first push
```
loadkey github
config fetch
config pull --rebase
config remote set-url origin git@github.com:Michael-Steenkamp/Dotfiles.git
config push -u origin main
```




``` AUR Helper ``` | <a href="https://github.com/Jguer/yay">yay</a>

``` Browser ``` | <a href="https://wiki.archlinux.org/title/Firefox">firefox</a>

``` Wallpaper Utility ``` | <a href="https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/">hyprpaper</a>

``` Window Bar ``` | <a href="https://wiki.archlinux.org/title/Waybar">waybar</a>
#### Note:
<p>If icon showing no internet, ensure the .config/waybar/config.jsonc 'interface' is correct</p>
<p>Use command [nmcli] to find interface name (usually wlpxsy)</p>

``` Fonts ``` | <a href="https://wiki.archlinux.org/title/Fonts">noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-font-awesome ttf-jetbrains-mono-nerd otf-font-awesome</a>
### Reload Cache
```
fc-cache
```

## Keyboard Tools:
``` Clipboard ``` | <a href="https://github.com/savedra1/clipse?tab=readme-ov-file#installation">clipse</a>
### Download
```
git clone https://aur.archlinux.org/clipse.git
cd clipse
makepkg -si
cd ..
rm -rf clipse
```

``` Keyboard Language ``` | <a href="https://wiki.archlinux.org/title/Fcitx5">fcitx5</a> <a href="https://wiki.archlinux.org/title/Fcitx5">fcitx5-configtool</a>

``` Chinese Support ``` | <a href="https://wiki.archlinux.org/title/Rime">fcitx5-rime</a>

## Terminal Tools:
``` File Manager ``` | <a href="https://github.com/sxyazi/yazi">yazi</a>
``` Monitor Brightness ``` | <a href="https://wiki.archlinux.org/title/Backlight#xbacklight">brightnessctl</a>
``` Screenshot ``` | <a href="https://github.com/emersion/grim">grim</a> <a href="https://github.com/emersion/slurp">slurp</a> <a href="https://github.com/jtheoof/swappy">swappy</a>
