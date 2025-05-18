#!/usr/bin/env bash

# Forked from: https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh
# MIT License

# Preview a file or directory in the preview window of fzf.
#
# Dependencies:
# - https://github.com/sharkdp/bat
# - https://github.com/hpjansson/chafa
# - eza


# Parse input
if [[ $# -gt 1 ]]; then
  echo $@
  >&2 echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

file=${1/#\~\//$HOME/}

center=0
if [[ ! -r $file ]]; then
  if [[ $file =~ ^(.+):([0-9]+)\ *$ ]] && [[ -r ${BASH_REMATCH[1]} ]]; then
    file=${BASH_REMATCH[1]}
    center=${BASH_REMATCH[2]}
  elif [[ $file =~ ^(.+):([0-9]+):[0-9]+\ *$ ]] && [[ -r ${BASH_REMATCH[1]} ]]; then
    file=${BASH_REMATCH[1]}
    center=${BASH_REMATCH[2]}
  fi
fi


# Check if file exists
if [[ ! -r $file ]]; then
  exit 1
fi


# Preview a directory
if [[ -d $file ]]; then
  eza --long --all --color=always  "$file"
  exit
fi


type=$(file --brief --dereference --mime -- "$file")

# Preview an image
if [[ $type =~ image/ ]]; then
  dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
  if [[ $dim = x ]]; then
    dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
  elif ! [[ $KITTY_WINDOW_ID ]] && (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
    # Avoid scrolling issue when the Sixel image touches the bottom of the screen
    # * https://github.com/junegunn/fzf/issues/2544
    dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
  fi

  # Use chafa with Sixel output
  if command -v chafa > /dev/null; then
    chafa -s "$dim" "$file"
    # Add a new line character so that fzf can display multiple images in the preview window
    echo
  fi


# Preview a text file
elif [[ ! $type =~ =binary ]]; then
  # Sometimes bat is installed as batcat.
  if command -v batcat > /dev/null; then
    batname="batcat"
  elif command -v bat > /dev/null; then
    batname="bat"
  else
    cat "$1"
    exit
  fi

  ${batname} --style="${BAT_STYLE:-numbers}" --color=always --pager=never --highlight-line="${center:-0}" -- "$file"
fi


file "$file"