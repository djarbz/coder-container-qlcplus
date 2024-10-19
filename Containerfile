FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

USER root

# Install Dependancies
RUN apt-get update
RUN apt-get install -y --no-install-recommends desktop-file-utils
RUN apt-get install -y --no-install-recommends shared-mime-info
RUN apt-get install -y --no-install-recommends libasound2t64
RUN apt-get install -y --no-install-recommends libfftw3-double3
RUN apt-get install -y --no-install-recommends libftdi1-2
RUN apt-get install -y --no-install-recommends libqt5core5t64
RUN apt-get install -y --no-install-recommends libqt5gui5
RUN apt-get install -y --no-install-recommends libqt5gui5-gles
RUN apt-get install -y --no-install-recommends libqt5multimedia5
RUN apt-get install -y --no-install-recommends libqt5multimediawidgets5
RUN apt-get install -y --no-install-recommends libqt5network5t64
RUN apt-get install -y --no-install-recommends libqt5script5
RUN apt-get install -y --no-install-recommends libqt5serialport5
RUN apt-get install -y --no-install-recommends libqt5widgets5t64
RUN apt-get install -y --no-install-recommends libusb-1.0-0
RUN rm -rf /var/lib/apt/lists/*

# Install QLC Plus
COPY qlcplus.deb /tmp/qlcplus.deb
RUN dpkg -i /tmp/qlcplus.deb
# || apt-get -f install
RUN rm -f /tmp/qlcplus.deb

USER coder