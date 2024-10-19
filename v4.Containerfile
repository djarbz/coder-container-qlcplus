FROM codercom/enterprise-desktop:latest
ARG VERSION="4.13.1"
ENV VERSION=$VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

ARG REPO_VERSION="23.04"
ENV REPO_VERSION=$REPO_VERSION

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

# Install Dependancies
# RUN apt-get -qq install -y --no-install-recommends desktop-file-utils shared-mime-info
# RUN apt-get -qq install -y --no-install-recommends libasound2t64 libasound2-data
# RUN apt-get -qq install -y --no-install-recommends libfftw3-double3 libgomp1 gcc-14-base libgcc-s1 libstdc++6
# RUN apt-get -qq install -y --no-install-recommends libftdi1-2 libusb-1.0-0
# RUN apt-get -qq install -y --no-install-recommends libqt5core5t64 libdouble-conversion3 libpcre2-16-0
# RUN apt-get -qq install -y --no-install-recommends libqt5gui5t64 libdrm-amdgpu1 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libedit2 \
#     libegl-mesa0 libegl1 libevdev2 libgbm1 libgl1 libgl1-mesa-dri libglapi-mesa \
#     libglvnd0 libglx-mesa0 libglx0 libinput-bin libinput10 libllvm17t64 libmd4c0 \
#     libmtdev1t64 libpciaccess0 libqt5dbus5t64 libqt5network5t64 \
#     libvulkan1 libwacom-common libwacom9 libwayland-server0 libxcb-dri2-0 \
#     libxcb-dri3-0 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
#     libxcb-present0 libxcb-randr0 libxcb-render-util0 libxcb-shape0 libxcb-sync1 \
#     libxcb-xfixes0 libxcb-xinerama0 libxcb-xinput0 libxcb-xkb1 \
#     libxkbcommon-x11-0 libxshmfence1
# RUN apt-get -qq install -y --no-install-recommends libqt5gui5-gles
# RUN apt-get -qq install -y --no-install-recommends libqt5multimedia5
# RUN apt-get -qq install -y --no-install-recommends libqt5multimediawidgets5
# RUN apt-get -qq install -y --no-install-recommends libqt5network5t64
# RUN apt-get -qq install -y --no-install-recommends libqt5script5
# RUN apt-get -qq install -y --no-install-recommends libqt5serialport5
# RUN apt-get -qq install -y --no-install-recommends libqt5widgets5t64

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get remove -y --purge gnupg
RUN apt-get autoremove -y

# Install QLC Plus
# COPY qlcplus.deb /tmp/qlcplus.deb
# RUN dpkg -i /tmp/qlcplus.deb
# || apt-get -fqq install
# RUN rm -f /tmp/qlcplus.deb
RUN apt-get -qq install -y --no-install-recommends qlcplus-qt5

USER coder