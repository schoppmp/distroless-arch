# Download and install Arch packages
FROM archlinux/base AS base
RUN pacman -Sy --noconfirm pkgfile grep cpio glibc gcc-libs openssl

# Create directory structure and copy required libraries
WORKDIR /arch
RUN pkgfile --update
RUN pkgfile --list glibc | cut -f2 | cpio -pd /arch
RUN pkgfile --list openssl | cut -f2 | cpio -pd /arch
RUN pkgfile --list gcc-libs | cut -f2 | grep -E '(libstdc++|libgomp|libgcc)' | cpio -pd /arch
RUN rm -r usr/share/{i18n,info,locale,man} usr/include
RUN ln -s usr/lib lib && ln -s usr/lib lib64

# Copy extracted files to distroless image
FROM gcr.io/distroless/static
COPY --from=base /arch /