### Supported tags and respective `Dockerfile` links

# Simple Tags
| Tag      | Notes |
|----------|-------|
| `1.14.1` |       |
| `latest` | Builds the default ref from [GetBukkit](https://getbukkit.org/) (1.14.1 at the time of this writing) |

# Docker Bukkit

A Docker Spigot server based on Alpine and OpenJDK 12.

### Running the server

To start the server and accept the EULA in one fell swoop, just pass the `EULA=true` environment variable to Docker when running the container. I recommend mounting a directory from your host onto `/minecraft` in the container to make map and server minecraft persistent.

`docker run -it -v /minecraft:/minecraft -p 25565:25565  -e EULA=true --name mc_server sawn/minecraft-spigot` 

To run in the background (recommended), add the `-d` flag.

To specify an UID/GID for the user executing spigot, set UID/GID environment variables (default: 1000).

### Configuration

You can bring your own existing minecraft + configuration and mount it to the `/minecraft` directory when starting the container by using the `-v` option. You may also pass configuration options as environment variables like so:

`docker run -it -e DIFFICULTY=2 -e MOTD="A non-standard message" -e SPAWN_ANIMALS=false sawn/minecraft-spigot`

This container will only attempt generate a `server.properties` file if one does not already exist. If you would like to use the configuration tool, be sure that you are not providing a configuration file or that you also set `FORCE_CONFIG=true` in the environment variables.

#### Environment Files

Because of the potentially large number of environment variables that you could pass in, you might want to consider using an [environment variable file](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file). 

Example:
```
# env.list
ALLOW_NETHER=false
level-seed=123456789
EULA=true
```

`docker run -d -it --env-file env.list -v $(pwd)/minecraft:/minecraft -p 25565:25565 sawn/minecraft-spigot`

#### List of Environment Variables

A full list of `server.properties` settings and their corresponding environment variables is included below, along with their defaults

| Configuration Option          | Environment Variable          | Default                                                          |
| ------------------------------|-------------------------------|------------------------------------------------------------------|
| allow-flight                  | ALLOW_FLIGHT                  | `false`                                                          |
| allow-nether                  | ALLOW_NETHER                  | `true`                                                           |
| difficulty                    | DIFFICULTY                    | `1`                                                              |
| enable-command-block          | ENABLE_COMMAND_BLOCK          | `false`                                                          |
| enable-query                  | ENABLE_QUERY                  | `false`                                                          |
| enable-rcon                   | ENABLE_RCON                   | `false`                                                          |
| force-gamemode                | FORCE_GAMEMODE                | `false`                                                          |
| gamemode                      | GAMEMODE                      | `0`                                                              |
| generate-structures           | GENERATE_STRUCTURES           | `true`                                                           |
| generator-settings            | GENERATOR_SETTINGS            |                                                                  |
| hardcore                      | HARDCORE                      | `false`                                                          |
| level-name                    | LEVEL_NAME                    | `world`                                                          |
| level-seed                    | LEVEL_SEED                    |                                                                  |
| level-type                    | LEVEL_TYPE                    | `DEFAULT`                                                        |
| max-build-height              | MAX_BUILD_HEIGHT              |  `256`                                                           |
| max-players                   | MAX_PLAYERS                   | `20`                                                             |
| max-tick-time                 | MAX_TICK_TIME                 | `60000`                                                          |
| max-world-size                | MAX_WORLD_SIZE                | `29999984`                                                       |
| motd                          | MOTD|                         | `"A Minecraft server powered by Docker (image: bbriggs/bukkit)"` |
| network-compression-threshold | NETWORK_COMPRESSION_THRESHOLD | `256`                                                            |
| online-mode                   | ONLINE_MODE                   | `true`                                                           |
| op-permission-level           | OP_PERMISSION_LEVEL           | `4`                                                              |
| player-idle-timeout           | PLAYER_IDLE_TIMEOUT           | `0`                                                              |
| prevent-proxy-connections     | PREVENT_PROXY_CONNECTIONS     | `false`                                                          |
| pvp                           | PVP                           | `true`                                                           |
| resource-pack                 | RESOURCE_PACK                 |                                                                  |
| resource-pack-sha1            | RESOURCE_PACK_SHA1            |                                                                  |
| server-ip                     | SERVER_IP                     |                                                                  |
| server-port                   | SERVER_PORT                   | `25565`                                                          | 
| snooper-enabled               | SNOOPER_ENABLED               | `true`                                                           |
| spawn-animals                 | SPAWN_ANIMALS                 | `true`                                                           |
| spawn-monsters                | SPAWN_MONSTERS                | `true`                                                           |
| spawn-npcs                    | SPAWN_NPCS                    | `true`                                                           |
| view-distance                 | VIEW_DISTANCE                 | `10`                                                             |
| white-list                    | WHITE_LIST                    | `false`                                                          |


### Running a specific version

To run a specific version of Bukkit or Spigot, use a docker tag. 

Example:
`docker run -it -v /minecraft:/minecraft -p 25565:25565  -e EULA=true --name mc_server sawn/minecraft-spigot:1.14.1` 
