# taken from: http://www.st0ne.at/?q=node/58

# get id of the focused window
active_win_id=$(xprop -root | grep '^_NET_ACTIVE_W' | cut -d' ' -f5)
shell_command=$(xprop -id "$active_win_id" | grep 'WM_COMMAND' | awk '{print $4}' | tr -d '"')
exec $shell_command &

