#!/usr/bin/env bash

minecraft_user=minecraft
minecraft_home=/home/minecraft
minecraft_service_file=/etc/systemd/system/minecraft.service

# shellcheck source=minecraft.default/lib.common.sh
source "${minecraft_home}/lib.common.sh" || exit 1

require_root

echo "This will delete the user ${minecraft_user}."
echo "This will delete the group ${minecraft_user}."
echo "This will delete their home directory, ${minecraft_home}."
echo "This will delete the service file ${minecraft_service_file}."
require_confirmation "Is this OK?"

echo "Deleting user ${minecraft_user}."
userdel "${minecraft_user}"

# The default configuration deletes the group too, but let's be thorough.
if [ "$(grep "^${minecraft_user}:" < /etc/group)" != "" ]; then
    groupdel "${minecraft_user}"
fi

echo "Deleting service file ${minecraft_service_file}."
rm "${minecraft_service_file}"
systemctl daemon-reload

echo "Deleting form user ${minecraft_user}'s home directory ${minecraft_home}."
rm -Rf "${minecraft_home}"

echo "Uninstall complete."
