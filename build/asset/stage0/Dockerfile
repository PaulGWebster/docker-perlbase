FROM perlbase:base AS stage0-part1

RUN echo "Test"
ADD obj/* /build/

# Gcc final options
    # --enable-ada \        # Enable ADA
    # --enable-lto \        # Link Time Optimization
    # --enable-objc-gc \    # Garbage collection
    # --enable-gold \       # Go? not sure about this

RUN cd pcre2-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gettext-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd attr-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd ncurses-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd perl-* && sh Configure \
    -de \
    -Dprefix=/usr \
    -Doptimize="-O3 -pipe -fstack-protector -fno-strict-aliasing"   \
&& make -j8 \
&& make install
RUN cd m4-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd texinfo-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd bison-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd gawk-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd groff-* && ./configure --prefix=/usr && make -j8 && make install

FROM stage0-part1 AS stage0-part2

ADD obj/* /build/

# Déja vu
RUN cd autoconf-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd automake-* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-2* && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-a* && ./configure --prefix=/usr && make -j8 && make install

# Recompile gcc now ld is not pointing towards the old gcc sources
RUN mv gcc-* gcc \
&& cp -R gmp-* gcc/gmp \
&& cp -R mpfr-* gcc/mpfr \
&& cp -R gmp-* gcc/gmp

RUN cd gcc \
&& ./configure --prefix=/usr --disable-multilib \
&& make -j8 \
&& make install

# Absolutely clean GCC
RUN cd make-* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd automake-* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-2* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd autoconf-a* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpfr-* && make clean && ./configure --prefix=/usr && make -j8 && make install
RUN cd mpc-* && make clean &&./configure --prefix=/usr && make -j8 && make install
RUN cd gmp-* && make clean && ./configure --prefix=/usr && make -j8 && make install
