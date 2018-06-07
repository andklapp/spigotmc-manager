#!/usr/bin/env bash

mcrcon_path="${HOME}/mcrcon"
server_properties_path="${HOME}/server/server.properties"

spigot_rcon_port="$(sed "s;rcon.port=*;;" "${server_properties_path}")"
spigot_rcon_password="$(sed "s;rcon.password=*;;" "${server_properties_path}")"

${mcrcon_path} -H localhost -P "${spigot_rcon_port}" -p "${spigot_rcon_password}" stop
