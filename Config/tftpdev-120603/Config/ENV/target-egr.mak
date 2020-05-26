## target.mak
## lm 2011-01-05

## ,-----
## |	configuration for target ("host" [code-running]) system
## +-----

ifneq (${HAVE_TARGET_CONFIG},y)
HAVE_TARGET_CONFIG:= y

## CTI (Cross, Toolchain, Installed) - what we cross-compile
## NB. CTI_LIBC should be 'gnu' for older compilers (i.e. gcc v2)

CTI_CPU?= i386
CTI_LIBC:= gnu
#CTI_LIBC:= uclibc
CTI_SPEC:= ${CTI_CPU}-homebrew-linux-${CTI_LIBC}
CTI_MIN_SPEC:= ${CTI_CPU}-minimal-linux-${CTI_LIBC}

CTI_GCC:= ${CTI_SPEC}-gcc
CTI_MIN_GCC:= ${CTI_MIN_SPEC}-gcc

CTI_TC_ROOT:= ${TC_ROOT}

##

ifneq (${NTI_TC_ROOT},${CTI_TC_ROOT})
ifeq ($(shell [ -r ${CTI_TC_ROOT}/bin ] && echo y),y)
export PATH:=${CTI_TC_ROOT}/bin:${PATH}
endif
ifeq ($(shell [ -r ${CTI_TC_ROOT}/usr/bin ] && echo y),y)
export PATH:=${CTI_TC_ROOT}/usr/bin:${PATH}
endif
endif

#include ${CFG_ROOT}/distrotools-legacy/cross-gcc/v2.95.3.mak
#include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v0.9.26.mak

endif	# HAVE_TARGET_CONFIG
