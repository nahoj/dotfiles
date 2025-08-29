X_STARTUP_FILES="$X_STARTUP_FILES#  ~/.zshrc  "
x_startup_log+=$(echo Running .zshrc|ts "%H:%M:%.S")

eval "$(direnv hook zsh)" # Can be low and moves the prompt down when finished

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

if [[ -d "$HOME/.local/share/zsh/generated_man_completions" ]]; then
  fpath+=("$HOME/.local/share/zsh/generated_man_completions")
fi

# <TAB> complete just what's before the cursor, ignoring anything after
bindkey '^i' expand-or-complete-prefix



# Oh-My-Zsh configuration
x_startup_log+=$(echo Running Oh-My-Zsh...|ts "%H:%M:%.S")

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    colored-man-pages
    colorize
    # not `direnv`, it's run in .zprofile
    dirhistory
    # "fzf-tab is shipped with a binary module to speed up this process. You
    # can build it with build-fzf-tab-module, then it will be enabled
    # automatically."
    fzf-tab
    git
    mvn-completion-only
    systemd
    zoxide
    # show suggestions while typing
    zsh-autosuggestions
    # search history with partial input
    zsh-history-substring-search
    # highlight incorrect/correct commands while typing
    zsh-syntax-highlighting

    # My own
    yazi-file-chooser
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh
x_startup_log+=$(echo Done.|ts "%H:%M:%.S")


# Insanet configuration
# https://insanet.eu/post/supercharge-your-terminal/

my_fzf_completion_opts='--bind=ctrl-z:ignore,btab:up,tab:down,space:accept --cycle --tiebreak=begin'

export FZF_DEFAULT_COMMAND='rg --no-messages --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--no-separator --layout=reverse --inline-info"
# zoxide directory preview options
export _ZO_FZF_OPTS="$my_fzf_completion_opts --no-sort --keep-right \
--height=50% --info=inline --layout=reverse --exit-0 --select-1 \
--preview='\command fzf-preview-file.sh {2..}' --preview-window=right "

#history
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"       # The path to the history file.
HISTSIZE=1000000000              # The maximum number of events to save in the internal history.
SAVEHIST=1000000000              # The maximum number of events to save in the history file.

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:*' fzf-preview 'fzf-preview-file.sh $realpath'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags ${(z)my_fzf_completion_opts}
# fzf-tab key bindings
zstyle ':fzf-tab:*' continuous-trigger 'right'
zstyle ':fzf-tab:*' print-query left
zstyle ':fzf-tab:*' switch-group ',' ';'
# exclude .. and . from completion
zstyle ':completion:*' special-dirs false
# show hidden files in completion
#setopt glob_dots

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor root line)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#4e4e4e"
ZSH_HIGHLIGHT_STYLES[cursor]='bg=#4e4e4e'

# emacs zle keys
# https://zsh.sourceforge.io/Guide/zshguide04.html
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word



# My configuration

setopt pushd_silent
unsetopt nomatch share_history

if [ -n $WAYLAND_DISPLAY$DISPLAY ]; then
  export EDITOR='lite'
else
  export EDITOR='emacs'
fi

#export MANPATH="/usr/local/man:$MANPATH"


alias 1pen='0pen -n 1'

alias as='PAGER=cat apt search'
alias asn='as -n'

autoload -U add-zsh-hook
auto_print(){
  if [[ $1 = '$'* ]]; then
    eval "print -r -- $3"
    read -sk key
    #echo "\e[32m[ANY] = Execute as a command \e[0m| \e[31m[Ctrl+c] = Cancel \e[0m"
    print -r "[ANY] = Execute as a command | [Ctrl+c] = Cancel"
    read -sk key
  fi
}
add-zsh-hook preexec auto_print

alias cursor='~/AppImages/cursor.AppImage --no-sandbox'
cv() { files=(${"${(@f)$(xsel -bo)}"#file://}); print -rl -- $files }
alias dd='dd status=progress'
# alias emacs='emacs -nw -r'
alias fd='fdfind'

fz() {
    local f command
    f=$(find * -type f | fzf) || return
    if [[ -n $f ]]; then
        command="$@ ${(qqq)f}"
    else
        command="$@ "
    fi
    print -rz $command
}
compdef _command fz

alias gco='git checkout'
alias gdi='git diff'
alias ggrep='PAGER=cat git grep -n'
gko() { git diff "$@" | kompare - }
alias gst='git status'

alias hs='homeshick'

alias l='eza'
alias la='eza --all --group-directories-first'
alias ll='la --long --git'
alias lla=ll

alias less='less -R'
alias logoutkde='qdbus org.kde.ksmserver /KSMServer logout 0 0 1'

alias ma='mpv -vo null'
alias mvi='mpv -fs'

alias mvn='mvnd'
alias o='xdg-open'
alias ocaml='rlwrap ocaml'
alias pe='playtag e'
alias pgrep='pgrep -a'

export PYTHONSTARTUP=$HOME/.homesick/repos/dotfiles/other/pythonstartup.py
alias p='python3'
alias pipx='pipx --system-site-packages'

alias rename='file-rename -d'
alias rip='rg -in'
alias rsync='rsync --info=progress2'


# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+=" ⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
# Alt+i
bindkey '^[i' _sgpt_zsh
# Shell-GPT integration ZSH v0.2

AI() {
  print -rz -- $(sgpt --shell --no-interaction <<< "$*")
}

_my_sgpt_zsh() {
  if [[ -n "$BUFFER" ]]; then
    local nohash=${BUFFER#'# '}
    print -s "# $nohash"
    BUFFER=" AI ${(qqq)nohash}"
    zle accept-line
  fi
}
zle -N _my_sgpt_zsh
# Alt+Enter
bindkey '^[^M' _my_sgpt_zsh


x_startup_log+=$(echo Running post-init...|ts "%H:%M:%.S")

[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# OPAM configuration
[[ -s "$HOME/.opam/opam-init/init.zsh" ]] && . "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

which rbenv > /dev/null && eval "$(rbenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

which task > /dev/null && eval "$(task --completion zsh)"

export TSS_DEBUG=x
autoload -U tss
# Array variables named tss_tags_* are added to tag suggestions for tss add
local tss_tags_ratings=(1star 2star 3star 4star 5star)
# local tss_tags_media=(toread reading read towatch watched)
# local tss_tags_workflow=(todo draft done published)
# local tss_tags_life=(family friends personal school vacation work other)

which zoxide > /dev/null && eval "$(zoxide init zsh)"


if [[ -s "$HOME/.zpostrc.zsh" ]]; then
  . "$HOME/.zpostrc.zsh"
fi

x_startup_log+=$(echo Done.|ts "%H:%M:%.S")
