FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

ARG REPO_VERSION="23.04"
ENV REPO_VERSION=$REPO_VERSION

# Only set as arg so that it is only set during the build process
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Update package cache
RUN apt-get update

RUN apt-get -qq install -y --no-install-recommends gnupg
RUN echo "deb http://download.opensuse.org/repositories/home:/mcallegari79/xUbuntu_${REPO_VERSION}/ /" | tee /etc/apt/sources.list.d/home:mcallegari79.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:mcallegari79/xUbuntu_${REPO_VERSION}/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_mcallegari79.gpg > /dev/null

# Update package cache
RUN apt-get update

# Install and configure locales
RUN apt-get -qq install -y --no-install-recommends locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set the locale environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Resolve error [debconf: delaying package configuration, since apt-utils is not installed]
RUN apt-get -qq install -y --no-install-recommends apt-utils

# Install QLCPlus
RUN apt-get -qq install -y --no-install-recommends qlcplus-qt5

# Cleanup
RUN apt-get remove -y --purge gnupg
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

USER coder