# libdvdcss v1.2.13		[ since v1.2.13, c.2013-05-31 ]
# last mod WmT, 2013-06-07	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBDVDCSS_CONFIG},y)
HAVE_LIBDVDCSS_CONFIG:=y

#DESCRLIST+= "'nti-libdvdcss' -- libdvdcss"
#DESCRLIST+= "'nui-libdvdcss' -- libdvdcss"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBDVDCSS_VERSION},)
LIBDVDCSS_VERSION=1.2.13
endif

LIBDVDCSS_SRC=${SOURCES}/l/libdvdcss-${LIBDVDCSS_VERSION}.tar.bz2
URLS+= http://download.videolan.org/pub/libdvdcss/1.2.13/libdvdcss-1.2.13.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


NTI_LIBDVDCSS_TEMP=nti-libdvdcss-${LIBDVDCSS_VERSION}

NTI_LIBDVDCSS_EXTRACTED=${EXTTEMP}/${NTI_LIBDVDCSS_TEMP}/README
NTI_LIBDVDCSS_CONFIGURED=${EXTTEMP}/${NTI_LIBDVDCSS_TEMP}/config.status
NTI_LIBDVDCSS_BUILT=${EXTTEMP}/${NTI_LIBDVDCSS_TEMP}/libdvdcss.la
NTI_LIBDVDCSS_INSTALLED=${NTI_TC_ROOT}/usr/lib/libdvdcss.so


NUI_LIBDVDCSS_TEMP=nui-libdvdcss-${LIBDVDCSS_VERSION}

NUI_LIBDVDCSS_EXTRACTED=${EXTTEMP}/${NUI_LIBDVDCSS_TEMP}/README
NUI_LIBDVDCSS_CONFIGURED=${EXTTEMP}/${NUI_LIBDVDCSS_TEMP}/config.status
NUI_LIBDVDCSS_BUILT=${EXTTEMP}/${NUI_LIBDVDCSS_TEMP}/libdvdcss.la
NUI_LIBDVDCSS_INSTALLED=${NUI_TC_ROOT}/usr/lib/libdvdcss.so


## ,-----
## |	Extract
## +-----

${NTI_LIBDVDCSS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION} ] || rm -rf ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION}
	bzcat ${LIBDVDCSS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP}
	mv ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION} ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP}

##

${NUI_LIBDVDCSS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION} ] || rm -rf ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION}
	bzcat ${LIBDVDCSS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP} ] || rm -rf ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP}
	mv ${EXTTEMP}/libdvdcss-${LIBDVDCSS_VERSION} ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP}


## ,-----
## |	Configure
## +-----

#	LIBTOOL=${HOSTSPEC}-libtool

${NTI_LIBDVDCSS_CONFIGURED}: ${NTI_LIBDVDCSS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)

##

${NUI_LIBDVDCSS_CONFIGURED}: ${NUI_LIBDVDCSS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=/usr \
			|| exit 1 \
	)



## ,-----
## |	Build
## +-----

#	make LIBTOOL=${HOSTSPEC}-libtool

${NTI_LIBDVDCSS_BUILT}: ${NTI_LIBDVDCSS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP} || exit 1 ;\
		make \
	)

##

${NUI_LIBDVDCSS_BUILT}: ${NUI_LIBDVDCSS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#	make install LIBTOOL=${HOSTSPEC}-libtool

${NTI_LIBDVDCSS_INSTALLED}: ${NTI_LIBDVDCSS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBDVDCSS_TEMP} || exit 1 ;\
		make install \
	)

##

${NUI_LIBDVDCSS_INSTALLED}: ${NUI_LIBDVDCSS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NUI_LIBDVDCSS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libdvdcss
nti-libdvdcss: ${NTI_LIBDVDCSS_INSTALLED}
#nti-libdvdcss: nti-libtool ${NTI_LIBDVDCSS_INSTALLED}

ALL_NTI_TARGETS+= nti-libdvdcss

##

.PHONY: nui-libdvdcss
nui-libdvdcss: ${NUI_LIBDVDCSS_INSTALLED}
#nui-libdvdcss: nui-libtool ${NUI_LIBDVDCSS_INSTALLED}

ALL_NUI_TARGETS+= nui-libdvdcss

endif	# HAVE_LIBDVDCSS_CONFIG
