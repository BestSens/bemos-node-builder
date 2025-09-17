FROM fedora:42

RUN dnf install -y \
        git \
        curl \
        wcurl \
        g++ \
        gcc \
        make \
        patch \
        ninja-build \
        python3 \
        ccache \
        libgcc.i686 \
        libstdc++-devel \
        libstdc++-devel.i686 \
        libstdc++-static.i686 \
        glibc-devel \
        glibc-devel.i686 \
        glibc-static.i686 \
        libatomic-static.i686 && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ADD https://github.com/BestSens/musl-build-image/releases/download/v1.3.7/arm-bemos-linux-musleabihf_1.3.7.tar.gz /
ENV PATH="/opt/x-tools/arm-bemos-linux-musleabihf/bin:$PATH"

ENV CCACHE_DIR="/ccache"

COPY run.sh /work/run.sh
COPY fix_ninja_build.patch /work/fix_ninja_build.patch
RUN chmod +x /work/run.sh

VOLUME /ccache

ENTRYPOINT [ "/work/run.sh" ]