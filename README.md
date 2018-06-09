# SpigotMC-manager
SpigotMC-manager is a set of scripts to make managing a SpigotMC Minecraft server easier.

### Notice
This is pretty casually developed software. It may contain bugs. If you think you've found
one, please submit an issue.

## Capabilities

### Things it does now:
* Sets up a SpigotMC server running under a dedicated user.
* Can set up multiple instances under different users on one system.
* Updates SpigotMC.
* Provides a systemd service file for keeping track of each service.

### Things it does not do yet, but are intended:
* Input validation. Most errors will stop the install and clean up the mess.
* Smart updates that only compile new code when it's actually changed.
* Command line options for scripted installs.
* Regular automatic updates via systemd timer.

### Things that are out of scope:
* Multiple instances under one user.
* Set up an instance under an existing user.

## Dependencies
* Java
* Git
* tmux

## Usage
* To install a server, run the `install.sh` script provided and follow the prompts.
* Starting, stopping, and restarting can all be done with systemctl as usual.
* Updating can be done by calling the `update-spigot.sh` as the dedicated user.
* Uninstalling a server can be done with the `uninstall.sh` script in the user's home directory as
    the root user.
* There are a few configuration options in the `config.sh` file in the user's home directory. They
    are distributed usable defaults.

## Notes
Ubuntu 18.04 changed the the way Java stores SSL keys. This will break SPigotMC's BuildTools. See
[this StackOverflow question](https://stackoverflow.com/questions/6784463/error-trustanchors-parameter-must-be-non-empty#6788682)
for a workaround.
