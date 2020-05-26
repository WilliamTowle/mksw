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

include ${CFG_ROOT}/gui/libICE/v1.0.8.mak
include ${CFG_ROOT}/gui/libSM/v1.2.1.mak
include ${CFG_ROOT}/gui/libX11/v1.5.0.mak
include ${CFG_ROOT}/gui/libXau/v1.0.7.mak
include ${CFG_ROOT}/gui/libXdmcp/v1.1.1.mak
include ${CFG_ROOT}/gui/libXext/v1.3.1.mak
include ${CFG_ROOT}/gui/libXmu/v1.1.1.mak
include ${CFG_ROOT}/gui/libXpm/v3.5.10.mak
include ${CFG_ROOT}/gui/libXt/v1.1.3.mak
include ${CFG_ROOT}/gui/x11proto/v7.0.23.mak
include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.2.mak
include ${CFG_ROOT}/gui/x11proto-input/v2.2.mak
include ${CFG_ROOT}/gui/x11proto-kb/v1.0.6.mak
include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.2.mak
include ${CFG_ROOT}/gui/x11proto-xext/v7.2.1.mak
include ${CFG_ROOT}/gui/xtrans/v1.2.7.mak
