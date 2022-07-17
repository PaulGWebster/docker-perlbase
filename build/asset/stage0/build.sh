#!/bin/bash

ORIGIN=$(pwd)
OBJDIR=$(cd "${ORIGIN}/obj" && pwd)
REPODIR=$(cd "${ORIGIN}/../repo" && pwd)

mkdir -p "${OBJDIR}"

echo "Copying required repo sources"

checkstate=0

cp -v ${REPODIR}/packed/pcre2-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/gettext-* ${OBJDIR}/    \
&& cp -v ${REPODIR}/packed/ncurses-* ${OBJDIR}/    \
&& cp -v ${REPODIR}/packed/perl-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/attr-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/bison-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/m4-* ${OBJDIR}/         \
&& cp -v ${REPODIR}/packed/gawk-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/groff-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/texinfo-* ${OBJDIR}/    \
&& checkstate=1

if [ ${checkstate} == 1 ];
   then
      echo "Additional package bundle copy success."
      checkstate=0
   else
      echo "Failure copying package bundle"
      exit 1
fi

echo "Recreating gcc tarbell, if it does not exist"

if [ ! -f "obj/gcc-12.1.0.tar.gz" ];
then
   cd "${REPODIR}/split/gcc1.12.0" \
   && cat * > "${OBJDIR}/gcc-12.1.0.tar.gz" \
   && cd "${ORIGIN}"
else
   echo "Tarbell already exists"
fi

cp -v ${REPODIR}/packed/automake-* ${OBJDIR}/      \
&& cp -v ${REPODIR}/packed/autoconf-* ${OBJDIR}/   \
&& cp -v ${REPODIR}/packed/make-* ${OBJDIR}/       \
&& cp -v ${REPODIR}/packed/gmp-* ${OBJDIR}/        \
&& cp -v ${REPODIR}/packed/mpc-* ${OBJDIR}/        \
&& cp -v ${REPODIR}/packed/mpfr-* ${OBJDIR}/       \
&& checkstate=1

if [ ${checkstate} == 1 ];
   then
      echo "GCC Rebuild sources copied, building."
      checkstate=0
      docker build . -t perlbase:stage0 \
      && docker tag perlbase:stage0 paulgwebster/perlbase:stage0 \
      && checkstate=1
   else
      echo "Failure copying gcc bundle"
      exit 1
fi

if [ ${checkstate} == 1 ];
   then
      echo "Failure building docker base!"
   else
      echo "Sucess building image"
fi

echo "Cleaning: ${OBJDIR}"
rm -Rfv ${OBJDIR}/*
