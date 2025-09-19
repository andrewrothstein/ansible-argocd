#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/argoproj/argo-cd/releases/download
APP=argocd

dl()
{
    local lchecksums=$1
    local ver=$2
    local os=$3
    local arch=$4
    local dotexe=${5:-}
    local platform="$os-$arch"
    local file="${APP}-${platform}${dotexe}"
    local url="${MIRROR}/${ver}/${file}"

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dlver () {
    local ver=$1

    # https://github.com/argoproj/argo-cd/releases/download/v2.13.3/cli_checksums.txt
    local checksums_url="${MIRROR}/${ver}/cli_checksums.txt"
    local lchecksums="${DIR}/argocd_${ver}_checksums.txt"
    if [ ! -e "${lchecksums}" ];
    then
        curl -sSLf -o "${lchecksums}" "${checksums_url}"
    fi

    printf "  # %s\n" $checksums_url
    printf "  %s:\n" $ver
    dl $lchecksums $ver linux amd64
    dl $lchecksums $ver linux arm64
    dl $lchecksums $ver linux ppc64le
    dl $lchecksums $ver linux s390x
    dl $lchecksums $ver darwin amd64
    dl $lchecksums $ver darwin arm64
    dl $lchecksums $ver windows amd64 .exe
}

dlver ${1:-v3.1.6}
