# Config/ENV/emul.mak

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

include ${CFG_ROOT}/emul/qemu/v0.12.4.mak
#include ${CFG_ROOT}/emul/qemu/v0.13.0.mak
#include ${CFG_ROOT}/emul/qemu/v1.5.2.mak
#include ${CFG_ROOT}/emul/qemu/v2.4.0.mak
