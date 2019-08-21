# Shader-RAM

This will install a RAM disk for use with shader caches for increased performance in games. The tradeoff is that it can increase boot times significantly depending on the size of the shader caches and filesystem.

Currently supports the following shader caches:
- nVidia (Proprietary)
- Mesa (Open Source AMDGPU/intel/nouveau drivers)
- Steam
- DXVK

and the following distributions:
- Ubuntu-based distros
- Maybe Debian or other distros using a bash shell, but I make no promises

## Install/Upgrade
1. Download the latest release from the Releases page up top and extract it somewhere
2. Open a terminal and `cd` to where you extracted it
3. Run `chmod +x ./install.sh && sudo ./install.sh` and enter your password when asked

## Uninstall
1. Open a terminal and run `sudo /opt/shader-ram/uninstall.sh` and enter your password when asked

## Command line options
*Coming soon*
