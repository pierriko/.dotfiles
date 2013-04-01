#################################################
#
# https://github.com/pierriko/.dotfiles
#
#################################################

#### robotpkg setup
export ROBOTPKG_BASE=$HOME/openrobots
export PKG_CONFIG_PATH=$HOME/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:$HOME/openrobots/lib/python2.7/site-packages
export PATH=$PATH:$HOME/openrobots/sbin:$HOME/openrobots/bin
#### end robotpkg setup


#### setup devel
export PKG_CONFIG_PATH=$HOME/devel/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:$HOME/devel/lib/python3.3/dist-packages
export PATH=$PATH:$HOME/devel/bin:$HOME/devel/usr/bin
#### end setup devel

# workaround HRI-SIM module "mocap" conflicts with another in Blender
export PYTHONPATH=$ROBOTPKG_BASE/share/modules/python:$PYTHONPATH

# Python CLI completion and history
export PYTHONSTARTUP=~/.pyrc


# Cool Terminal prompt
_BOLD_ON=`tput bold`
_BOLD_OFF=`tput sgr0`
__last_err() {
    [[ "$?" != "0" ]] && echo -ne "\e[1;31m!\e[0m"
}
export PS1="╭─\u@\h:\w \$(__last_err)\${_BOLD_ON}\$(__git_ps1)\${_BOLD_OFF}\n╰─➤ "


# history search
hgrep() {
    grep $* ~/.bash_history
}
# repository search
alias ggrep='grep --exclude-dir=".git" --exclude-dir="build" -rF'
# screencast
alias scast='recordmydesktop --v_bitrate 5000000 --full-shots --fps 10 --no-sound --windowid $(xwininfo | grep "Window id:" | sed -e "s/xwininfo\:\ Window id:\ // ;s/\ .*//")'
# stupid web server takes port as first argument (default 8000)
alias webz='python -m SimpleHTTPServer'
# open stuff (mainly urls)
alias open='xdg-open'
# use like: cat myfile.txt | clipboard
alias clipboard='xclip -sel clip'
# well...
alias steam="~/media/Steam/steam.sh"
# <3 ViM but still sometimes... Sublime Text 2
alias sublime=~/sandbox/sublimetext2/sublime_text
# edit this file
alias vialiases="vim ~/.bash_aliases"
# mostly useless
alias backupdebs="cp -vu /var/cache/apt/archives/*.deb ~/backup/debs/"
# rsync dotfiles for git push
alias dotsync="rsync -av ~/.bash_aliases ~/.gitconfig ~/.inputrc ~/.pyrc ~/.dotfiles/"
# pdf to img
alias pdf2img="convert -density 600 -scale 4000x4000"
# VLC play webcam with v4l2
alias camview="vlc v4l2:///dev/video0"
# video encoding
videnc() {
    avconv -i $1 -s hd720 -b 5000k -an $1.avi
}

# build MORSE and install in ~/devel
alias cmorse="(cd ~/work/morse/ && rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/devel -DPYMORSE_SUPPORT=ON \
    -DPYTHON_EXECUTABLE=~/devel/bin/python3.3 \
    -DBUILD_POCOLIBS_SUPPORT=ON -DBUILD_ROS_SUPPORT=ON .. && make install)"

# Colorize MORSE :-)
alias morse="env LD_LIBRARY_PATH=${ROBOTPKG_BASE}/lib morse -c"

# Blender from http://download.blender.org/release/Blender2.65/
export MORSE_BLENDER=$HOME/work/blender-2.65a-linux-glibc211-x86_64/blender
alias blender=$MORSE_BLENDER

export MORSE_RESOURCE_PATH=${HOME}/work/action/morse-action


# ROS setup
#source ~/work/ros-addons/setup.bash
#source /opt/ros/groovy/setup.bash
#source /opt/ros/fuerte/setup.bash


###########################################
# MORSE rebase current dev branches HOWTO #
###########################################
# list="master feature-fullscreen velodyne-depth feature-socket-vw-pyside"
# for branch in $list; do git checkout $branch; git rebase laas/master; done; git checkout master; git push origin $list -f
###########################################

