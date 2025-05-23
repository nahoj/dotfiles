X_STARTUP_FILES="$X_STARTUP_FILES#  ~/.zprofile  "
x_startup_log+=$(echo Running .zprofile...|ts "%H:%M:%.S")


# I don't remember why this
unset GTK_IM_MODULE
unset QT_IM_MODULE


# Avoid some spurious GTK app warnings such as:
# "Couldn't register with accessibility bus: Did not receive a reply. Possible
# causes include: the remote application did not send a reply, the message bus
# security policy blocked the reply, the reply timeout expired, or the network
# connection was broken."
export NO_AT_BRIDGE=1


# Some environment setup so that graphical apps in the session can see
# node, Java, etc.
# But no full nvm/sdkman init scripts, to speed up session startup (they do
# compinit).

if [[ -d "$HOME/.cargo" ]]; then
  path=("$HOME/.cargo/bin" $path)
fi

if [[ -r "$HOME/.nvm/alias/default" ]]; then
  default=$(cat "$HOME/.nvm/alias/default")
  path=("$(print -rl -- $HOME/.nvm/versions/node/v$default*/bin(On) | head -n 1)" $path)
fi

if [[ -d "$HOME/.sdkman/candidates/java/current" ]]; then
  export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
  path=("$JAVA_HOME/bin" $path)
else
  export JAVA_HOME=$(dirname $(dirname $(readlink -f /etc/alternatives/java)))
fi

path=("$HOME/bin" "$HOME/.local/bin" $path)


x_startup_log+=$(echo Done.|ts "%H:%M:%.S")
