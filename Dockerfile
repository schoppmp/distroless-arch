# Download and extract latest glibc
FROM archlinux/base AS base
RUN pacman -Sy --noconfirm wget tar
RUN wget -O glibc.tar.xz https://www.archlinux.org/packages/core/x86_64/glibc/download/ && tar xf glibc.tar.xz

# Copy extracted files to distroless image
FROM gcr.io/distroless/cc
COPY --from=base usr /usr
COPY --from=base var /var
COPY --from=base lib /lib
