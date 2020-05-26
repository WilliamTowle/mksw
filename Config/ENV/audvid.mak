# Config/ENV/audvid.mak

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
#include ${CFG_ROOT}/audvid/alsa-utils/v1.0.25.mak
include ${CFG_ROOT}/audvid/alsa-utils/v1.1.0.mak
include ${CFG_ROOT}/audvid/aumix/v2.9.1.mak
include ${CFG_ROOT}/audvid/ffmpeg/v3.1.2.mak
include ${CFG_ROOT}/audvid/jinamp/v1.0.6.mak
include ${CFG_ROOT}/audvid/mikmod/v3.2.5.mak
include ${CFG_ROOT}/audvid/mpg123/v1.14.1.mak
include ${CFG_ROOT}/audvid/sox/v14.4.0.mak
include ${CFG_ROOT}/audvid/uade/v2.13.mak
