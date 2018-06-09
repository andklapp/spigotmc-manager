#!/usr/bin/env bash
# A simple install script for SpigotMC Minecraft servers.

source "./minecraft.default/lib.common.sh" || exit 1

require_input()
{
    default_value="$1"
    input=""
    while [[ "$input" == "" ]]; do
        read -r -e -p ": " -i "${default_value}" input
    done
    echo "${input}"
}

require_binary()
{
    if ! [ "$(command -v "$1" 2>/dev/null )" ]; then
        fatal "$1 is not installed, aborting."
    fi
}

do_cleanup()
{
    if [ "$1" -ne "0" ]; then
        echo "Install did not exit cleanly, cleaning up."
        if [ "${state_default_directory_copied}" = "true" ]; then
            echo "Deleting temporary files."
            rm -R "./${temp_home_dir}"
        fi

        if [ "${state_user_created}" = "true" ]; then
            echo "Deleting user and group."
            userdel -r "${minecraft_user}"
            groupdel "${minecraft_user}"
        fi

        if [ "${state_service_file_copied}" = "true" ]; then
            echo "Deleting service file."
            rm "${service_file_target}"
            systemctl daemon-reload
        fi
        echo "Cleanup complete."
    fi

}

trap 'do_cleanup $?' EXIT

require_root

require_binary "git"
require_binary "java"
require_binary "tmux"

# TODO: Eventually add normal options for this.

# TODO: Check if this user exists and ask for another if it does.
echo "Enter the user that the server will run as:"
minecraft_user="$(require_input "minecraft")"

# TODO: This should either not exist or be empty.
echo "Enter the home directory:"
minecraft_home="$(require_input "/home/minecraft")"

# TODO: Port numbers need to be numbers within a range.
echo "Enter the port that the server will listen on for players:"
echo "Please make sure this port is not in use by other programs."
minecraft_port="$(require_input 25565)"

# TODO: Make sure this service file doesn't already exist.
echo "Enter the service name for this server:"
minecraft_service_name="$(require_input "minecraft")"

service_file_name="${minecraft_service_name}.service"
service_file_target="/etc/systemd/system/${minecraft_service_name}.service"


require_confirmation "Installing with these settings. Is this OK?"

# This is more for reference than anything else.
state_user_created="false" # Also implies that the home directory has been created.
state_default_directory_copied="true"
state_service_file_copied="false"

echo "Adding user ${minecraft_user}."
useradd -U -d "${minecraft_home}" -s "/bin/bash" "${minecraft_user}" || fatal "Could not add user."
state_user_created="true"

temp_home_dir="$(basename "${minecraft_home}")"
debug "Copying default home directory."
cp -r "./minecraft.default" "./${temp_home_dir}" || fatal "Could not copy default directory."
state_default_directory_copied="true"

debug "Populating server.properties."
server_prop_file="./${temp_home_dir}/server/server.properties"
echo "server-port=${minecraft_port}" > "${server_prop_file}"

debug "Configuring uninstaller."
sed -i "s;^minecraft_user=*\$;minecraft_user=${minecraft_user};g" "./${temp_home_dir}/uninstall.sh"
sed -i "s;^minecraft_home=*\$;minecraft_home=${minecraft_home};g" "./${temp_home_dir}/uninstall.sh"
sed -i "s;^minecraft_service_file=*\$;minecraft_service_file=${service_file_target};g" "./${temp_home_dir}/uninstall.sh"
chmod +x "./${temp_home_dir}/uninstall.sh"

echo "Moving files into new home directory."
mv "./${temp_home_dir}" "${minecraft_home}"

chown -R "${minecraft_user}":"${minecraft_user}" "${minecraft_home}"

debug "Modifying default service file."
cp "minecraft.service.default" "${service_file_name}"
sed -i "s;/home/minecraft;${minecraft_home};g" "${service_file_name}"
sed -i "s;User=minecraft;User=${minecraft_user};g" "${service_file_name}"
sed -i "s;Group=minecraft;Group=${minecraft_user};g" "${service_file_name}"

echo "Installing service file."
# Move the systemd service file to the proper place.
mv "${minecraft_service_name}.service" "${service_file_target}" || fatal "Could not copy service file."
state_service_file_copied="true"

echo "Downloading and building initial server software. This can take a while."
runuser "${minecraft_user}" "${minecraft_home}/update-spigot.sh"

echo "Installation complete. Run systemctl start ${minecraft_service_name} to start the server."
