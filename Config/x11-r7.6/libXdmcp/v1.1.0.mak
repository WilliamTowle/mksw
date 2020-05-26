# libXdmcp v1.1.0		[ since v1.0.2, c.2008-06-12 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018 ]

ifneq (${HAVE_LIBXDMCP_CONFIG},y)
HAVE_LIBXDMCP_CONFIG:=y

#DESCRLIST+= "'nti-libXdmcp' -- libXdmcp"
#DESCRLIST+= "'cti-libXdmcp' -- libXdmcp"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.6/x11proto/v7.0.20.mak

ifeq (${LIBXDMCP_VERSION},)
#LIBXDMCP_VERSION=1.0.3
LIBXDMCP_VERSION=1.1.0
endif
#LIBXDMCP_SRC=${SOURCES}/l/libxdmcp_1.0.2.orig.tar.gz
LIBXDMCP_SRC=${SOURCES}/l/libXdmcp-1.1.0.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/lib/libXdmcp-1.0.3.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libXdmcp-1.1.0.tar.bz2

NTI_LIBXDMCP_TEMP=nti-libXdmcp-${LIBXDMCP_VERSION}

NTI_LIBXDMCP_EXTRACTED=${EXTTEMP}/${NTI_LIBXDMCP_TEMP}/configure
NTI_LIBXDMCP_CONFIGURED=${EXTTEMP}/${NTI_LIBXDMCP_TEMP}/config.status
NTI_LIBXDMCP_BUILT=${EXTTEMP}/${NTI_LIBXDMCP_TEMP}/xdmcp.pc
NTI_LIBXDMCP_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xdmcp.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXDMCP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXdmcp-${LIBXDMCP_VERSION} ] || rm -rf ${EXTTEMP}/libXdmcp-${LIBXDMCP_VERSION}
	bzcat ${LIBXDMCP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXDMCP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXDMCP_TEMP}
	mv ${EXTTEMP}/libXdmcp-${LIBXDMCP_VERSION} ${EXTTEMP}/${NTI_LIBXDMCP_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXDMCP_CONFIGURED}: ${NTI_LIBXDMCP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDMCP_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXDMCP_BUILT}: ${NTI_LIBXDMCP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDMCP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXDMCP_INSTALLED}: ${NTI_LIBXDMCP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDMCP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXdmcp
nti-libXdmcp: nti-pkg-config nti-x11proto ${NTI_LIBXDMCP_INSTALLED}

ALL_NTI_TARGETS+= nti-libXdmcp

endif	# HAVE_LIBXDMCP_CONFIG
