# metafile comprising package list for  'portlx' toolchain components

ifneq (${PREBUILT_XGCC},true)
include ${CFG_ROOT}/ENV/buildtype.mak
else
# These settings for buildroot compiler, c.2015-07
TARGCPU:= arm
TARGSPEC:=${TARGCPU}-unknown-linux-gnueabi
export PATH:=${HOME}/devel/crosstool-ng/arm-unknown-linux-gnueabi/bin/:${PATH}
endif

ifeq (${LEGACY},true)
KERNEL_VERSION:=	2.6.34
## TODO: legacy support should have older uClibc -- ?required?
#	BINUTILS_VERSION:= 2.17
#	GCC_VERSION:= 4.1.2
#	KGCC_VERSION:= ${GCC_VERSION}
#	UCLIBC_VERSION:= 0.9.28.3
endif

#BINUTILS_VERSION?= 2.22
#GCC_VERSION?= 4.3.6
#KGCC_VERSION?= ${GCC_VERSION}
## Minimum: gmp 4.3.2, mpfr 2.4.2
#GCC_GMP_VERSION?= 4.3.2
#GCC_MPFR_VERSION?= 2.4.2
BINUTILS_VERSION?= 2.22
GCC_VERSION?= 4.4.7
# [2017-01-09] 'jessie''s gcc v6 won't build 4.4.x without:
#	a) updated CFLAGS for parsing code style used
#	b) legacy version of 'makeinfo' for building documentation
KGCC_VERSION?= ${GCC_VERSION}
# Minimum: gmp 4.3.2, mpfr 2.4.2 (gcc 4.3.6 tested)
GCC_GMP_VERSION?= 4.3.2
GCC_MPFR_VERSION?= 2.4.2


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
include ${CFG_ROOT}/buildtools/m4/v1.4.16.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/misc/bc/v1.06.mak

# -----
#  includes for required packages
include ${CFG_ROOT}/portlx-gcc44/kernel.mak
include ${CFG_ROOT}/portlx-gcc44/ucldev.mak
include ${CFG_ROOT}/portlx-gcc44/uclrt.mak
include ${CFG_ROOT}/portlx-gcc44/xbinu.mak
include ${CFG_ROOT}/portlx-gcc44/xgcc.mak
include ${CFG_ROOT}/portlx-gcc44/xkgcc.mak
ifneq (${LEGACY},true)
# Need to build libgcc separately for uClibc 0.9.33.2 (0.9.30+?)
include ${CFG_ROOT}/portlx-gcc44/xlibgcc.mak
endif
include ${CFG_ROOT}/portlx-gcc44/bbox.mak

# -----
# TODO: tight control of build targets (and build order) is required
# in order to make some or all of the toolchain, etc [contrasting with
# 'mksw', where the included files add themselves to the target list and
# thereby convey dependencies and required build order]
ifeq (${LEGACY},true)
# 'LEGACY' builds (older uClibc) don't need 'xlibgcc' before cti-uclrt
# **NB:** prebuilt cross compiler support is NOT available in this case
ALL_CTI_TARGETS+= cti-lxheaders cti-binutils cti-xkgcc cti-ucldev cti-uclrt xgcc
else
ifeq (${PREBUILT_XGCC},true)
# even with a prebuilt cross compiler, we still need kernel/uClibc configs
ALL_CTI_TARGETS+= cti-lxheaders cti-ucldev
else
ALL_CTI_TARGETS+= cti-lxheaders cti-binutils cti-xkgcc cti-ucldev xlibgcc cti-uclrt xgcc
endif
endif
ALL_CUI_TARGETS+= cui-kernel cui-bbox cui-uclrt
