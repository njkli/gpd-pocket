![GPD Pocket](https://raw.githubusercontent.com/njkli/gpd-pocket/master/imgs/pocket_arch.png "Yay Gimp!")

* Made possible by [Hans de Goede](https://github.com/jwrdegoede/linux-sunxi) and [cawilliamson](https://github.com/cawilliamson/ansible-gpdpocket)
* Publicity by [Josh Skidmore](https://github.com/joshskidmore)
* [ArchLinux wiki page](https://wiki.archlinux.org/index.php/GPD_Pocket) by [Kye W. Shi](https://github.com/kwshi)

# njkli/gpd-pocket
* In hopes of 4.15 having ootb support, here's a bit of a quick-fix(TM) - because why pollute AUR?
* The intent is to obsolete this repo ASAP!
* USE AT YOUR OWN RISK - read the sources and decide if it's your cup'o'tea
* [My rant/review](https://github.com/njkli/gpd-pocket/blob/master/rant.md) of this device

## Install
```
# install the keyring
baseurl="https://github.com/njkli/archlinux/releases/download/keyring"
kring="$baseurl/njkli-keyring-20170902-1-any.pkg.tar.xz"
kring_sig="$baseurl/njkli-keyring-20170902-1-any.pkg.tar.xz.sig"
kring_files=("${kring}" "${kring_sig}")

for i in ${kring_files[@]}; do curl -OfssL $i; done

gpg --keyserver hkp://keys.gnupg.net --recv-keys A09383D0550C42E2D6CE7C822F90CB4F042140DC
gpg --verify njkli-keyring-20170902-1-any.pkg.tar.xz.sig


rm -rf njkli-keyring-20170902-1-any.pkg.tar.xz.sig
sudo pacman -U --noconfirm njkli-keyring-20170902-1-any.pkg.tar.xz

sudo runuser -l -c \
'cat >> /etc/pacman.conf << EOL
[gpd-pocket]
SigLevel = Required TrustedOnly
Server = https://github.com/njkli/\$repo/releases/download/\$arch
EOL
'

# --force is required to overwrite alsa ucm profiles
sudo pacman -Syyu --force gpd-pocket-support
```

## Features/Bugs:
* systemd-boot (EFI 64bit = grub is extraneous)
* [GPD "ubuntu" BIOS](http://www.gpd.hk/news.asp?id=1519&selectclassid=002002)
  ```
  sha256sum Rom_8MB_Tablet.bin
  # 7510862031b1c616e6079b6a41afe566bc7f5cb17e1a71ad48746c579f733a6e  Rom_8MB_Tablet.bin
  ```
* xkb fixes - del/backspace
* xorg.conf.d/ goodies for touchscreen/orientation
* pulseaudio
* wifi/bt

## Comments
[arch-anywhere / Anarchy Linux](https://arch-anywhere.org/) is worth checking out if painless Arch install is the goal.
While [Official Arch install docu](https://wiki.archlinux.org/index.php/Installation_guide) provides more in-depth details, it isn't the quickest way of doing things.

## Packages
* linux-jwrdegoede
* gpd-pocket-support

## TODO:
* Integrate [touchegg](https://github.com/JoseExposito/touchegg)
* properly merge config.x86_64 into Hans's .config

## FIXME:
* alsa-lib installs it's own /usr/share/alsa/ucm/chtrt5645 and it conflicts with our copies.
* Will someone knowledgeable in PKGBUILD please give a pointer, as to how to reconcile the above discrepancy!
