if status is-interactive
    # --- Load Wallust Theme ---
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

    # -------------------------------------------------------- #
    # --- Section A: Syntax Highlighting (High Visibility) ---
    set -g fish_color_command       $color7
    set -g fish_color_error         $color7

    #set -g fish_color_param         $color8
    #set -g fish_color_quote         $color8
    #set -g fish_color_redirection   $color8
    #set -g fish_color_comment       $color7

    # --- Section B: Completion Menu ---
    set -g fish_color_autosuggestion $color5

    #set -g fish_pager_color_progress    $color8
    #set -g fish_pager_color_background  $background
    #set -g fish_pager_color_prefix      $color5
    #set -g fish_pager_color_completion  $color7
    #set -g fish_pager_color_selected_background $color5
    #set -g fish_pager_color_selected_prefix     $color8
    #set -g fish_pager_color_selected_completion $color7


    # --- Section C: File & Folder Colors (LS_COLORS) ---
    # di=Directory, ln=Symlink, ex=Executable
    # iset -gx LS_COLORS "di=1;36:ln=35:so=32:pi=33:ex=35:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=0"
    # -------------------------------------------------------- #

    # --- Aliases ---
    alias sleep='systemctl sleep'
    alias shutdown='shutdown now'
    alias music="spotify_player"
    alias clock="timr-tui --style light --mode localtime"
    alias icat='kitten icat'
    alias update='sudo pacman -Syu --noconfirm; pkill -SIGRTMIN+8 waybar'
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias ff='fastfetch --logo-position top --config ~/.config/fastfetch/config.jsonc --file ~/.config/fastfetch/ascii/cross2.txt'

    # --- Starship & Fastfetch ---
    set -gx STARSHIP_CONFIG $HOME/.cache/wal/starship.toml
    ff
end

set fish_greeting ""
starship init fish | source

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
