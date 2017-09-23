#!/bin/bash

# Colored makepkg-like functions
all_off="$(tput sgr0)"
bold="${all_off}$(tput bold)"
blue="${bold}$(tput setaf 4)"
yellow="${bold}$(tput setaf 3)"
msg_blue() {
    printf "${blue}==>${bold} $1${all_off}\n"
}
note(){
    printf "${blue}==>${yellow} NOTE:${bold} $1${all_off}\n"
}
# Colored makepkg-like functions

REPONAME="njkli"
REPODIR="/opt/${REPONAME}/archlinux/$(uname -m)"

_dkr() {
    TEMP_MOUNT="${PWD}/njkli-repo:/usr/local/bin/njkli-repo"

    arg=$1
    vol_pkgdir="${arg}:/home/dev/pkg"

    vol_build="/tmp/build:/tmp/makepkg"
    vol_yaourt="/tmp/yaourt:/home/dev/tmp/yaourt"
    vol_pkginst="/opt/njkli/archlinux/$(uname -m):/home/dev/install"
    vol_gpg="$HOME/.gnupg:/home/dev/.gnupg:rw"
    dkr_volumes="-v ${vol_build} -v ${vol_yaourt} -v ${vol_pkgdir} -v ${vol_pkginst} -v ${vol_gpg} -v ${TEMP_MOUNT}"
    dkr_img="njkli/makepkg"
    dkr_opts="--rm -ti --name makepkg"

    # refresh the image
    export refreshed=$(docker pull $dkr_img)

    DKR="docker run ${dkr_opts} ${dkr_volumes} ${dkr_img} /usr/local/bin/njkli-repo"
    echo $DKR
}

_mkpkg() {
    [[ ! $(find ./ -name *.pkg.tar.xz) ]] && eval "$(_dkr $PWD)"
    [[ $(find ./ -name \*.pkg.tar.xz\*) ]] && \
        msg_blue "mv *.pkg.tar.xz* $REPODIR" && \
        mv *.pkg.tar.xz $REPODIR
}

_mkpkgs() {
    local dir=$PWD
    for pkg in $(ls $PWD/*/PKGBUILD)
    do
        cd $(dirname $pkg)
        _mkpkg
    done
    cd $dir
}

_mkclean() {
    msg_blue "find $REPODIR -name *.sig -delete"
    find $REPODIR -name *.sig -delete &> /dev/null

    msg_blue "find $REPODIR -name *.tar.gz -delete"
    find $REPODIR -name *.tar.gz -delete &> /dev/null

    msg_blue "find $REPODIR -name *.old -delete"
    find $REPODIR -name *.old -delete &> /dev/null

    msg_blue "find $REPODIR -type l -delete"
    find $REPODIR -type l -delete &> /dev/null

    rm -rf $REPODIR/$REPONAME.{db,files}
}

_sign_pkgs() {
    msg_blue "find $REPODIR/*.pkg.tar.xz -exec gpg --detach-sign '{}' ';'"
    find $REPODIR/*.pkg.tar.xz -exec gpg --detach-sign '{}' ';'
}

_mkrepo() {
    local ext="db files"
    _mkclean
    _sign_pkgs

    msg_blue "repo-add --sign $REPODIR/$reponame.db.tar.gz $REPODIR/*.pkg.tar.xz"
    repo-add --sign $REPODIR/$REPONAME.db.tar.gz $REPODIR/*.pkg.tar.xz

    find $REPODIR -type l -delete
    for i in ${ext[@]}
    do
        msg_blue "mv $REPODIR/$reponame.$i.tar.gz $REPODIR/$reponame.$i"
        mv $REPODIR/$REPONAME.$i.tar.gz $REPODIR/$REPONAME.$i

        msg_blue "mv $REPODIR/$REPONAME.$i.tar.gz.sig $REPODIR/$REPONAME.$i.sig"
        mv $REPODIR/$REPONAME.$i.tar.gz.sig $REPODIR/$REPONAME.$i.sig
    done
}

_mkrelease() {
    local dir=$PWD
    cd $REPODIR
    local files=$(find ./ -type f | awk -F'/' '{print $2}')

    for f in ${files[@]}
    do
        msg_blue "github-release upload -t $(uname -m) -n $f -f $f -R"
        github-release upload -t $(uname -m) -n $f -f $f -R
    done
    cd $dir
}


mkdir -p /tmp/{build,yaourt}
sudo chmod 0777 /tmp/{build,yaourt}

if [ $# -eq 0 ]; then
    _mkpkgs
    _mkrepo
    _mkrelease
else
    [[ $1 == "release" ]] && _mkrepo && _mkrelease
    [[ $1 == "refresh" ]] && _mkrepo
    [[ $(find ./ -type d -name $1) ]] && cd $1 && _mkpkg
fi
