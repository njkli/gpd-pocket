![GPD Pocket](https://raw.githubusercontent.com/njkli/gpd-pocket/master/imgs/pocket_arch.png "Yay Gimp!") Made possible by [Hans de Goede](https://github.com/jwrdegoede/linux-sunxi) and [cawilliamson](https://github.com/cawilliamson/ansible-gpdpocket)

# njkli/gpd-pocket
*  In hopes of 4.15 having ootb support, here's a bit of a quick-fix(TM) - because why pollute AUR?
*  The intent is to obsolete this repo ASAP!

## Features/Bugs:
* systemd-boot (EFI 64bit = grub is extraneous)
* gpd-fan binary (python has it's uses, but not here)
* lightdm only
* xkb fixes - del/backspace

## Installation
tail -n 3 /etc/pacman.conf
```
[gpd-pocket]
SigLevel = Optional TrustAll
Server = https://github.com/njkli/$repo/raw/master/repo
```

## TODO:

* properly merge config.x86_64 into Hans's .config
