# Config/ENV/ct-cross.mak

# ----- toolchain
# 1. override buildtype.mak cross compiler
# 2. include buildtype.mak to get ${CFG_ROOT} value

# for 32-bit ARM (cross-)compilation
#ifeq (${PREBUILT_XGCC},true)
##export PATH:=${HOME}/devel/opt/cross/i386/arm/gcc463-bin221/bin/:${PATH}
#export PATH:=${HOME}/devel/crosstool-ng/crosstool-ng-1.21.0/build/arm-unknown-linux-gnueabi/buildtools/bin/:${PATH}
#TARGCPU=arm
#TARGSPEC=${TARGCPU}-unknown-linux-gnueabi
#endif
#include Config/ENV/buildtype.mak

# for 64-bit ARM (cross-)compilation, with Debian's compiler
TARGCPU=aarch64
TARGSPEC=${TARGCPU}-linux-gnu
include Config/ENV/buildtype.mak

# -----
# toolchain: force specific versions, relevant build rules

#ifeq (${PREBUILT_XGCC},true)
#LIBTOOL_VERSION=2.2.10
##LIBTOOL_VERSION=2.4.2
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.6.mak
#else
#LIBTOOL_VERSION=1.5.26
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#endif
#PKG_CONFIG_VERSION=0.23
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

# -----
# supported packages

#include ${CFG_ROOT}/audvid/alsa-utils/v1.0.25.mak
#include ${CFG_ROOT}/audvid/alsa-utils/v1.0.27.2.mak
#include ${CFG_ROOT}/audvid/aumix/v2.9.1.mak
#include ${CFG_ROOT}/tools/dos2unix/v7.2.3.mak
include ${CFG_ROOT}/hwtools/lshw/vB.02.18.mak
# --
#include ${CFG_ROOT}/base/diffutils/v3.3-cross.mak
#include ${CFG_ROOT}/base/sed/v4.2.2-cross.mak
#include ${CFG_ROOT}/systools/kexec-tools/v2.0.10.mak
# --
#include ${CFG_ROOT}/x11-misc/libdrm/v2.4.46.mak
#include ${CFG_ROOT}/gui/wayland-video/v2014W37.mak
#include ${CFG_ROOT}/gui/wayland/v1.8.1.mak
