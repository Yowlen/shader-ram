# linux-shader-cache-ramdisk

This will install a RAM disk for use with shader caches for increased performance in games. The tradeoff is that it can increase boot times significantly depending on the size of the shader caches and filesystem.

Currently supports the following shader caches:
- nVidia (Proprietary only)
- Steam

and the following distributions:
- Ubuntu & its derivatives
- Maybe Debian or other distros, but I make no promises

To install:
1. Download this and unzip it somewhere
2. Open a terminal and `cd` to where you unzipped it
3. Run `chmod +x ./shader-ram-install && ./shader-ram-install` and enter your password when it's asked for

To uninstall:
1. Open a terminal and run `/opt/shader-ram/shader-ram-uninstall` and enter your password when it's asked for

**Notes:**
- This doesn't try to figure out which parts are relevant to your installation, so you'll need to manually edit all scripts except for the install & uninstall scripts to only use the relevant parts before installing.
- This script *does* back up shader caches on shutdown or reboot, but not during standby, hibernation, or loss of power. If you normally use standby or hibernation to shut down the machine instead of a full power off, keep this in mind.

I know there's ways to solve/mitigate these issues, but I don't know if I'll ever actually do it myself. If anyone cares to fix them, I'll be happy to add them in here too.
