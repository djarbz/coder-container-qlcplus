FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

USER root
COPY qlcplus.deb /tmp/qlcplus.deb
RUN dpkg -i /tmp/qlcplus.deb && rm -f /tmp/qlcplus.deb

USER coder