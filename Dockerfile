# Bukkit for Docker
#     Copyright (C) 2015 Bren Briggs

#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License along
#     with this program; if not, write to the Free Software Foundation, Inc.,
#     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

FROM openjdk:12-alpine as builder
ARG BUKKIT_VERSION=1.14.1
WORKDIR /minecraft
RUN apk update && \
    apk --no-cache add wget git bash && \
    wget -O /minecraft/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    java -jar BuildTools.jar --rev $BUKKIT_VERSION  2>&1 /dev/null

FROM openjdk:12-alpine

# Set default UID for non-root user
ENV UID=1000

# Create non-root user
RUN adduser -D -u $UID -h /minecraft -s /sbin/nologin mcuser && \
    apk update && \
    apk add --no-cache python3 bash && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
USER mcuser
WORKDIR /minecraft
COPY --from=builder /minecraft/spigot-*.jar /minecraft/spigot.jar
EXPOSE 25565
ADD entrypoint.sh /entrypoint.sh
ADD configure.py /configure.py
ENTRYPOINT ["/entrypoint.sh"]
