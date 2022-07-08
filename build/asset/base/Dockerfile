FROM perlbase:prebase AS base-part1

RUN mkdir -p /build

WORKDIR /build

# Add in source directories for all required files
# Script created
# ADD obj/gcc-* /build/
# ADD obj/automake-* /build/
# ADD obj/autoconf-* /build/
# # Stage specific
# ADD src/packed/gmp-* /build/
# ADD src/packed/mpc-* /build/
# ADD src/packed/make-* /build/
ADD obj/* /build/

# Copy required files into the gcc source directory
RUN mv gcc-* gcc \
&& cp -R gmp-* gcc/gmp \
&& cp -R mpfr-* gcc/mpfr \
&& cp -R gmp-* gcc/gmp

RUN cd make-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd automake-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-2* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-a* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpfr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpc-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gmp-* && ./configure --prefix=/usr && make -j8 && make install

RUN cd gcc \
&& ./configure --prefix=/usr --disable-multilib \
&& make -j8 \
&& make install

RUN rm -Rf /build/* /etc/ld.so.conf.d/x86_64-linux-gnu.conf

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

RUN adduser --system perl

FROM scratch AS base-part2

COPY --from=base-part1 / /

WORKDIR /build

CMD bash
