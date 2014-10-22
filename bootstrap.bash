#!/bin/bash

echo "Bootstrap"

echo "Set bash as default login shell"
usermod -s /bin/bash $(whoami)
DOTFILES=".bash_aliases .gitconfig .inputrc .pyrc"

echo "Backup dotfiles: $DOTFILES"
mkdir -p ~/backup
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
mkdir work devel openrobots sandbox tmp

[[ "$?" != "0" ]] && echo "Looks like you're already setup" && exit 1

echo "Get LAAS-CNRS software manager"
git clone git://git.openrobots.org/robots/robotpkg
cd robotpkg
git clone git://git.openrobots.org/robots/robotpkg/robotpkg-wip wip
cd bootstrap
./bootstrap --prefix=${HOME}/openrobots

echo "Install ROS on $(lsb_release -cs)"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install \
    ros-hydro-ros-comm python-rosinstall \
    git-svn git-cvs python3-dev python3-yaml libpcap-dev libxp-dev \
    pax texinfo bwidget libgsl0-dev glpk libgts-dev libftdi-dev libeigen2-dev \
    gnome-panel curl libc6 xclip traceroute flex bison rubber \
    nmap recordmydesktop vlc inkscape gimp nautilus-open-terminal \
    ruby-dev vim-nox python-fontforge libflann-dev cmake-curses-gui \
    libncurses5-dev libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
    python3-numpy python-numpy bzr mercurial python-lxml xd python3-setuptools

sudo rosdep init
rosdep update

echo "Setup ViM"
git clone git://github.com/pierriko/.vim.git ~/.vim
~/.vim/.install.bash

[[ -d ~/work/morse ]] && echo "MORSE already cloned" && exit 1

[[ -z "$(uname -p | grep 64)" ]] && arch="i686" || arch="x86_64"

# get 2.72 (Python 3.4)
cd ~/tmp
BLENDER="blender-2.72b-linux-glibc211-$arch"
(wget -cq http://download.blender.org/release/Blender2.72/${BLENDER}.tar.bz2 &&
cd ~/work && tar jxf ~/tmp/${BLENDER}.tar.bz2 &&
ln -s ~/work/${BLENDER}/blender ~/devel/bin/) &

echo "Get MORSE"
cd ~/work
git clone git://trac.laas.fr/robots/morse

cd ~/tmp
git clone git://github.com/ros/rospkg.git
cd rospkg
python3 setup.py install

# install dvd css
#sudo apt-get install libdvdnav4 libdvdread4
#sudo /usr/share/doc/libdvdread4/install-css.sh
