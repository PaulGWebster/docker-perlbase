#!/bin/sh

echo "Building entire image chain, this will take a while!"
echo "Sleeping 10 seconds, ctrl-c now to exit!"

sleep 10;

# Continuing with build, importing base image.
echo "Importing base, running base/build.sh:"
cd base && ./build.sh
