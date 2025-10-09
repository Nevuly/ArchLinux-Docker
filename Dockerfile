FROM debian:sid AS bootstrap

ARG TARGETARCH
ARG PACKAGE_GROUP=base

# Create Arch Linux rootfs directory
RUN mkdir -p /rootfs

# Copy customized pacstrap script to root directory
COPY pacstrap-docker /

# Copy customized rootfs files to rootfs directory
COPY rootfs/any /rootfs
COPY rootfs/${TARGETARCH} /rootfs

# Set build environment and generate Arch Linux rootfs image
RUN \
    apt update && \
    apt install -y --no-install-recommends arch-install-scripts pacman-package-manager makepkg curl ca-certificates xz-utils zstd && \
    cp -rf /rootfs/etc/pacman.conf /etc/pacman.conf && \
    sed -i "s/^CheckSpace/#CheckSpace/" /etc/pacman.conf && \
    mkdir -p /etc/pacman.d && \
    cp -rf /rootfs/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist && \
    if case "$TARGETARCH" in arm*) true;; *) false;; esac; then \
        sed -i 's/\$arch/'aarch64'/g' /etc/pacman.d/mirrorlist; \
    fi && \
    BOOTSTRAP_EXTRA_PACKAGES="" && \
    if case "$TARGETARCH" in arm*) true;; *) false;; esac; then \
        EXTRA_KEYRING_FILES=" \
            archlinuxarm-revoked \
            archlinuxarm-trusted \
            archlinuxarm.gpg \
        " && \
        EXTRA_KEYRING_URL="https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/master/core/archlinuxarm-keyring/" && \
        for EXTRA_KEYRING_FILE in $EXTRA_KEYRING_FILES; do \
            curl "$EXTRA_KEYRING_URL$EXTRA_KEYRING_FILE" -o /usr/share/keyrings/$EXTRA_KEYRING_FILE -L; \
        done && \
        BOOTSTRAP_EXTRA_PACKAGES="archlinuxarm-keyring"; \
    else \
        mkdir /tmp/archlinux-keyring && \
        curl -L https://archlinux.org/packages/core/any/archlinux-keyring/download/ | unzstd | tar -C /tmp/archlinux-keyring -xv && \
        mv /tmp/archlinux-keyring/usr/share/pacman/keyrings/* /usr/share/keyrings/; \
    fi && \
    pacman-key --init && \
    pacman-key --populate && \
    ./pacstrap-docker /rootfs $PACKAGE_GROUP $BOOTSTRAP_EXTRA_PACKAGES && \
    rm /rootfs/var/lib/pacman/sync/*

FROM scratch

COPY --from=bootstrap /rootfs /

ENV LANG=en_US.UTF-8
RUN locale-gen

RUN \
    ln -sf /usr/lib/os-release /etc/os-release && \
    pacman-key --init && \
    pacman-key --populate && \
    bash -c "rm -rf etc/pacman.d/gnupg/{openpgp-revocs.d/,private-keys-v1.d/,pubring.gpg~,gnupg.S.}*"

CMD ["/usr/bin/bash"]
