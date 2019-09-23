#!/usr/bin/bash

version="2.1.5.0-2"
tag="runeliteplus:$version"

# build - should generally be all cached so it's quick
# also we don't need a build context, since we volume mount at run time
docker build -f Dockerfile -t $tag --build-arg version=$version ../empty-context

# setup X11
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
# assume we've already done the xauth call if $XAUTH has stuff in it
if ! [ -s $XAUTH ]; then
	touch $XAUTH
	xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
fi

x11args="-v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH"
volumes="-v $(pwd)/volumes/runelite:/root/.runelite"

# run
docker run -it $x11args $volumes $tag $@
