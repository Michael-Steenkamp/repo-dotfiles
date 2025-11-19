if status is-interactive
    # Load pywal colors
    cat ~/.cache/wal/sequences
    # Commands to run in interactive sessions can go here
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

    # Alias for managing dotfiles with a bare repo
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

