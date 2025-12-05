function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")

    # --- 1. Turn ON Opacity for Yazi ---
    # We always want Yazi to be solid for readability
    kitten @ set-background-opacity 1.0

    command yazi $argv --cwd-file="$tmp"

    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end

    rm -f "$tmp"

    # --- 2. Smart Restore Opacity ---
    # Instead of forcing 0.5, we check if the toggle-opacity script has a lock active.

    # Check if dependencies exist to avoid errors
    if type -q hyprctl; and type -q jq
        # Get the current window address (ID)
        set window_info (hyprctl activewindow -j)
        set addr (echo $window_info | jq -r ".address")

        # Check for the specific lock file created by toggle-opacity.sh
        set lock_file "/tmp/hypr_opacity_$addr.lock"

        if test -e "$lock_file"
            # Lock exists? We were in 'Dark Mode' before Yazi. Stay Dark.
            kitten @ set-background-opacity 1.0
        else
            # No lock? We were transparent. Return to config default.
            kitten @ set-background-opacity 0.5
        end
    else
        # Fallback: If we can't check state, default to transparent
        kitten @ set-background-opacity 0.5
    end
end
