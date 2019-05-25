#!/bin/bash

#Solution borrowed from https://github.com/itzg/dockerfiles/blob/master/minecraft-server/start-minecraft.sh
if [ ! -f /minecraft/eula.txt ]; then
  if [ "$EULA" != "" ]; then
    echo "# Generated via Docker on $(date)" > eula.txt
    echo "eula=$EULA" > /minecraft/eula.txt
  else
    echo ""
    echo "Please accept the Minecraft EULA at"
    echo "  https://account.mojang.com/documents/minecraft_eula"
    echo "by adding the following immediately after 'docker run':"
    echo "  -e EULA=TRUE"
    echo "or editing eula.txt to 'eula=true' in your server's data directory."
    echo ""
    exit 1
  fi
fi
cd /minecraft
if [[ "$TRAVIS" = true ]]; then
    echo "stop" | java -jar /minecraft/spigot.jar
else
    [ ! -f /minecraft/server.properties ] || [ "${FORCE_CONFIG}" = "true" ] && python3 /minecraft/configure.py
    java -jar /minecraft/spigot.jar
fi
