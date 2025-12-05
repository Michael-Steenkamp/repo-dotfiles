if status is-interactive
    # --- Load Wallust Theme ---
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # --- Aliases ---
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
    alias ff='fastfetch --logo-position top --config ~/.config/fastfetch/config.jsonc --file ~/.config/fastfetch/ascii/cross2.txt'

    # --- Starship & Fastfetch ---
    set -gx STARSHIP_CONFIG $HOME/.cache/wal/starship.toml
    ff
end

set fish_greeting ""
starship init fish | source

function clear
    command clear
    ff
end

function pdf
    command nohup okular $argv >/dev/null 2>&1 &
    disown
    if status is-interactive
        exit
    end
end

# --- Wallust Reload Function ---
function update_wallust_colors --on-signal SIGUSR1
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # Re-apply High Visibility settings on reload
    set -g fish_color_command $color15
    set -g fish_color_param $color14

    commandline -f repaint
end

function show-palette
    # Ensure we have the latest colors
    if test -f ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    echo "   Index  Variable     Hex        Preview"
    echo "   -----  --------     -------    -------"

    # Special Background/Foreground
    printf "   %-6s %-12s %-10s " "BG" "\$background" "$background"
    set_color -b $background; echo -n "          "; set_color normal; echo ""

    printf "   %-6s %-12s %-10s " "FG" "\$foreground" "$foreground"
    set_color -b $foreground; echo -n "          "; set_color normal; echo ""
    echo ""

    # Loop through 0-15
    for i in (seq 0 15)
        set var_name "color$i"
        set hex_val $$var_name

        # Print Index, Var Name, Hex
        printf "   %-6s %-12s %-10s " "$i" "\$$var_name" "$hex_val"

        # Print Color Block
        set_color -b $hex_val
        echo -n "          "
        set_color normal

        # Print Text Sample (to see readability)
        set_color $hex_val
        echo "  This is text"
        set_color normal
    end
end
