# mksw-de configuration - build-cross-userland.mk
# last mod WmT, 2024-05-11	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BUILD_NATIVE_USERLAND_MK},y)
HAVE_BUILD_NATIVE_USERLAND_MK:= y

include ${MF_CONFIGDIR}/INCLUDE/build-common.mk

NUI_HOST_CPU=$(shell /bin/uname -m)
ifeq ($(shell [ -r /lib/ld-uClibc.so.0 ] && echo Y),y)
NUI_HOST_LIBC?=uclibc
else
NUI_HOST_LIBC?=gnu
endif
NUI_HOST_SYSTYPE=${NUI_HOST_CPU}-unknown-linux-${NUI_HOST_LIBC}

NUI_HOST_GCC=/usr/bin/gcc

.PHONY: nui-sanity
nui-sanity: config-sanity


USAGE_TEXT+= "'all-nui-targets' - build all NUI (native userland) targets"

.PHONY: all-nui-targets
all-nui-targets:: nui-sanity

all:: all-nui-targets


endif	## HAVE_BUILD_NATIVE_USERLAND_MK
