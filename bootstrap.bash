#!/bin/bash

echo "Bootstrap"

echo "Set bash as default login shell"
usermod -s /bin/bash $(whoami)
DOTFILES=".bash_aliases .gitconfig .inputrc .pyrc"

echo "Backup dotfiles: $DOTFILES"
DATE_BAK=$(date +%s)
for dotfile in $DOTFILES; do
    [[ -f ~/${dotfile} ]] && mv ~/${dotfile} ~/backup/bak.${DATE_BAK}${dotfile}
done

echo "Copy dotfiles to HOME"
cd ~/.dotfiles # git clone git://github.com/pierriko/.dotfiles.git ~/.dotfiles
cp $DOTFILES ~

echo "Done!"

cd
echo "Make home folders"
mkdir work devel openrobots sandbox backup tmp

[[ "$?" != "0" ]] && echo "Looks like you're already setup" && exit 1

echo "Get LAAS-CNRS software manager"
git clone git://git.openrobots.org/robots/robotpkg
cd robotpkg
git clone git://git.openrobots.org/robots/robotpkg-wip wip
cd bootstrap
./bootstrap --prefix=${HOME}/openrobots

echo "Install ROS on $(lsb_release -cs)"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install \
    ros-groovy-desktop-full ros-fuerte-desktop-full ros-hydro-ros-comm \
    python-rosinstall git-svn python3-dev python3-yaml libpcap-dev libxp-dev \
    pax texinfo bwidget libgsl0-dev glpk libgts-dev libftdi-dev libeigen2-dev \
    gnome-panel curl libgl1-mesa-dri libc6 xclip traceroute \
    nmap recordmydesktop vlc jockey-common inkscape nautilus-open-terminal zsh \
    ruby-dev vim-nox python-fontforge \
    ros-fuerte-orocos-toolchain ros-fuerte-rtt-* \
    ros-groovy-octomap* ros-fuerte-octo*

sudo rosdep init
rosdep update

echo "Setup ViM"
git clone git://github.com/pierriko/.vim.git ~/.vim
~/.vim/.install.bash

cd ~/work/
[[ -d morse ]] && echo "MORSE already cloned" && exit 1

echo "Get Python 3.3 and Blender 2.6x"

(wget http://python.org/ftp/python/3.3.0/Python-3.3.0.tar.bz2;
tar jxf Python-3.3.0.tar.bz2) & pypid=$!

[[ -z "$(uname -p | grep 64)" ]] && arch="i686" || arch="x86_64"

# get 2.65 (Python 3.3)
BLENDER="blender-2.65a-linux-glibc211-$arch"
(wget -q http://download.blender.org/release/Blender2.65/${BLENDER}.tar.bz2;
tar jxf ${BLENDER}.tar.bz2) &

# get 2.64 (Python 3.2)
BLENDER="blender-2.64a-linux-glibc27-$arch"
(wget -q http://download.blender.org/release/Blender2.64/${BLENDER}.tar.bz2;
tar jxf ${BLENDER}.tar.bz2) &

echo "Get MORSE"
git clone git://trac.laas.fr/robots/morse

echo "Install Python 3.3 in ~/devel"
wait $pypid
cd Python-3.3.0/
./configure prefix=${HOME}/devel
make install

#git clone git://github.com/OctoMap/octomap.git
#git clone git://github.com/OSGeo/gdal.git
#git clone git://github.com/PointCloudLibrary/pcl.git
#svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/blender blender-svn
#cd blender-svn && export PS1="$ " && python scons/scons.py -j 2

# other stuff
#sudo apt-get install libgl1-mesa-glx nvidia-experimental-310-dev libc6:i386

#echo "Setup Flash for Firefox http://get.adobe.com/flashplayer/"
#xdg-open "apt:adobe-flashplugin?channel=$(lsb_release -cs)-partner"
#cd ~/tmp
#wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.275/install_flash_player_11_linux.x86_64.tar.gz
#tar xf install_flash_player_11_linux.x86_64.tar.gz libflashplayer.so
#mkdir -p ~/.mozilla/plugins/
#mv libflashplayer.so ~/.mozilla/plugins/

