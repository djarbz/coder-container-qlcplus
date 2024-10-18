FROM scratch as resources
ADD qlcplus.deb /qlcplus.deb

FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

USER root
RUN --mount=type=bind,from=resources,source=/qlcplus.deb,target=/tmp/qlcplus.deb dpkg -i /tmp/qlcplus.deb

USER coder