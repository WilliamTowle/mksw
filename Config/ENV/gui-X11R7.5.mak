# Config/ENV/gui-X11R7.5.mak

# -----
# toolchain: buildtype.mak sets CFG_ROOT
include Config/ENV/buildtype.mak

# -----
# toolchain: force specific versions, relevant build rules
LIBTOOL_VERSION=1.5.26
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
PKG_CONFIG_VERSION=0.23
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

# -----
# supported packages

include ${CFG_ROOT}/x11R7.5/libICE/v1.0.6.mak
include ${CFG_ROOT}/x11R7.5/libSM/v1.1.1.mak
include ${CFG_ROOT}/x11R7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11R7.5/libXau/v1.0.5.mak
include ${CFG_ROOT}/x11R7.5/libXdmcp/v1.0.3.mak
include ${CFG_ROOT}/x11R7.5/libXext/v1.1.1.mak
include ${CFG_ROOT}/x11R7.5/libXmu/v1.0.5.mak
include ${CFG_ROOT}/x11R7.5/libXpm/v3.5.8.mak
include ${CFG_ROOT}/x11R7.5/libXt/v1.0.7.mak
include ${CFG_ROOT}/x11R7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11R7.5/x11proto-bigreqs/v1.1.0.mak
include ${CFG_ROOT}/x11R7.5/x11proto-input/v2.0.mak
include ${CFG_ROOT}/x11R7.5/x11proto-kb/v1.0.4.mak
include ${CFG_ROOT}/x11R7.5/x11proto-xcmisc/v1.2.0.mak
include ${CFG_ROOT}/x11R7.5/x11proto-xext/v7.1.1.mak
include ${CFG_ROOT}/x11R7.5/xtrans/v1.2.5.mak

include ${CFG_ROOT}/gui/xclock/v1.0.6.mak
include ${CFG_ROOT}/gui/xsnow/v1.42.mak
include ${CFG_ROOT}/gui/xdesktopwaves/v1.3.mak

#Config/x11-r7.5/xorg-server/v1.7.1-xorgfb.mak
#Config/gui/jwm/v746.mak
#Config/gui/jwm/v2.2.2.mak
#Config/gui/rxvt/v2.7.10.mak
#Config/gui/mrxvt/v0.5.4.mak
#Config/gui/xload/v1.1.0.mak
