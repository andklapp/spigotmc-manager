# SpigotMC-manager
SpigotMC-manager is a set of scripts to make managing a SpigotMC Minecraft server easier.

## Capabilities

### Things it does now:
* Sets up a SpigotMC server running under a dedicated user.
* Can set up multiple instances under different users on one system.
* Updates SpigotMC and mcrcon.
* Provides a systemd service file for keeping track of each service.

### Things it does not do yet, but are intended:
* Input validation. Most errors will stop the install and clean up the mess.
* Smart updates that only compile new code when it's actually changed.
* Command line options for scripted installs.
* Regular automatic updates via systemd timer.

### Things that are out of scope:
* Multiple instances under one user.
* Set up an instance under an existing user.

## Usage
* To install a server, run the `install.sh` script provided and follow the prompts.
* Starting, stopping, and restarting can all be done with systemctl as usual.
* Updating can be done by calling the `update-spigot.sh` and `update-mcrcon.sh` as the dedicated user.
* Uninstalling a server can be done with the `uninstall.sh` script in the user's home directory as
    the root user.
