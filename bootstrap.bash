#!/bin/bash
echo "Bootstrap 2017 Fedora 25 x64"

list="biber fontforge-devel gdal-devel gdal-python gimp git-svn htop nmap \
opencv-devel opencv-python pcl-devel pcl-tools python-devel python-requests \
recordmydesktop rubber ruby-devel terminator texlive-alg texlive-algorithm2e \
texlive-algorithmicx texlive-minitoc texlive-minted texlive-multirow \
texlive-nomencl texlive-pgfplots texlive-shadowtext texlive-standalone \
texlive-subfigure texlive-tablefootnote texlive-textpos texlive-todonotes vim"

sudo dnf update --refresh
sudo dnf install $list
