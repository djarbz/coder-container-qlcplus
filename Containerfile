FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

USER root

# Install Dependancies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    desktop-file-utils \
    shared-mime-info \
    libasound2t64 \
    libfftw3-double3 \
    libftdi1-2 \
    libqt5core5t64 \
    libqt5gui5 \
    libqt5gui5-gles \
    libqt5multimedia5 \
    libqt5multimediawidgets5 \
    libqt5network5t64 \
    libqt5script5 \
    libqt5serialport5 \
    libqt5widgets5t64 \
    libusb-1.0-0
RUN rm -rf /var/lib/apt/lists/*

# Install QLC Plus
COPY qlcplus.deb /tmp/qlcplus.deb
RUN dpkg -i /tmp/qlcplus.deb
# || apt-get -f install
RUN rm -f /tmp/qlcplus.deb

USER coder