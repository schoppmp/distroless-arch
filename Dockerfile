# Download and extract latest glibc and gcc-libs from Arch
FROM archlinux/base AS base
RUN pacman -Sy --noconfirm wget tar
WORKDIR /download
RUN mkdir glibc gcc-libs openssl
RUN cd glibc && wget -O glibc.tar.xz https://www.archlinux.org/packages/core/x86_64/glibc/download/ && tar xf glibc.tar.xz
RUN cd gcc-libs && wget -O gcc-libs.tar.xz https://www.archlinux.org/packages/core/x86_64/gcc-libs/download/ && tar xf gcc-libs.tar.xz
RUN cd openssl && wget -O openssl.tar.xz https://www.archlinux.org/packages/core/x86_64/openssl/download/ && tar xf openssl.tar.xz

# Create directory structure and move libraries
WORKDIR /arch
RUN mv /download/glibc/* .
RUN cp -r /download/openssl/* .
RUN mv /download/gcc-libs/usr/lib/libstdc++.so* usr/lib
RUN mv /download/gcc-libs/usr/lib/libgomp.so* usr/lib
RUN mv /download/gcc-libs/usr/lib/libgcc_s.so* usr/lib
RUN rm -r usr/share/{i18n,info,locale,man} usr/include *.tar.xz
RUN ln -s usr/lib lib && ln -s usr/lib lib64

# Copy extracted files to distroless image
FROM gcr.io/distroless/static
COPY --from=base /arch /