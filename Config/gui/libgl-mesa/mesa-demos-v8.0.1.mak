# mesa-demos v8.0.1		[ since v8.0.1, c.2015-09-15 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_MESA_DEMOS_CONFIG},y)
HAVE_MESA_DEMOS_CONFIG:=y

#DESCRLIST+= "'nti-mesa-demos' -- mesa-demos"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${MESA_DEMOS_VERSION},)
MESA_DEMOS_VERSION=8.0.1+git20110129+d8f7d6b
endif

MESA_DEMOS_SRC=${SOURCES}/m/mesa-demos_${MESA_DEMOS_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/m/mesa-demos/mesa-demos_8.0.1+git20110129+d8f7d6b.orig.tar.gz

include ${CFG_ROOT}/audvid/glew/v1.13.0.mak

NTI_MESA_DEMOS_TEMP=nti-mesa-demos-${MESA_DEMOS_VERSION}

NTI_MESA_DEMOS_EXTRACTED=${EXTTEMP}/${NTI_MESA_DEMOS_TEMP}/Makefile.in
NTI_MESA_DEMOS_CONFIGURED=${EXTTEMP}/${NTI_MESA_DEMOS_TEMP}/Makefile
NTI_MESA_DEMOS_BUILT=${EXTTEMP}/${NTI_MESA_DEMOS_TEMP}/BAZ
NTI_MESA_DEMOS_INSTALLED=${NTI_TC_ROOT}/usr/bin/QUX


## ,-----
## |	Extract
## +-----

${NTI_MESA_DEMOS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/mesa-demos-${MESA_DEMOS_VERSION} ] || rm -rf ${EXTTEMP}/mesa-demos-${MESA_DEMOS_VERSION}
	zcat ${MESA_DEMOS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP}
	mv ${EXTTEMP}/mesa-demos-${MESA_DEMOS_VERSION} ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP}


## ,-----
## |	Configure
## +-----

## TODO: autogen.sh can be passed the 'configure' arguments

${NTI_MESA_DEMOS_CONFIGURED}: ${NTI_MESA_DEMOS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
	  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
	  ACLOCAL='aclocal -I'${NTI_TC_ROOT}'/usr/share/aclocal' \
		./autogen.sh \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-silent-rules=no \
			|| exit 1 \
	)
#		./autogen.sh \
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

MESA_DEMOS_UNAME_M:=$(shell uname -m)

${NTI_MESA_DEMOS_BUILT}: ${NTI_MESA_DEMOS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP} || exit 1 ;\
		case ${MESA_DEMOS_UNAME_M} in \
		arm*) \
			make -C src/xdemos glxinfo \
		;; \
		*) \
		make \
		;; \
		esac \
	)


## ,-----
## |	Install
## +-----

## TODO: link stage: is '-lOpenVG' equivalent to Vivante's 'vg.pc'

${NTI_MESA_DEMOS_INSTALLED}: ${NTI_MESA_DEMOS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MESA_DEMOS_TEMP} || exit 1 ;\
		case ${MESA_DEMOS_UNAME_M} in \
		arm*) \
			cp src/xdemos/glxinfo ${NTI_TC_ROOT}/usr/bin \
		;; \
		*) \
		make install \
		;; \
		esac \
	)

##

.PHONY: nti-mesa-demos
nti-mesa-demos: nti-pkg-config \
	nti-glew ${NTI_MESA_DEMOS_INSTALLED}

ALL_NTI_TARGETS+= nti-mesa-demos

endif	# HAVE_MESA_DEMOS_CONFIG
