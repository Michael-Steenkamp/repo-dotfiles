if status is-interactive
    # --- Load Wallust Theme ---
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # --- Section A: Syntax Highlighting (High Visibility) ---
    # Using 'Bright' variants ($color15, $color14) instead of 'Normal' ($foreground, $color4)
    set -g fish_color_command       $color15    # Bright White (Main command)
    set -g fish_color_param         $color14    # Bright Cyan (Arguments/Files)
    set -g fish_color_quote         $color10    # Bright Green (Strings)
    set -g fish_color_redirection   $color13    # Bright Magenta (Pipes/Redirection)
    set -g fish_color_error         $color9     # Bright Red (Typos)
    set -g fish_color_comment       $color8     # Grey (Comments)

    # --- Section B: Completion Menu ---
    set -g fish_pager_color_progress    $color8
    set -g fish_pager_color_background  $background
    set -g fish_pager_color_prefix      $color14
    set -g fish_pager_color_completion  $color15
    set -g fish_pager_color_selected_background $color14
    set -g fish_pager_color_selected_prefix     $background
    set -g fish_pager_color_selected_completion $background

    # --- Section C: File & Folder Colors (LS_COLORS) ---
    # Changed 'di' from 1;34 (Blue) to 1;36 (Bold Cyan) for visibility
    # di=Directory, ln=Symlink, ex=Executable
    set -gx LS_COLORS "di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=0"

    # --- Starship & Fastfetch ---
    set -gx STARSHIP_CONFIG $HOME/.cache/wal/starship.toml
    fastfetch --logo-position top --config ~/.config/fastfetch/config.jsonc

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
end

set fish_greeting ""
starship init fish | source

function clear
    command clear
    fastfetch --logo-position top --config ~/.config/fastfetch/config.jsonc
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
