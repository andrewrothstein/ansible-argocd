#!/usr/bin/env sh
DIR=~/Downloads
MIRROR=https://github.com/argoproj/argo-cd/releases/download
APP=argocd

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local platform="$os-$arch"
    local url=$MIRROR/$ver/$APP-$platform
    local lfile=$DIR/$APP-$ver-$platform

    if [ ! -e $lfile ];
    then
        wget -q -O $lfile $url
    fi

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dlver () {
    local ver=$1
    printf "  %s:\n" $ver
    dl $ver linux amd64
    dl $ver darwin amd64
}

dlver ${1:-v2.1.3}
