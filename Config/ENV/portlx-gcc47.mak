# metafile comprising package list for  'portlx' toolchain components

ifneq (${PREBUILT_XGCC},true)
include ${CFG_ROOT}/ENV/buildtype.mak
else
# These settings for buildroot compiler, c.2015-07
TARGCPU:= arm
TARGSPEC:=${TARGCPU}-unknown-linux-gnueabi
export PATH:=${HOME}/devel/crosstool-ng/arm-unknown-linux-gnueabi/bin/:${PATH}
endif

## [2017-01-16] Sanity-check ${TARGSPEC} tail ('-uclibc' is flagged
## as deprecated in gcc v4.?.?)
EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)
ifeq ($(lastword $(subst -,${SPACE},${TARGSPEC})),uclibc)
# 'buildroot' style - arm-homebrew-linux-uclibc rejected by v4.8.x+
TARGSPEC:=$(subst -uclibc,-uclibceabi,${TARGSPEC})
endif


## compiler/binutils versions

BINUTILS_VERSION?= 2.22
GCC_VERSION?= 4.7.4
KGCC_VERSION?= ${GCC_VERSION}
# gmp,mpfr needed for gcc <= 4.{3|4}.x; mpc required by 4.6.x+
GCC_GMP_VERSION?= 4.3.2
GCC_MPFR_VERSION?= 2.4.2
GCC_MPC_VERSION?= 1.0.1

#KERNEL_VERSION?= 3.2.4
#KERNEL_VERSION?= 3.9.11
KERNEL_VERSION?= 3.10.65
#UCLIBC_VERSION?= 0.9.33
UCLIBC_VERSION?= 0.9.33.2
#BUSYBOX_VERSION?= 1.20.2
#BUSYBOX_VERSION?= 1.22.1
BUSYBOX_VERSION?= 1.23.1

# -----
# prerequisites for build
# NB: flex requires m4
#include ${CFG_ROOT}/buildtools/m4/v1.4.16.mak
include ${CFG_ROOT}/buildtools/m4/v1.4.17.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak
include ${CFG_ROOT}/misc/bc/v1.06.mak

# -----
#  includes for packages we require
include ${CFG_ROOT}/portlx-gcc47/kernel.mak
include ${CFG_ROOT}/portlx-gcc47/ucldev.mak
include ${CFG_ROOT}/portlx-gcc47/uclrt.mak
include ${CFG_ROOT}/portlx-gcc47/xbinu.mak
include ${CFG_ROOT}/portlx-gcc47/xgcc.mak
include ${CFG_ROOT}/portlx-gcc47/xkgcc.mak
# Need to build libgcc separately for uClibc 0.9.33.2 (0.9.30+?)
include ${CFG_ROOT}/portlx-gcc47/xlibgcc.mak
include ${CFG_ROOT}/portlx-gcc47/bbox.mak

# -----
# TODO: tight control of build targets (and build order) is required
# in order to make some or all of the toolchain, etc [contrasting with
# 'mksw', where the included files add themselves to the target list and
# thereby convey dependencies and required build order]
ifeq (${PREBUILT_XGCC},true)
# even with a prebuilt cross compiler, we still need kernel/uClibc configs
ALL_CTI_TARGETS+= cti-lxheaders cti-ucldev
else
ALL_CTI_TARGETS+= cti-lxheaders cti-binutils cti-xkgcc cti-ucldev xlibgcc cti-uclrt xgcc
endif
ALL_CUI_TARGETS+= cui-kernel cui-bbox cui-uclrt
