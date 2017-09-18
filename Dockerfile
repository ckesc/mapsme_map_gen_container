FROM debian:jessie
LABEL maintainer="iamckesc@gmail.com"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    git \
    libssl-dev \
    clang \
    libc++-dev \
    libglu1-mesa-dev \
    libstdc++-4.8-dev \
    qt5-default \
    cmake \
    libboost-all-dev \
    mesa-utils \
    libtbb2 \
    libtbb-dev \
    libluabind-dev \
    libluabind0.9.1 \
    lua5.1 \
    osmpbf-bin \
    libprotobuf-dev \
    libstxxl-dev \
    libxml2-dev \
    libsparsehash-dev \
    libbz2-dev \
    zlib1g-dev \
    libzip-dev \    
    liblua5.1-0-dev \
    pkg-config \
    libgdal-dev \
    libexpat1-dev \
    libosmpbf-dev

ENV REPOSITORY_USER=mapsme \
    REPOSITORY_NAME=omim \
    REPOSITORY=https://github.com/mapsme/omim \
    DIR=/srv
   
WORKDIR $DIR

# Prevent caching git repository
ADD https://api.github.com/repos/$REPOSITORY_USER/$REPOSITORY_NAME/git/refs/heads/master version.json

RUN git clone --depth=1 --recursive $REPOSITORY
RUN cd omim && \
    echo | ./configure.sh && \
    cd ../
RUN CONFIG=gtool omim/tools/unix/build_omim.sh -cro

# Patch gen tool
ADD fix_mwm_gen.patch fix_mwm_gen.patch
RUN cd omim && \
    git apply ../fix_mwm_gen.patch && \
    cd ..

RUN mkdir data
VOLUME data/

WORKDIR $DIR/data

ENTRYPOINT ["../omim/tools/unix/generate_mwm.sh"] 
CMD ["--help"]
# CMD ["/bin/bash"]
