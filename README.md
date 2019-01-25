# linux-shader-cache-ramdisk

This will install a RAM disk for use with shader caches for increased performance in games.

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
- Remember that this script *does* copy stuff to RAM on bootup and back to disk on shutdown. Depending on the size of the shader caches & speed of the hard drives, you might end up with a significant increase to bootup & shutdown times.
- This doesn't try to figure out which parts are relevant to your installation, so you'll need to manually edit all scripts except for the install & uninstall scripts to only use the relevant parts before installing.
- Currently, there's no persistence for Steam libraries. It will scan for Steam libraries on every bootup. On the plus side, this will automatically detect new Steam libraries after rebooting. On the negative side, this will add up to 15 seconds of time to the boot process.
- This script *does* back up shader caches on shutdown or reboot, but not during standby, hibernation, or loss of power. If you normally use standby or hibernation to shut down the machine instead of a full power off, keep this in mind.

Regarding the last 3, I know there's ways to solve/mitigate them, but I don't know if I'll ever actually do it myself. If anyone cares to fix them, I'll be happy to add them in here too.
