# extract the AppImae
FROM debian:buster-slim as extracter

WORKDIR /usr/src/app

ARG version="2.1.5.0-2"

ADD https://github.com/runelite-extended/launcher/releases/download/$version/RuneLitePlus.AppImage ./

RUN chmod 755 RuneLitePlus.AppImage

RUN ./RuneLitePlus.AppImage --appimage-extract

# run the extracted AppImage
FROM debian:buster-slim

WORKDIR /usr/src/app

# need some X packages
RUN apt-get update && apt-get install -y \
# x11 stuff
libxext6 \
libxrender1 \
libxtst6 \
# fonts
fontconfig

# keep runelite settings around
# argument could probably be made for keeping around the entire /root/ folder
# since runescape keeps cache there as well
VOLUME ["/root/.runelite"]

COPY --from=extracter /usr/src/app/squashfs-root ./

CMD ./AppRun

# note when running, you need to forward X
# forward display
# DISPLAY :0
# we also need to forward Xauth and Xsock
# so do the following to run it:
# XSOCK=/tmp/.X11-unix
# XAUTH=/tmp/.docker.xauth
# touch $XAUTH
# xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
# and then `docker run` with the following args:
# `-v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH`
