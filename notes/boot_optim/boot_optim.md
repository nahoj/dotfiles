For speed in early boot (before disk encryption pwd).


## Handy commands

```shell
lsinitramfs /boot/initrd.img-$(uname -r)

sudo systemctl reboot --firmware-setup
```


## GRUB

/etc/default/grub

```shell
GRUB_TIMEOUT=0

# drop "splash"
# I'm unsure whether "noplymouth" is redundant with /etc/initramfs-tools/conf.d/no-plymouth
# untested: "rdinitdebug" to time stuff
GRUB_CMDLINE_LINUX_DEFAULT="... noplymouth usbcore.autosuspend=-1"

GRUB_TERMINAL=console
GRUB_GFXPAYLOAD_LINUX=text
```

```shell
sudo update-grub
```


## Initramfs

/etc/initramfs-tools/initramfs.conf

```shell
INIT=systemd
# With blacklisting in ./hooks/prune-initramfs
#MODULES=dep
# With ./modules file
MODULES=list
COMPRESS=lz4
```

`MODULES=list` is not better than `dep` for boot time, but it makes the initramfs a LOT smaller.

```shell
sudo update-initramfs -u
```
