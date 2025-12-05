if status is-interactive
    # --- Load Wallust Theme ---
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # --- Section A: Syntax Highlighting (High Visibility) ---
    #set -g fish_color_command       $color7
    #set -g fish_color_param         $color8
    #set -g fish_color_quote         $color8
    #set -g fish_color_redirection   $color8
    set -g fish_color_error         $color3
    #set -g fish_color_comment       $color8

    # --- Section B: Completion Menu ---
    #set -g fish_pager_color_progress    $color8
    #set -g fish_pager_color_background  $background
    #set -g fish_pager_color_prefix      $color5
    #set -g fish_pager_color_completion  $color5
    #set -g fish_pager_color_selected_background $color5
    #set -g fish_pager_color_selected_prefix     $color8
    #set -g fish_pager_color_selected_completion $color7

    # --- Section C: File & Folder Colors (LS_COLORS) ---
    # di=Directory, ln=Symlink, ex=Executable
    # iset -gx LS_COLORS "di=1;36:ln=35:so=32:pi=33:ex=35:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=0"

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
