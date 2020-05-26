# mpg123 v1.15.4		[ EARLIEST v?.??, ????-????-?? ]
# last mod WmT, 2013-07-27	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_MPG123_CONFIG},y)
HAVE_MPG123_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-mpg123' -- mpg123"

ifeq (${MPG123_VERSION},)
#MPG123_VERSION=1.14.4
#MPG123_VERSION=1.15.1
MPG123_VERSION=1.15.4
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


MPG123_SRC=${SOURCES}/m/mpg123-${MPG123_VERSION}.tar.bz2
URLS+= http://www.mpg123.de/download/mpg123-${MPG123_VERSION}.tar.bz2

NTI_MPG123_TEMP=nti-mpg123-${MPG123_VERSION}

NTI_MPG123_EXTRACTED=${EXTTEMP}/${NTI_MPG123_TEMP}/Makefile
NTI_MPG123_CONFIGURED=${EXTTEMP}/${NTI_MPG123_TEMP}/config.log
NTI_MPG123_BUILT=${EXTTEMP}/${NTI_MPG123_TEMP}/src/mpg123
NTI_MPG123_INSTALLED=${NTI_TC_ROOT}/usr/bin/mpg123


## ,-----
## |	Extract
## +-----

${NTI_MPG123_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/mpg123-${MPG123_VERSION} ] || rm -rf ${EXTTEMP}/mpg123-${MPG123_VERSION}
	bzcat ${MPG123_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MPG123_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MPG123_TEMP}
	mv ${EXTTEMP}/mpg123-${MPG123_VERSION} ${EXTTEMP}/${NTI_MPG123_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MPG123_CONFIGURED}: ${NTI_MPG123_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MPG123_BUILT}: ${NTI_MPG123_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_MPG123_INSTALLED}: ${NTI_MPG123_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-mpg123
nti-mpg123: nti-libtool nti-pkg-config ${NTI_MPG123_INSTALLED}

ALL_NTI_TARGETS+= nti-mpg123

endif	# HAVE_MPG123_CONFIG
