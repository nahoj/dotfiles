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
# "noplymouth" may or may not be helping
# untested: "rdinitdebug" to time stuff
GRUB_CMDLINE_LINUX_DEFAULT="... noplymouth usbcore.autosuspend=-1"

GRUB_TERMINAL=console
```

```shell
sudo update-grub
```


## Initramfs

Note: /boot/initrd.img-* is sometimes 45Mo with lz4 and sometimes >300Mo with xz -9. I don't know what triggers one or the other.

/etc/initramfs-tools/initramfs.conf

```shell
INIT=systemd
MODULES=dep
COMPRESS=lz4
```

```shell
sudo update-initramfs -u
```
