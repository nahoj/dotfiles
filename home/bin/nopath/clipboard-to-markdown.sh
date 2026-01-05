#!/bin/bash

# -----------------------------------------------------------------------------
# CLIPBOARD TO MARKDOWN
# -----------------------------------------------------------------------------
# Convert clipboard content to ready-to-paste Markdown.
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Johan Grande
# License: MIT
# -----------------------------------------------------------------------------

TARGET_FMT="gfm-raw_html"
PANDOC_OPTS="-t $TARGET_FMT --wrap=none"

# Unwrap Divs inside Tables.
# Pandoc doesn't convert HTML tables to pipe tables if they contain block-level
# elements, or at least divs.
LUA_FILTER='
function Table(el)
  return pandoc.walk_block(el, {
    Div = function(div)
      return div.content
    end
  })
end
'

# Helper Function
convert_and_notify() {
    local clipboard_type="$1"
    local source_fmt="$2"
    local label="$3"

    wl-paste -t "$clipboard_type" \
    | pandoc -f "$source_fmt" $PANDOC_OPTS --lua-filter <(echo "$LUA_FILTER") \
    | wl-copy

    notify-send "Clipboard to Markdown" "Converted from $label"
}

# Main Logic
AVAILABLE_MIMES=$(wl-paste --list-types)

if echo "$AVAILABLE_MIMES" | grep -q "text/html"; then
    convert_and_notify "text/html" "html" "HTML"

elif echo "$AVAILABLE_MIMES" | grep -qE "text/rtf|application/rtf"; then
    RTF_MIME=$(echo "$AVAILABLE_MIMES" | grep -E "text/rtf|application/rtf" | head -n 1)
    convert_and_notify "$RTF_MIME" "rtf" "RTF"

elif echo "$AVAILABLE_MIMES" | grep -q "text/x-tex"; then
    convert_and_notify "text/x-tex" "latex" "LaTeX"

else
    notify-send "Clipboard to Markdown" "No rich text found"
fi
