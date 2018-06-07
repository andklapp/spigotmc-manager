#!/usr/bin/env bash

# shellcheck source=minecraft.default/lib.common.sh
source "${HOME}/lib.common.sh" || exit 1

buildtools_url="https://hub.spigotmc.org/jenkins/job/BuildTools/lastStableBuild/artifact/target/BuildTools.jar"
build_dir="${HOME}/build/spigot"
server_path="${HOME}/server/spigot.jar"

mkdir -p "${build_dir}"
cd "${build_dir}" || fatal "Failed to move to build directory."

echo "Downloading BuildTools."
curl -o BuildTools.jar "${buildtools_url}" || fatal "Failed to download BuildTools."

echo "Running BuildTools to update Spigot."
java -jar BuildTools.jar || fatal "Failed to update Spigot."

# cut -d "/" in this case is a quick-n-dirty basename.
fresh_build_name="$(grep "Saved as ./spigot" "BuildTools.log.txt" | cut -d "/" -f 2)"

install_binary "${fresh_build_name}" "${server_path}"
backup_rotate "spigot*"
