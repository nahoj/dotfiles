# Homesick setup

~/.homesick/ is a real dir with repos/ symlinked to the actual castles location, e.g.:

- ~/.homesick/repos → ~/perso/soft/homesick
- ~/.homesick/repos → ~/projects/homesick

## Setup steps

1. Clone/copy castles to the target dir (e.g. ~/projects/homesick/{dotfiles,private,homeshick})
2. mkdir ~/.homesick && ln -s ~/projects/homesick ~/.homesick/repos
3. source ~/.homesick/repos/homeshick/homeshick.sh && homeshick link dotfiles --force

## Homeshick bug fix required

homeshick has a bug in lib/fs.sh `abs_path()`: `dirname "/home/user/."` returns
`/home` instead of `/home/user`, causing broken relative symlinks for all castle
files.

Fix: in `abs_path()`, when `base` is `.`, `cd` into `$path` directly instead of
`cd`-ing into `dirname "$path"`. See the patched fs.sh in the homeshick castle.
