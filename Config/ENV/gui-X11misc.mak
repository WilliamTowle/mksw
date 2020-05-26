# Config/ENV/gui-X11misc.mak
## was: Config/ENV/gui-X11R7.5.mak

# -----
# toolchain: buildtype.mak sets CFG_ROOT
include Config/ENV/buildtype.mak

# -----
## toolchain: force specific versions, relevant build rules
#LIBTOOL_VERSION=1.5.26
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#PKG_CONFIG_VERSION=0.23
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#...# mesa-demos for 'glxinfo'
include ${CFG_ROOT}/gui/mesa-demos/v8.0.1.mak

#...# Xvfb, configuration and dependencies
include ${CFG_ROOT}/gui/xorg-server/v1.14.3-xvfb.mak
include ${CFG_ROOT}/gui/xkeyboard-config/v2.11.mak
include ${CFG_ROOT}/gui/xkbcomp/v1.2.4.mak
