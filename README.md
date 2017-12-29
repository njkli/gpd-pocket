![GPD Pocket](https://raw.githubusercontent.com/njkli/gpd-pocket/master/imgs/pocket_arch.png "Yay Gimp!")

* Made possible by [Hans de Goede](https://github.com/jwrdegoede/linux-sunxi) and [cawilliamson](https://github.com/cawilliamson/ansible-gpdpocket)
* Publicity by [Josh Skidmore](https://github.com/joshskidmore)
* [ArchLinux wiki page](https://wiki.archlinux.org/index.php/GPD_Pocket) by [Kye W. Shi](https://github.com/kwshi)

# njkli/gpd-pocket

* In hopes of soon having ootb support, here's a bit of a quick-fix(TM) - because why pollute AUR?
* The intent is to obsolete this repo ASAP!
* USE AT YOUR OWN RISK - read the sources and decide if it's your cup'o'tea
* [My rant/review](https://github.com/njkli/gpd-pocket/blob/master/rant.md) of this device

## Install

```
sudo runuser -l -c \
'cat >> /etc/pacman.conf << EOL
[gpd-pocket]
SigLevel = Optional TrustAll
Server = https://github.com/njkli/\$repo/releases/download/\$arch
EOL
'

sudo pacman -Syu --noconfirm gpd-pocket-support
```

## Features/Bugs:

* systemd-boot (EFI 64bit = grub is extraneous)
* [GPD "ubuntu" BIOS](http://www.gpd.hk/news.asp?id=1519&selectclassid=002002)
  ```
  sha256sum Rom_8MB_Tablet.bin
  # 7510862031b1c616e6079b6a41afe566bc7f5cb17e1a71ad48746c579f733a6e  Rom_8MB_Tablet.bin
  ```
* alsa-lib replacement (with necessary patch)
* display rotation - xorg only
* display tearfree - xorg only
* touchscreen calibration - wayland and xorg
* touchscreen rotation - wayland and xorg
* pulseaudio
* wifi/bt

## Comments

[arch-anywhere / Anarchy Linux](https://arch-anywhere.org/) is worth checking out if painless Arch install is the goal.
While [Official Arch install docu](https://wiki.archlinux.org/index.php/Installation_guide) provides more in-depth details, it isn't the quickest way of doing things.

## Packages

* alsa-lib-gpd-pocket
* gpd-pocket-scrolling
* gpd-pocket-support
* linux-jwrdegoede
