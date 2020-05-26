## native-ng.mak
## lm 2012-03-26

## ,-----
## |	configuration for native ("build" [code-building]) system
## +-----

ifneq (${HAVE_NATIVE_CONFIG},y)
HAVE_NATIVE_CONFIG:= y

ifeq (${TC_ROOT},)
include ${CFG_ROOT}/ENV/ifbuild.env
endif

## NUI (Native, Userland, Installed) - what's installed already
## NTI (Native, Toolchain, Installed) - what we build for native use

## NUI_CPU vs NTI_CPU: NTI_CPU is x86-safe (for older toolchains)
## Native userland compiler is special - might be 'cc'

NUI_CPU:= $(shell uname -m)
NTI_CPU:= $(shell echo ${NUI_CPU} | sed 's/x86_64/i386/')
NUI_LIBC:= $(shell if [ -r /lib/ld-uClibc.so.0 ] ; then echo 'uclibc' ; else echo 'gnu' ; fi)
#NUI_CC_PREFIX:= $(shell (which gcc 2>/dev/null || echo '/usr/bin/gcc') | sed 's/cc$$//')
NUI_CC_PREFIX:= $(shell (PATH=/bin:/usr/bin:/sbin:/usr/sbin which gcc 2>/dev/null || echo '/usr/bin/gcc') | sed 's/cc$$//')

NTI_SPEC:= ${NUI_CPU}-provider-linux-${NUI_LIBC}
NATIVE_GCC_VERMAJ?= 4
ifeq (${NATIVE_GCC_VERMAJ},2)
HAVE_NATIVE_GCC_VER:=2.95.3
HAVE_NATIVE_BINUTILS_VER:=2.16.1
NATIVE_GCC_DEPS:= nti-native-gcc
NTI_GCC:= ${NTI_SPEC}-gcc
endif
ifeq (${NATIVE_GCC_VERMAJ},4)
#HAVE_NATIVE_GCC_VER:=4.1.2
#HAVE_NATIVE_GCC_VER:=4.2.4
#HAVE_NATIVE_GCC_VER:=4.3.1
HAVE_NATIVE_GCC_VER:=4.3.6
#HAVE_NATIVE_BINUTILS_VER:=2.17
#HAVE_NATIVE_BINUTILS_VER:=2.19.1
HAVE_NATIVE_BINUTILS_VER:=2.22
NATIVE_GCC_DEPS:= nti-native-gcc
NTI_GCC:= ${NTI_SPEC}-gcc
endif
# fallback compiler
NTI_GCC?= ${NUI_CC_PREFIX}cc

NTI_TC_ROOT:= ${TC_ROOT}

##

#ifeq ($(shell [ -r ${NTI_TC_ROOT}/bin ] && echo y),y)
export PATH:=${NTI_TC_ROOT}/bin:${PATH}
#endif
#ifeq ($(shell [ -r ${NTI_TC_ROOT}/usr/bin ] && echo y),y)
export PATH:=${NTI_TC_ROOT}/usr/bin:${PATH}
#endif

endif	# HAVE_NATIVE_CONFIG
