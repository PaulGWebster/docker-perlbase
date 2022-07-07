#!/bin/sh

echo "Creating image, please wait."

cd split-src \
&& cat * > ../base.dockerimg \
&& echo "Importing image as perlbase:base" \
&& cd .. \
&& docker import base.dockerimg perlbase:base \
&& echo "Import successful, consider removing base.dockerimg to save space."
