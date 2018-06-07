#!/usr/bin/env bash

# shellcheck source=minecraft.default/lib.common.sh
source "${HOME}/lib.common.sh" || exit 1

build_dir="${HOME}/build"

mkdir -p "${build_dir}"
cd "${build_dir}" || fatal "Failed to move to the build directory."

# TODO: Git can check for updates. Do that instead of always building.
echo "Downloading most recent mcrcon source."
# Exit on error so that we don't compile something wrong.
git clone "https://github.com/Tiiffi/mcrcon.git" || fatal "git clone failed."

echo "Compiling mcrcon."
# This cd shouldn't fail unless the git clone did.
cd "mcrcon" || fatal "Failed to move to git directory."
gcc -o mcrcon mcrcon.c || fatal "Failed to compile mcrcon."

echo "Installing new mcrcon binary."
install_binary "./mcrcon" "${HOME}/mcrcon"
backup_rotate "mcrcon*"
