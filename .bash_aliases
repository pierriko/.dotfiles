#! /bin/bash
#################################################
#
# https://github.com/pierriko/.dotfiles
#
#################################################

# enable core dump (check for apport pipe!)
# cat /proc/sys/kernel/core_pattern
ulimit -S -c unlimited

export HISTSIZE=1000123
export HISTFILESIZE=1000123
export ROS_HOSTNAME=localhost
# http://lists.science.uu.nl/pipermail/ipe-discuss/2014-November/001611.html
export LC_NUMERIC=C
export BOOST_ROOT=${ROBOTPKG_BASE}
# Blender from http://download.blender.org/release
export MORSE_BLENDER=${DEVEL_BASE}/bin/blender
alias blender=$MORSE_BLENDER

#### robotpkg setup
export ROBOTPKG_BASE=${HOME}/openrobots
export PKG_CONFIG_PATH=${ROBOTPKG_BASE}/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:${ROBOTPKG_BASE}/lib/python2.7/site-packages
export PATH=$PATH:${ROBOTPKG_BASE}/sbin:${ROBOTPKG_BASE}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROBOTPKG_BASE}/lib
#### end robotpkg setup

#### setup devel
export DEVEL_BASE=${HOME}/devel
export PKG_CONFIG_PATH=${DEVEL_BASE}/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$PYTHONPATH:${DEVEL_BASE}/lib/python2.7/site-packages
export PATH=${DEVEL_BASE}/bin:${DEVEL_BASE}/usr/bin:$PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${DEVEL_BASE}/lib
#### end setup devel

if [ -f ${DEVEL_BASE}/etc/ros/setup.bash ]; then
	. ${DEVEL_BASE}/etc/ros/setup.bash
elif [ -f ${ROBOTPKG_BASE}/etc/ros/setup.bash ]; then
	. ${ROBOTPKG_BASE}/etc/ros/setup.bash
fi

# Python CLI completion and history
export PYTHONSTARTUP=~/.pyrc

# Cool Terminal prompt
_BOLD_ON=`tput bold`
_BOLD_OFF=`tput sgr0`
__last_err() {
    [[ "$?" != "0" ]] && echo -ne "\e[1;31m!\e[0m "
}
source /usr/share/git-core/contrib/completion/git-prompt.sh
export PS1="╭─\u@\h:\w \$(__last_err)[\$(date +%T)]\${_BOLD_ON}\$(__git_ps1)\${_BOLD_OFF}\n╰─➤ "


# video encoding
videnc() {
    # use -ss offset -t duration
    avconv -i $1 -s hd720 -b 5000k -an -c:v libx264 $1.x264.avi
}
# history search
hgrep() {
    grep $* ~/.bash_history
}

alias ulimit='ulimit -S'
alias ls='ls --color=auto'
alias ll='ls -al'
alias l='ls'

# screencast
alias scast='recordmydesktop --v_bitrate 5000000 --full-shots --fps 10 --no-sound --windowid $(xwininfo | grep "Window id:" | sed -e "s/xwininfo\:\ Window id:\ // ;s/\ .*//")'
# stupid web server takes port as first argument (default 8000)
alias webz='python -m SimpleHTTPServer'
# open stuff (mainly urls)
alias open='xdg-open'
# use like: cat myfile.txt | clipboard
alias clipboard='xclip -sel clip'
# edit this file
alias vialiases="vim ~/.bash_aliases"
# rsync dotfiles for git push
alias dotsync="rsync -av ~/.bash_aliases ~/.gitconfig ~/.inputrc ~/.pyrc ~/.dotfiles/"
# pdf to img
alias pdf2img="convert -density 600 -scale 4000x4000"
# VLC play webcam with v4l2
alias camview="vlc v4l2:///dev/video0"
alias subup='git submodule sync && git submodule update --init --recursive'
# clear screen
alias cls='for i in `seq 200`; do echo; done'

# build atlaas
alias catlaas="(cd ~/work/atlaas && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${DEVEL_BASE} .. && \
    make -j8 && make install)"
# build gdalwrap
alias cgdalwrap="(cd ~/work/gdalwrap && /bin/rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${DEVEL_BASE} .. && \
    make -j8 && make install)"

alias atlaas_merge="gdal_merge.py -co \"COMPRESS=DEFLATE\" atlaas.*x*.tif && \
    gdaldem hillshade -b 4 out.tif -of PNG out.hillshade.png && \
    open out.hillshade.png"

# build MORSE and install in ~/devel
alias cmorse="(cd ~/work/morse/ && /bin/rm -rf build && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=${DEVEL_BASE} \
    -DPYTHON_EXECUTABLE=`which python3.5` .. && make install)"

# Colorize MORSE :-)
alias morse="env LD_LIBRARY_PATH=${HOME}/devel/lib:${ROBOTPKG_BASE}/lib morse -c"

alias wacum="wget --mirror --no-check-certificate --no-parent --no-host-directories --execute robots=off --reject 'index.html*' --timestamping"

alias rm="mv -b -S .\$(date +%s) -t ~/.nofutur"

# usage json_ppp < in.json > out.json
alias json_ppp="python -c'import sys,json;json.dump(json.load(sys.stdin),sys.stdout,indent=1)'"

alias run_jupyter="cd ~/work/virtualenv-15.0.3/pyvenv; \
    source bin/activate; cd data; xdg-open https://localhost:8888; \
    jupyter notebook --certfile=mycert.pem --no-browser --ip='*'"

# fix pcl tools R ldd
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib64/R/lib
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/usr/include/qt5/QtQuick/5.6.2/QtQuick

#
