#!/bin/bash
# Colored makepkg-like functions
all_off="$(tput sgr0)"
bold="${all_off}$(tput bold)"
blue="${bold}$(tput setaf 4)"
yellow="${bold}$(tput setaf 3)"

msg_blue() {
    printf "${blue}==>${bold} $1${all_off}\n"
}

note() {
    printf "${blue}==>${yellow} NOTE:${bold} $1${all_off}\n"
}

REPODIR=$PWD/repo
BUILDUSER=builduser

_mk_clean_env() {
    sudo useradd -m -g users -G wheel -s /bin/bash $BUILDUSER
}

_rm_clean_env() {
    sudo userdel -f -r $BUILDUSER
}

_mkrepo() {
    local reponame=gpd-pocket
    local ext="db files"

    msg_blue "repo-add $REPODIR/$reponame.db.tar.gz $REPODIR/*.pkg.tar.xz"
    repo-add $REPODIR/$reponame.db.tar.gz $REPODIR/*.pkg.tar.xz

    for i in ${ext[@]}
    do
        msg_blue "rm $REPODIR/$reponame.$i"
        rm $REPODIR/$reponame.$i

        msg_blue "mv $REPODIR/$reponame.$i.tar.gz $REPODIR/$reponame.$i"
        mv $REPODIR/$reponame.$i.tar.gz $REPODIR/$reponame.$i
    done
}

_mkpkg() {
    local tempdir="/tmp/build"
    local pkgdirname="$(basename $PWD)"
    local builddir="$tempdir/$pkgdirname"

    msg_blue $builddir
    sudo rm -rf $builddir
    [[ ! -d $tempdir ]] && sudo mkdir -p $tempdir

    sudo cp --recursive "../$pkgdirname" $tempdir
    sudo chown --recursive $BUILDUSER:users $builddir

    msg_blue "Building in $builddir"
    sudo runuser -l $BUILDUSER -c "cd $builddir && makepkg -s -f --noconfirm"
    sudo chown $UID:$GID $builddir/*.pkg.tar.xz
    cp $builddir/*.pkg.tar.xz ./
    sudo rm -rf $builddir
}

_mkpkgs() {
    local dir=$PWD
    _mk_clean_env
    for pkg in $(ls $PWD/*/PKGBUILD)
    do
        cd $(dirname $pkg)
        [[ ! $(find ./ -name *.pkg.tar.xz) ]] && _mkpkg

        msg_blue "mv *.pkg.tar.xz $REPODIR"
        mv *.pkg.tar.xz $REPODIR
    done
    _rm_clean_env
    cd $dir
}

_mkrelease() {
    git
}

_mkclean() {
    find $PWD -name *.pkg.tar.xz -delete
}

_mkpkgs
_mkrepo
# _mkrelease
