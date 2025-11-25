if status is-interactive
    set -gx STARSHIP_CONFIG $HOME/.cache/wal/starship.toml

    # Load pywal colors on startup
    cat ~/.cache/wal/sequences

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

# --- PYWAL RELOAD FUNCTION ---
# This function runs whenever it receives the "SIGUSR1" signal.
# It reloads colors and forces the prompt to redraw immediately.
function update_wal_colors --on-signal SIGUSR1
    # 1. Inject color sequences (changes background instantly)
    cat ~/.cache/wal/sequences

    # 2. Source variable definitions (so $color1 etc. are updated for scripts)
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # 3. Repaint the prompt (Fixes the "Press Enter" issue)
    commandline -f repaint
end
