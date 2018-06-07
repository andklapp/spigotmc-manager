# shellcheck shell=bash
# A set of functions needed for these Minecraft helper scripts.

# shellcheck source=minecraft.default/config.sh
source "${HOME}/config.sh"

install_binary()
{
    fresh_build=$1 # The full path of the binary to install.
    link_name=$2   # The full path of the link file to make.

    if [[ $# != 2 ]]; then
        fatal "Not enough arguments for install_binary."
    fi

    bin_path="${HOME}/bin"

    if [[ ! -e "${bin_path}" ]]; then
        mkdir "${bin_path}"
    fi

    # TODO: Maybe move file extensions to the actual end of the filename.
    original_filename="$(basename "${fresh_build}")"
    current_date="$(date +"%Y-%m-%H")"
    installed_path="${bin_path}/${original_filename}-${current_date}"

    cp "${fresh_build}" "${installed_path}" || fatal "Copying binary failed."
    ln -fs "${installed_path}" "${link_name}" || fatal "Creating link failed."
}

backup_rotate()
{
    name_pattern=$1

    bin_path="${HOME}/bin"

    echo "Checking for more than ${max_backups} files in ${bin_path} matching ${name_pattern}."

    while [[ $(ls_by_reverse_date "${bin_path}" "${name_pattern}" | wc -l) > ${max_backups} ]]; do
        file_to_delete="$(ls_by_reverse_date "${bin_path}" "${name_pattern}" | cut -d $'\n' -f1)"
        echo "Deleting oldest file ${file_to_delete}."
        rm "${file_to_delete}"
    done

}

ls_by_reverse_date()
{
    # This is a pretty long command, so now it's a function. Yes, it doesn't actually use ls.
    search_directory="$1"
    search_pattern="$2"

    find "${search_directory}" -name "${search_pattern}" -follow -type f -printf '%T@ %p\n' \
        | sort -nr | cut -d " " -f2
}

require_root()
{
    if [ $EUID -ne 0 ]; then
        fatal "This script requires root privileges."
    fi
}

require_confirmation()
{
    prompt="$1"
    read -r -p "${prompt} [yN]" -n 1 input
    if [[ ! $input =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi
}

# Basic error handling functions.
fatal()
{
    echo "Fatal error: $1"
    exit 1
}

debug()
{
    if [ "$MC_DEBUG" = "yes" ]; then
        echo "Debug: $1"
    fi
}
