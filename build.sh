#!/usr/bin/env bash
# from here
# https://github.com/MozillaSecurity/orion/wiki/Build-ARM64-on-AMD64
USER=blacs30
NAME=docker-protonmail-personal-gateway
VERSION=2

for arch in armv7 amd64; do
    if [ "$arch" = "armv7" ]; then
        docker buildx build --build-arg TARGETPLATFORM=armhf --push -t $USER/$NAME:${arch}-18.04 -t $USER/$NAME:${arch}-latest  -f Dockerfile.armv7 .
    else
        docker buildx build --build-arg TARGETPLATFORM=${arch} --push -t $USER/$NAME:${arch}-18.04 -t $USER/$NAME:${arch}-latest   .
    fi
done
