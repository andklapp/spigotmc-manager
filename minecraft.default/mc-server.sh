#!/usr/bin/env bash

# shellcheck source=minecraft.default/config.sh
source "${HOME}/config.sh"
server_path="${HOME}/server"

cd "${server_path}" || exit 1

/usr/bin/java -Xmx${maximum_heap_size} -Xms${initial_heap_size} -jar spigot.jar
