#################################################
#
# https://github.com/pierriko/.dotfiles
#
#################################################

# enable core dump (check for apport pipe!)
# cat /proc/sys/kernel/core_pattern
ulimit -S -c unlimited
alias ulimit='ulimit -S'

#### robotpkg setup
export ROBOTPKG_BASE=${HOME}/openrobots
export PKG_CONFIG_PATH=${ROBOTPKG_BASE}/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:${ROBOTPKG_BASE}/lib/python3.4/site-packages:${ROBOTPKG_BASE}/lib/python2.7/site-packages:${ROBOTPKG_BASE}/lib/python3.3/site-packages
export PATH=$PATH:${ROBOTPKG_BASE}/sbin:${ROBOTPKG_BASE}/bin
#### end robotpkg setup

export ACTION_HOME=${HOME}/work/action
alias source_ros_action='source ${ACTION_HOME}/action_ros_ws/devel/setup.bash'

#### setup devel
export DEVEL_BASE=${HOME}/devel
export PKG_CONFIG_PATH=$DEVEL_BASE/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:$DEVEL_BASE/lib/python3/dist-packages
export PATH=$DEVEL_BASE/bin:$DEVEL_BASE/usr/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DEVEL_BASE/lib
#### end setup devel

export TCLSERV_MODULE_PATH=${DEVEL_BASE}/lib/tclserv:${ROBOTPKG_BASE}/lib/tclserv

# workaround HRI-SIM module "mocap" conflicts with another in Blender
export PYTHONPATH=$ROBOTPKG_BASE/share/modules/python:$PYTHONPATH

# Python CLI completion and history
export PYTHONSTARTUP=~/.pyrc


# Cool Terminal prompt
_BOLD_ON=`tput bold`
_BOLD_OFF=`tput sgr0`
__last_err() {
    [[ "$?" != "0" ]] && echo -ne "\e[1;31m!\e[0m "
}
export PS1="╭─\u@\h:\w \$(__last_err)[\$(date +%T)]\${_BOLD_ON}\$(__git_ps1)\${_BOLD_OFF}\n╰─➤ "


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
_sublime() {
    nohup ~/sandbox/sublimetext2/sublime_text $@ &> /dev/null &
}
alias sublime=_sublime
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
    # use -ss offset -t duration
    avconv -i $1 -s hd720 -b 5000k -an -c:v libx264 $1.x264.avi
}

# android debug tool
alias adb="~/sandbox/android-sdk-linux/platform-tools/adb"
# clear screen
alias cls='for i in `seq 200`; do echo; done'


# build atlaas
alias catlaas="(cd ~/work/atlaas && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$DEVEL_BASE .. && \
    make -j8 && make install)"
# build gladys
alias cgladys="(cd ~/work/gladys && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$DEVEL_BASE .. && \
    make -j8 && make test && make install)"
# build gdalwrap
alias cgdalwrap="(cd ~/work/gdalwrap && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$DEVEL_BASE .. && \
    make -j8 && make install)"
# build clara
alias cclara="(cd ~/work/clara && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$DEVEL_BASE .. && \
    make -j8 && make install)"

alias atlaas_merge="gdal_merge.py -co \"COMPRESS=DEFLATE\" atlaas.*x*.tif && \
    gdaldem hillshade -b 4 out.tif -of PNG out.hillshade.png && \
    open out.hillshade.png"

# build MORSE and install in ~/devel
alias cmorse="(cd ~/work/morse/ && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$DEVEL_BASE -DPYMORSE_SUPPORT=ON \
    -DPYTHON_EXECUTABLE=`which python3.4` -DBUILD_YARP2_SUPPORT=ON \
    -DBUILD_POCOLIBS_STEREOPIXEL_SUPPORT=ON -DBUILD_POCOLIBS_VIAM_SUPPORT=ON \
    -DBUILD_POCOLIBS_VELODYNE_SUPPORT=ON \
    -DBUILD_POCOLIBS_SUPPORT=ON -DBUILD_ROS_SUPPORT=ON .. && make install)"

# Colorize MORSE :-)
alias morse="env LD_LIBRARY_PATH=${HOME}/devel/lib:${ROBOTPKG_BASE}/lib morse -c"
# bad but for make test to find libpython3.3m.so.1.0
export LD_LIBRARY_PATH=${HOME}/devel/lib:${HOME}/devel/lib/python3.3

# Blender from http://download.blender.org/release
export MORSE_BLENDER=${DEVEL_BASE}/bin/blender
alias blender=$MORSE_BLENDER

export MORSE_RESOURCE_PATH=${HOME}/work/action/morse-action

# for FindGDAL.cmake
export GDAL_ROOT=$DEVEL_BASE
export BOOST_ROOT=${ROBOTPKG_BASE}
# blender build
alias cblender='PS1="$ "; python scons/scons.py BF_PYTHON=`python3.3-config --prefix` -j8'
alias gsdview=~/sandbox/gsdview/run.py

alias wacum="wget --mirror --no-check-certificate --no-parent --no-host-directories --execute robots=off --reject 'index.html*' --timestamping"

# ROS setup
#source ~/work/ros-addons/setup.bash
#source /opt/ros/groovy/setup.bash
#source /opt/ros/fuerte/setup.bash

#export PYTHONPATH=$PYTHONPATH:$DEVEL_BASE/lib/python2.7/dist-packages
# cd gdal/gdal/swig/python/
# python setup.py install --install-lib=$DEVEL_BASE/lib/python2.7/dist-packages

###########################################
# MORSE rebase current dev branches HOWTO #
###########################################
# list="master feature-socket-vw-pyside feature-kinect2 feature-allpy"
# for branch in $list; do git checkout $branch; git rebase laas/master; done; git checkout master; git push origin $list -f
###########################################

alias rm="mv -b -S .\$(date +%s) -t ~/.nofutur"
alias update="sudo apt-get update ; sudo apt-get -y upgrade ; update-manager & alert"

# Run tmux if SSH
[[ -z "$TMUX" && -n "$SSH_CONNECTION" ]] && which tmux >& /dev/null && tmux

# rsync morse doc from `morse/build` after `make doc`
# rsync -r doc/html/* trac:/var/www/html/openrobots/morse/doc/latest

##
# golang stuff
export GOPATH=${HOME}/sandbox/gotmp
export GOROOT=${HOME}/devel/go
export PATH=${PATH}:${GOROOT}/bin

##
# hyper stuff
export HYPER_ROOT=${ROBOTPKG_BASE}
export HYPER_ROOT_ADDR="127.0.0.1:4242"

##
# orocos-ocl rttlua-gnulinux
export LUA_PATH="?;?.lua;$ROBOTPKG_BASE/lib/lua/rfsm/?.lua;$ROBOTPKG_BASE/share/lua/5.1/?.lua;/usr/share/lua/5.1/?.lua;/usr/lib/lua/5.1/?.lua"

## Set Touchpad sensitivity
# https://wiki.archlinux.org/index.php/Touchpad_Synaptics
# https://help.ubuntu.com/community/SynapticsTouchpad
# http://www.x.org/archive/X11R7.5/doc/man/man4/synaptics.4.html
# 3 values, low, high, press.
# xinput --set-prop 13 "Synaptics Finger" 20 30 100


# usage json_ppp < in.json > out.json
alias json_ppp="python -c'import sys,json;json.dump(json.load(sys.stdin),sys.stdout,indent=1)'"

# action genom picoweb morse
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROBOTPKG_BASE}/lib


