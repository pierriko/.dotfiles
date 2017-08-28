#! /usr/bin/env python
import os
import sys
import time
import collections
import curses

class Bitrate:
    def __init__(self, iface='eth0'):
        self.iface = iface
        self._log = collections.deque([], 10)
        self.log()

    def log(self):
        with open('/sys/class/net/%s/statistics/rx_bytes' % self.iface) as f:
            self._log.append([int( f.read().strip() ), time.time()])

    def get(self):
        r0 = self._log[ 0][0]
        t0 = self._log[ 0][1]
        r1 = self._log[-1][0]
        t1 = self._log[-1][1]
        return ( r1 - r0 ) / ( t1 - t0 )

    def human(self):
        self.log()
        bps  = self.get()
        unit = ' '
        for kmg in ['K', 'M', 'G']:
            if bps > 1024:
                bps /= 1024.0
                unit = kmg
            else:
                break
        return bps, unit

    def run(self):
        return "%9.3f %1sbps" % self.human()

def main(ifaces):
    brs = {iface: Bitrate(iface) for iface in ifaces}
    stdscr = curses.initscr()
    curses.noecho()
    curses.cbreak()
    try:
        while 1:
            pose = 0
            for iface, br in brs.items():
                stdscr.addstr(pose, 0, "%12s: %s\n"%(iface, br.run()))
                pose += 1
            stdscr.refresh()
            time.sleep(0.1)
    except KeyboardInterrupt:
        pass
    finally:
        curses.echo()
        curses.nocbreak()
        curses.endwin()

if __name__ == '__main__':
    main(os.listdir("/sys/class/net") if len(sys.argv) < 2 else sys.argv[1:])
