FROM python:3.12-slim

LABEL org.opencontainers.image.title="freemuxlet-prep"
LABEL org.opencontainers.image.description="Docker image for preparing data for freemuxlet"
LABEL org.opencontainers.image.version="1.0"
LABEL org.opencontainers.image.authors="ebishop@fredhutch.org"
LABEL org.opencontainers.image.source=https://github.com/emjbishop/freemuxlet-docker
LABEL org.opencontainers.image.licenses=MIT

# Set the shell option to fail if any command in a pipe fails
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Installing prerequisites
RUN apt-get update \
  && BE_VERSION=$(apt-cache policy build-essential | grep Candidate | awk '{print $2}') \
  && WGET_VERSION=$(apt-cache policy wget | grep Candidate | awk '{print $2}') \
  && ZLIB1G_VERSION=$(apt-cache policy zlib1g-dev | grep Candidate | awk '{print $2}') \
  && AUTOCONF_VERSION=$(apt-cache policy autoconf | grep Candidate | awk '{print $2}') \
  && AUTOMAKE_VERSION=$(apt-cache policy automake | grep Candidate | awk '{print $2}') \
  && LIBNCURSES_VERSION=$(apt-cache policy libncurses-dev | grep Candidate | awk '{print $2}') \
  && LIBBZ2_VERSION=$(apt-cache policy libbz2-dev | grep Candidate | awk '{print $2}') \
  && LIBLZMA_VERSION=$(apt-cache policy liblzma-dev | grep Candidate | awk '{print $2}') \
  && LIBSSL_VERSION=$(apt-cache policy libssl-dev | grep Candidate | awk '{print $2}') \
  && LIBCURL4_VERSION=$(apt-cache policy libcurl4-gnutls-dev | grep Candidate | awk '{print $2}') \
  && CERT_VERSION=$(apt-cache policy ca-certificates | grep Candidate | awk '{print $2}') \
  && apt-get install -y --no-install-recommends \
  build-essential="${BE_VERSION}" \
  wget="${WGET_VERSION}" \
  zlib1g-dev="${ZLIB1G_VERSION}" \
  autoconf="${AUTOCONF_VERSION}" \
  automake="${AUTOMAKE_VERSION}" \
  libncurses-dev="${LIBNCURSES_VERSION}" \
  libbz2-dev="${LIBBZ2_VERSION}" \
  liblzma-dev="${LIBLZMA_VERSION}" \
  libssl-dev="${LIBSSL_VERSION}" \
  libcurl4-gnutls-dev="${LIBCURL4_VERSION}" \
  ca-certificates="${CERT_VERSION}" \
  && rm -rf /var/lib/apt/lists/*

# Install htslib (for bgzip)
RUN wget -q --no-check-certificate https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2 && tar -xvf htslib-1.20.tar.bz2
WORKDIR /htslib-1.20
RUN ./configure && make && make install
WORKDIR /
RUN ldconfig
RUN rm -rf htslib-1.20.tar.bz2

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