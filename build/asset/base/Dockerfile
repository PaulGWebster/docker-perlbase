FROM perlbase:prebase AS base-part1

RUN mkdir -p /build

WORKDIR /build

# Copy all source files into /build
ADD obj/* /build/

# Copy required files into the gcc source directory
RUN rm -Rf gcc \
&& cp -R gcc-* gcc \
&& cp -R mpc-* gcc/mpc \
&& cp -R mpfr-* gcc/mpfr \
&& cp -R gmp-* gcc/gmp \
&& cp -R isl-* gcc/isl

# Compile using the on-system gcc
RUN cd make-* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd automake-* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd autoconf-2* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd autoconf-a* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd mpfr-* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd mpc-* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd gmp-* && ./configure --prefix=/usr && make -j8 && make install clean
RUN cd isl-* && ./configure --prefix=/usr && make -j8 && make install clean

# Compile gcc-12 from the on-system gcc and libs and install it
RUN cd gcc \
&& mkdir build \
&& cd build \
&& ../configure --prefix=/usr --disable-multilib \
&& make -j8 \
&& make install

# Install gettext with the new gcc before removing all packages
RUN cd gettext-* && ./configure --prefix=/usr && make -j8 && make install

# Clean the system of anything we do not need
RUN apt remove --purge      \
    x11-common              \
    python3                 \
    subversion              \
    hicolor-icon-theme      \
    libx11-dev              \
    mysql-common            \
    perl                    \
    sensible-utils          \
    readline-common         \
    openssl                 \
    openssh-client          \
    libtool                 \
    libncurses5-dev         \
    -y

RUN apt autoremove --purge -y

RUN  apt remove --purge     \
    ncurses-bin             \
    libncurses-dev          \
    libncursesw5-dev        \
    -y                      \
    --allow-remove-essential

# Compile all the missing packages with our new gcc-12 hybrid (uses old ld)
RUN cd make-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd m4-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd ncurses-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd perl-* && sh Configure \
    -de \
    -Dprefix=/usr \
    -Doptimize="-O3 -pipe -fstack-protector -fno-strict-aliasing"   \
&& make -j8 \
&& make install
RUN cd autoconf-2* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-a* && ./configure --prefix=/usr && make -j8 && make install
RUN cd automake-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpfr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpc-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gmp-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd pcre2-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd attr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd texinfo-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd bison-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gawk-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd groff-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd ncurses-* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd gettext-* && make -j8 && make install

RUN echo "/usr/local/linux" > /etc/ld.so.conf.d/x86_64-linux-gnu.conf

# # Remove the libs provided by the on-site gcc
# # also make sure the linux headers are included in ld.so.conf
RUN echo "/usr/local/linux" > /etc/ld.so.conf.d/x86_64-linux-gnu.conf

RUN rm -Rf /build

FROM scratch AS base-part2

COPY --from=base-part1 / /

# Setup the env
RUN mkdir -p /build
WORKDIR /build
ADD obj/* /build/

# # Recompile gcc now ld is not pointing towards the old gcc sources
RUN cp -R gcc-* gcc \
&& cp -R mpc-* gcc/mpc \
&& cp -R mpfr-* gcc/mpfr \
&& cp -R gmp-* gcc/gmp \
&& cp -R isl-* gcc/isl

RUN mkdir gcc/build \
&& cd gcc/build \
&& ../configure --prefix=/usr --disable-multilib \
&& make -j8 \
&& make install

RUN cd make-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd m4-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd ncurses-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd perl-* && sh Configure \
    -de \
    -Dprefix=/usr \
    -Doptimize="-O3 -pipe -fstack-protector -fno-strict-aliasing"   \
&& make -j8 \
&& make install
RUN cd autoconf-2* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-a* && ./configure --prefix=/usr && make -j8 && make install
RUN cd automake-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpfr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpc-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gmp-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd pcre2-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd attr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd texinfo-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd bison-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gawk-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd groff-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd ncurses-* \
&& ./configure \
    --prefix=/usr \
    --with-shared \
    --without-normal \
    --with-cxx-shared \
    --without-debug \
    --disable-stripping \
    --enable-widec \
&& make -j8 \
&& make install
RUN cd gettext-* \
&& ./configure --prefix=/usr --disable-curses \
&& make -j8 \
&& make install

# RUN adduser --system perl

# FROM scratch AS base-part2

# COPY --from=base-part1 / /

# WORKDIR /build

# CMD bash

# Gcc final options
    # --enable-ada \        # Enable ADA
    # --enable-lto \        # Link Time Optimization
    # --enable-objc-gc \    # Garbage collection
    # --enable-gold \       # Go? not sure about this