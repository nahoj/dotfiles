# Define the ZLE widget
_insert_yazi_files() {
  emulate -L zsh

  local cur dir part_dir files qfile_list

  # grab the current word under cursor
  cur=${LBUFFER##* }

  # if it has a slash, use that dir; else use $PWD
  if [[ $cur == */* ]]; then
    part_dir=${cur%/*}
    dir=$part_dir
  else
    dir=$PWD
  fi

  # run Yazi chooser in that dir, collect newline‑separated output
  cd "$dir" || return
  files=("${(@f)$(yazi --chooser-file /dev/stdout)}") || return
  (( ${#files} == 0 )) && return

  # quote each path and join with spaces
  qfile_list="${(j: :)${(qq)files[@]}}"

  # replace the old word with the quoted file list
  LBUFFER="${LBUFFER%$cur}${qfile_list}"
  zle redisplay
}

# Turn it into a ZLE widget & bind to Ctrl‑Y
zle -N insert-yazi-files _insert_yazi_files
bindkey '^Y' insert-yazi-files
