#!/bin/bash
echo "Bootstrap 2017 Fedora 25 x64"

dep_latex="biber rubber texlive-alg texlive-algorithm2e texlive-algorithmicx \
texlive-framed texlive-minitoc texlive-minted texlive-multirow texlive-nomencl \
texlive-pgfplots texlive-shadowtext texlive-standalone texlive-subfigure \
texlive-tablefootnote texlive-textpos texlive-todonotes"

dep_work="fontforge-devel gdal-devel gdal-python gimp git-svn htop nmap \
opencv-devel opencv-python pcl-devel pcl-tools python-devel python-requests \
recordmydesktop ruby-devel terminator vim"

sudo dnf update --refresh
sudo dnf install $dep_work $dep_latex

# https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet
cd ~/.dotfiles
git clone git://github.com/paradoxxxzero/gnome-shell-system-monitor-applet.git
mkdir -p ~/.local/share/gnome-shell/extensions
cd ~/.local/share/gnome-shell/extensions
ln -s ~/.dotfiles/gnome-shell-system-monitor-applet/system-monitor@paradoxxx.zero.gmail.com
gnome-shell-extension-tool --enable-extension=system-monitor@paradoxxx.zero.gmail.com
