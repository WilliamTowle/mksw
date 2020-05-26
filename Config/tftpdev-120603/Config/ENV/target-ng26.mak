## target-ng.mak
## lm 2012-02-04

## ,-----
## |	configuration for target ("host" [code-running]) system
## +-----

ifneq (${HAVE_TARGET_CONFIG},y)
HAVE_TARGET_CONFIG:= y

ifeq (${TC_ROOT},)
include ${CFG_ROOT}/ENV/ifbuild.env
endif

## CTI (Cross, Toolchain, Installed) - what we cross-compile
## NB. CTI_LIBC should be 'gnu' for older compilers (i.e. gcc v2)

CTI_CPU?= i386
CTI_LIBC:= uclibc
ifeq (${CTI_CPU},arm)
CTI_ABI=gnueabi
CTI_GCC_ARCH_OPTS=--with-abi=aapcs-linux --with-arch=armv7-a --with-tune=cortex-a9
endif
CTI_SPEC:= ${CTI_CPU}-homebrew-linux-${CTI_LIBC}${CTI_ABI}
CTI_MIN_SPEC:= ${CTI_CPU}-minimal-linux-${CTI_LIBC}${CTI_ABI}

CTI_GCC:= ${CTI_SPEC}-gcc
CTI_MIN_GCC:= ${CTI_MIN_SPEC}-gcc

CTI_TC_ROOT:= ${TC_ROOT}

##

ifneq (${NTI_TC_ROOT},${CTI_TC_ROOT})
#ifeq ($(shell [ -r ${CTI_TC_ROOT}/bin ] && echo y),y)
export PATH:=${CTI_TC_ROOT}/bin:${PATH}
#endif
#ifeq ($(shell [ -r ${CTI_TC_ROOT}/usr/bin ] && echo y),y)
export PATH:=${CTI_TC_ROOT}/usr/bin:${PATH}
#endif
endif

HAVE_CROSS_GCC_VER:=4.1.2
#HAVE_CROSS_GCC_VER:=4.2.4
#HAVE_CROSS_GCC_VER:=4.3.6
HAVE_CROSS_BINUTILS_VER:=2.17
#HAVE_CROSS_BINUTILS_VER:=2.19.1
#HAVE_CROSS_BINUTILS_VER:=2.22
HAVE_TARGET_KERNEL_VER:=2.6.34
#	HAVE_TARGET_KERNEL_VER:=3.x
#	HAVE_TARGET_UCLIBC_VER:=0.9.28.3
#HAVE_TARGET_UCLIBC_VER:=0.9.30.3
#HAVE_TARGET_UCLIBC_VER:=0.9.31.1
HAVE_TARGET_UCLIBC_VER:=0.9.32.1

endif	# HAVE_TARGET_CONFIG
