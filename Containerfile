FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

USER root

# Install Dependancies
RUN apt-get update
RUN apt-get install -y --no-install-recommends desktop-file-utils shared-mime-info
RUN rm -rf /var/lib/apt/lists/*

# Install QLC Plus
COPY qlcplus.deb /tmp/qlcplus.deb
RUN dpkg -i /tmp/qlcplus.deb
# || apt-get -f install
RUN rm -f /tmp/qlcplus.deb

USER coder