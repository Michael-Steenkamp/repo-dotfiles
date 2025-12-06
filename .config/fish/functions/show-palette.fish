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

