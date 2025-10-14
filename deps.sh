#!/bin/bash
export R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/90local-no-recommends

apt-get update

if [[ ! -d "/usr/local/texlive" ]]; then
  apt-get install -y --no-install-recommends texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra fonts-lmodern
fi

# https://pat-s.me/using-ccache-to-speed-up-r-package-checks-on-travis-ci/
apt-get install -y --no-install-recommends ccache
apt-get install -y --no-install-recommends libdav1d5
apt-get install -y --no-install-recommends libgit2-dev wget python-is-python3 qpdf libmagick++-dev libcurl4-openssl-dev libssl-dev autoconf libde265-0 libmagick++-6-headers libfftw3-double3
apt-get install -y --no-install-recommends pandoc cmake
apt-get install -y --no-install-recommends pandoc-citeproc || true
apt-get install -y --no-install-recommends tidy
apt-get install -y --no-install-recommends openjdk-17-jdk-headless
apt-get install -y --no-install-recommends libv8-dev
apt-get install -y --no-install-recommends tk # for summarytools
apt-get install -y --no-install-recommends libudunits2-dev # for units
apt-get install -y --no-install-recommends libcurl4-openssl-dev libfontconfig1-dev libxml2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
apt-get install -y --no-install-recommends librsvg2-dev cmake
apt-get install -y --no-install-recommends default-jdk

apt-get install -y locales

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

export LANG=en_US.UTF-8

apt-get reinstall tzdata

R CMD javareconf
