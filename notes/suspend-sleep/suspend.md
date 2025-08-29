Ubuntu utilise un mode de veille légère, s2idle, par défaut.

Pour avoir une veille plus profonde, il faut utiliser le mode deep :

- Ajouter `mem_sleep_default=deep` à `GRUB_CMDLINE_LINUX_DEFAULT` dans `/etc/default/grub`
- Mettre à jour GRUB avec `sudo update-grub`

Pour éviter que mon MX Keys Mini / Logi Bolt ne réveille le système, il faut créer une règle udev :

```bash
sudo cp 99-usb-wakeup-block-logibolt.rules /etc/udev/rules.d/
sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=usb
```

## More (GPT-5)

### Test with deep sleep (one-off):

    echo deep | sudo tee /sys/power/mem_sleep

### Why s2idle is the default:
- Platform/firmware trend: Many modern laptops (esp. recent Intel/AMD) either don’t expose S3 (deep) anymore or mark it unreliable. Firmware advertises s2idle as the supported “mem” state, so Linux defaults to it.

### Why many laptops dropped S3 “deep” sleep:
Platform strategy (Windows Modern Standby/S0ix)
OEMs optimize for Windows “instant-on” (S0ix = Linux s2idle).
Certification programs and UX targets (fast resume, “always connected” updates, BT/voice wake) push vendors toward S0ix.
Cost/complexity of supporting both S3 and S0ix
Maintaining stable S3 paths (full device power-down + reinit) and S0ix paths doubles firmware/driver validation.
Vendors often disable S3 in firmware to simplify testing and reduce support issues.
When well-implemented, S0ix can be as efficient as S3
With aggressive device power-gating, S0ix can approach S3 battery use.
But tuning is OS/vendor specific; on Linux, missing firmware hooks/driver quirks can leave devices in higher-power states → warm laptops and drain.
Connected-standby feature set
“Wake on notifications,” network updates, BT/USB wake, etc., are easier in S0ix and considered a UX win on Windows.
Side effect: more spurious wakes if not tuned.*

