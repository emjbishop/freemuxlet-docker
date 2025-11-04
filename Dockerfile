FROM cumulusprod/popscle:2021.05

LABEL org.opencontainers.image.title="freemuxlet"
LABEL org.opencontainers.image.description="Image for preparing data for and running freemuxlet"
LABEL org.opencontainers.image.version="2.0"
LABEL org.opencontainers.image.authors="ebishop@fredhutch.org"
LABEL org.opencontainers.image.source=https://github.com/emjbishop/freemuxlet-docker
LABEL org.opencontainers.image.licenses=MIT

# Set the shell option to fail if any command in a pipe fails
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Fix Debian Buster repositories (EOL - now archived) and remove problematic Google Cloud SDK repo
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && sed -i '/buster-updates/d' /etc/apt/sources.list \
    && rm -f /etc/apt/sources.list.d/google-cloud-sdk.list

# Installing prerequisites
RUN apt-get update -o Acquire::Check-Valid-Until=false \
  && apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  zlib1g-dev \
  autoconf \
  automake \
  libncurses-dev \
  libbz2-dev \
  liblzma-dev \
  libssl-dev \
  libcurl4-gnutls-dev \
  ca-certificates \
&& rm -rf /var/lib/apt/lists/*

# Install samtools
RUN wget -q --no-check-certificate https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2 && tar -xvf samtools-1.20.tar.bz2
WORKDIR /samtools-1.20
RUN ./configure && make && make install
WORKDIR /
RUN rm -rf samtools-1.20.tar.bz2

# Install bcftools
RUN wget -q --no-check-certificate https://github.com/samtools/bcftools/releases/download/1.20/bcftools-1.20.tar.bz2 && tar -xvf bcftools-1.20.tar.bz2
WORKDIR /bcftools-1.20
RUN ./configure && make && make install
WORKDIR /
RUN rm -rf bcftools-1.20.tar.bz2

# Install bedtools
RUN wget -q --no-check-certificate https://github.com/arq5x/bedtools2/releases/download/v2.31.1/bedtools-2.31.1.tar.gz && tar -xvf bedtools-2.31.1.tar.gz
WORKDIR /bedtools2
RUN make && make install
WORKDIR /
RUN rm -rf bedtools-2.31.1.tar.gz

# Smoke tests to verify installations
RUN bgzip --version
RUN samtools --version
RUN bcftools --version
RUN bedtools --version
RUN popscle --help