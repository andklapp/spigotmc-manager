# shellcheck shell=sh
## Configuration values for this SpigotMC Minecraft server.

# The maximum amount of memory allowed for the JVM's heap. Actual use will exceed this
# value a little.
export maximum_heap_size="2G"

# The initial amount of memory allocated to the JVM's heap. Lowering it allows it to consume
# less memory, but the server can hiccup when it needs to allocate more memory.
export initial_heap_size="1G"

# The number of backed up binaries to keep.
export max_backups=10
