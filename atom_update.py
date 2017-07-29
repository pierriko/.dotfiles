#! /usr/bin/env python
import sys
import platform
try: # python3
    from urllib.request import urlopen, urlretrieve
except ImportError: # python2
    from urllib import urlopen, urlretrieve
import subprocess

def reporthook(count, block_size, total_size):
    sys.stdout.write("\r%6.2f %% [%i/%i]"%((count * block_size * 100.0 /
        total_size), count * block_size, total_size))
    sys.stdout.flush()

filename = "atom-amd64.deb"
base_url = "https://github.com/atom/atom/releases"
url_info = urlopen("%s/latest"%base_url)
resolved = url_info.geturl()
version = lambda s: list(map(int, s.split('.')))
tag = resolved.split('/')[-1]
latest = version(tag[1:]) # remove 'v' in v0.1.2
try:
    cmd = subprocess.check_output(['atom', '--version']).decode()
    if cmd.startswith('Atom'): cmd = cmd.split()[2] # since 1.7
    current = version(cmd)
except:
    current = [0, 0, 0]

if latest > current:
    if platform.dist()[0] in ['fedora', 'redhat', 'SuSE']:
        filename = "atom.x86_64.rpm"

    url = "%s/download/%s/%s"%(base_url, tag, filename)
    print("downloading %s current is %s"%(url, current))
    filepath, _ = urlretrieve(url, filename, reporthook)
    print("\ninstall %s"%filepath)
    subprocess.check_output(['xdg-open', filepath])
