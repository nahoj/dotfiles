export X_STARTUP_FILES="$X_STARTUP_FILES#  ~/.zshenv  "
x_startup_log=("$(echo Running .zshenv|ts "%H:%M:%.S")" $x_startup_log)

fpath+="$HOME/.local/share/zsh/site-functions"

# Compinit done in .zshrc. Skipping it in /etc/zshrc speeds up startup big time.
skip_global_compinit=1
