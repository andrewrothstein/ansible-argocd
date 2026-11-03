#!/usr/bin/env bash
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

    local sum
    sum=$(awk -v f="$file" '$2 == f || $2 == "*" f {print $1}' "$lchecksums")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'; then
        echo "no valid checksum for $file in $lchecksums" >&2
        exit 1
    fi

    printf "    # %s\n" "$url"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

dlver () {
    local ver=$1

    # https://github.com/argoproj/argo-cd/releases/download/v2.13.3/cli_checksums.txt
    local checksums_url="${MIRROR}/${ver}/cli_checksums.txt"
    local lchecksums="${DIR}/argocd_${ver}_checksums.txt"
    if [ ! -e "${lchecksums}" ];
    then
        curl -fsSL --proto '=https' --tlsv1.2 -o "${lchecksums}" "${checksums_url}"
    fi

    printf "  # %s\n" "$checksums_url"
    printf "  %s:\n" "$ver"
    dl "$lchecksums" "$ver" linux amd64
    dl "$lchecksums" "$ver" linux arm64
    dl "$lchecksums" "$ver" linux ppc64le
    dl "$lchecksums" "$ver" linux s390x
    dl "$lchecksums" "$ver" darwin amd64
    dl "$lchecksums" "$ver" darwin arm64
    dl "$lchecksums" "$ver" windows amd64 .exe
}

for v in "${@:-v3.5.7}"; do
    dlver "$v"
done
