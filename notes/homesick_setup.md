# Homesick setup

~/.homesick/ is a real dir with repos/ symlinked to the actual castles location, e.g.:

- ~/.homesick/repos → ~/perso/soft/homesick
- ~/.homesick/repos → ~/projects/homesick

## Setup steps

1. Clone/copy castles to the target dir (e.g. ~/projects/homesick/{dotfiles,private,homeshick})
2. mkdir ~/.homesick && ln -s ~/projects/homesick ~/.homesick/repos
3. source ~/.homesick/repos/homeshick/homeshick.sh && homeshick link dotfiles --force

## Coreutils 0.2.2  dirname bug

Make sure coreutils are either GNU or uutils 0.3+.
