#!/usr/bin/env bash
# Usage: yazi-picker.sh [open|vsplit|hsplit] [start_dir]
paths=$(yazi "${2:-$(pwd)}" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

# Always close the floating pane
zellij action toggle-floating-panes

if [[ -n "$paths" ]]; then
  zellij action write 27                 # <Esc>
  zellij action write-chars ":${1:-open} $paths"
  zellij action write 13                 # <Enter>
fi
