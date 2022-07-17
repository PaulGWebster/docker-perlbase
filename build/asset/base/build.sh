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
&& echo "Import successful, removing object" \
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

cp -v ${REPODIR}/packed/automake-* ${OBJDIR}/   \
&& cp -v ${REPODIR}/packed/autoconf-* ${OBJDIR}/   \
&& cp -v ${REPODIR}/packed/make-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/gmp-* ${OBJDIR}/        \
&& cp -v ${REPODIR}/packed/mpc-* ${OBJDIR}/        \
&& cp -v ${REPODIR}/packed/mpfr-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/isl-* ${OBJDIR}/        \
&& cp -v ${REPODIR}/packed/pcre2-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/gettext-* ${OBJDIR}/    \
&& cp -v ${REPODIR}/packed/ncurses-* ${OBJDIR}/    \
&& cp -v ${REPODIR}/packed/perl-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/attr-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/bison-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/m4-* ${OBJDIR}/         \
&& cp -v ${REPODIR}/packed/gawk-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/groff-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/texinfo-* ${OBJDIR}/    \
&& checkstate=1 \
&& echo "Source preperation success."

if [ ${checkstate} == 1 ];
   then
      echo "Requirement collection success, building base"
      docker build . -t perlbase:base \
      && docker tag perlbase:base paulgwebster/perlbase:base \
      && checkstate=0 \
      && echo "Success building base"
   else
      echo "Failure copying required tarbells, bailing out"
fi

echo "Cleaning: ${OBJDIR}"
rm -Rfv ${OBJDIR}/*
