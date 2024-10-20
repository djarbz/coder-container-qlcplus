FROM codercom/enterprise-desktop:ubuntu
ARG QLC_VERSION="4.13.1"
ENV QLC_VERSION=$QLC_VERSION

ARG BUILD="dev"
ENV BUILD=$BUILD

ARG REPO_VERSION="23.04"
ENV REPO_VERSION=$REPO_VERSION

# Only set as arg so that it is only set during the build process
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir $HOME/Desktop

USER root

# Create desktop icons
# Create the QLC+ Fixture Editor desktop entry
RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=QLC+ Fixture Editor\n\
Comment=\n\
Exec=qlcplus-fixtureeditor --open %f\n\
Icon=qlcplus-fixtureeditor\n\
Path=\n\
Terminal=false\n\
StartupNotify=false" > /home/coder/Desktop/QLC+\ Fixture\ Editor.desktop

# Create the Q Light Controller Plus desktop entry
RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Q Light Controller Plus\n\
Comment=\n\
Exec=qlcplus --debug --fullscreen --log --web --open %f\n\
Icon=qlcplus\n\
Path=\n\
Terminal=false\n\
StartupNotify=false" > /home/coder/Desktop/Q\ Light\ Controller\ Plus.desktop

# Set appropriate permissions for the desktop files
RUN chmod +x /home/coder/Desktop/*.desktop

# Update package cache
RUN apt-get update

RUN apt-get install -o Dpkg::Progress-Fancy="0" -yqq --no-install-recommends gnupg
RUN echo "deb http://download.opensuse.org/repositories/home:/mcallegari79/xUbuntu_${REPO_VERSION}/ /" | tee /etc/apt/sources.list.d/home:mcallegari79.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:mcallegari79/xUbuntu_${REPO_VERSION}/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_mcallegari79.gpg > /dev/null

# Update package cache
RUN apt-get update

# Install and configure locales
RUN apt-get install -o Dpkg::Progress-Fancy="0" -yqq --no-install-recommends locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set the locale environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Resolve error [debconf: delaying package configuration, since apt-utils is not installed]
RUN apt-get install -o Dpkg::Progress-Fancy="0" -yqq --no-install-recommends apt-utils

# Install QLCPlus
RUN apt-get install -o Dpkg::Progress-Fancy="0" -yqq --no-install-recommends qlcplus-qt5

# Cleanup
RUN apt-get remove -y --purge gnupg
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

USER coder