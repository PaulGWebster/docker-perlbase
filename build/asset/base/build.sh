#!/bin/bash

ORIGIN=$(pwd)
OBJDIR=$(cd "${ORIGIN}/obj" && pwd)
REPODIR=$(cd "${ORIGIN}/../repo" && pwd)

mkdir -p "${OBJDIR}"

echo "Checking if base object already exists ..."

if [ ! -f "obj/prebase.dockerimg" ];
then
   echo "It does not, creating ..."
   cd "${REPODIR}/split/dockerhub:gcc1.12.0" \
   && cat * > "${OBJDIR}/prebase.dockerimg" \
   && cd "${ORIGIN}"
else
   echo "Object already exists, skipping creation."
fi

echo "Importing object as perlbase:prebase" \
&& docker import "${OBJDIR}/prebase.dockerimg" perlbase:prebase \
&& echo "Import successful" \
&& rm "${OBJDIR}/prebase.dockerimg"

echo "Recreating gcc tarbell, if it does not exist"

if [ ! -f "obj/gcc-12.1.0.tar.gz" ];
then
   cd "${REPODIR}/split/gcc1.12.0" \
   && cat * > "${OBJDIR}/gcc-12.1.0.tar.gz" \
   && cd "${ORIGIN}" 
else
   echo "Tarbell already exists"
fi

echo "Docker build target: obj/gcc-12.1.0.tar.gz"
echo "Copying required repo sources"

cp ${REPODIR}/packed/automake-* ${OBJDIR}/   \
&& cp ${REPODIR}/packed/autoconf-* ${OBJDIR}/   \
&& cp ${REPODIR}/packed/make-* ${OBJDIR}/       \
&& cp ${REPODIR}/packed/gmp-* ${OBJDIR}/        \
&& cp ${REPODIR}/packed/mpc-* ${OBJDIR}/        \
&& cp ${REPODIR}/packed/mpfr-* ${OBJDIR}/       \
&& echo "Source preperation success: "

ls "${OBJDIR}"
