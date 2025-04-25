# Use an official Ubuntu as a base image
FROM ubuntu:latest AS build

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    cmake \
    libncurses5-dev \
    libsdl2-image-dev \
    libsdl2-ttf-dev \
    pkg-config \
    meson \
    curl \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    libgtk-4-dev \
    qt6-base-dev \
    && apt-get clean

# Clone FreeCiv from the official repository
RUN git clone https://github.com/freeciv/freeciv

# Set working directory
RUN mkdir build
WORKDIR /build

# build
RUN meson setup ../freeciv -Daudio=none
RUN ninja

#================RUN====================
FROM ubuntu:latest AS run
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    curl \
    libncurses5-dev \
    libsqlite3-dev \
    && apt-get clean

COPY --from=build /build/freeciv-server /server/freeciv-server
COPY --from=build /build/libfreeciv.so /server/libfreeciv.so

CMD ["/server/freeciv-server"]
