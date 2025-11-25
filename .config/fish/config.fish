if status is-interactive
    # 1. Point Starship to the cached config (Wallust updates this)
    set -gx STARSHIP_CONFIG $HOME/.cache/wal/starship.toml

    # Commands to run in interactive sessions
    fastfetch

    alias calendar='nohup morgen >/dev/null 2>&1 & exit'
    alias mail='nohup thunderbird >/dev/null 2>&1 & exit'
    alias sleep='systemctl sleep'
    alias shutdown='shutdown now'
    alias network="nm-connection-editor"
    alias music="spotify_player"
    alias clock="timr-tui --style light --mode localtime"
    alias clock-work="timr-tui --style light --mode pomodoro --work '1:00:00' --pause '10:00' --blink on --notification on"

    alias icat='kitten icat'
    alias update='sudo pacman -Syu --noconfirm'
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
end

set fish_greeting ""
starship init fish | source

function clear
    command clear
    fastfetch
end

function pdf
    command nohup okular $argv >/dev/null 2>&1 &
    disown
    if status is-interactive
        exit
    end
end

# --- WALLUST RELOAD FUNCTION ---
# This runs when random-wallpaper.sh sends SIGUSR1
function update_wallust_colors --on-signal SIGUSR1
    # 1. Source variable definitions (updates $foreground/$background variables if used in prompt)
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # 2. Repaint the prompt
    commandline -f repaint
end
