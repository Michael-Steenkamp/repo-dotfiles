function pdf
    command nohup okular $argv >/dev/null 2>&1 &
    disown
    if status is-interactive
        exit
    end
end

