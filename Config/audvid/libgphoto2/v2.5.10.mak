# libgphoto2 v2.5.10		[ since v2.5.10, c.2016-06-21 ]
# last mod WmT, 2016-06-21	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_LIBGPHOTO2_CONFIG},y)
HAVE_LIBGPHOTO2_CONFIG:=y

#DESCRLIST+= "'nti-libgphoto2' -- libgphoto2"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${LIBGPHOTO2_VERSION},)
LIBGPHOTO2_VERSION=2.5.10
endif

LIBGPHOTO2_SRC=${SOURCES}/l/libgphoto2-${LIBGPHOTO2_VERSION}.tar.bz2
URLS+= http://prdownloads.sourceforge.net/project/gphoto/libgphoto/2.5.10/libgphoto2-${LIBGPHOTO2_VERSION}.tar.bz2?download

#
##include ${CFG_ROOT}/misc/zlib/v1.2.7.mak
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_LIBGPHOTO2_TEMP=nti-libgphoto2-${LIBGPHOTO2_VERSION}

NTI_LIBGPHOTO2_EXTRACTED=${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP}/README
NTI_LIBGPHOTO2_CONFIGURED=${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP}/config.log
NTI_LIBGPHOTO2_BUILT=${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP}/libgphoto2/libgphoto2.la
#NTI_LIBGPHOTO2_INSTALLED=${NTI_TC_ROOT}/usr/lib/libgphoto2.la
NTI_LIBGPHOTO2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libgphoto2.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBGPHOTO2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libgphoto2-${LIBGPHOTO2_VERSION} ] || rm -rf ${EXTTEMP}/libgphoto2-${LIBGPHOTO2_VERSION}
	bzcat ${LIBGPHOTO2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP}
	mv ${EXTTEMP}/libgphoto2-${LIBGPHOTO2_VERSION} ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBGPHOTO2_CONFIGURED}: ${NTI_LIBGPHOTO2_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 ;\
		for MF in Makefile libgphoto2_port/Makefile ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^pkgconfigdir/	s%$${libdir}%$$(prefix)/'${HOSTSPEC}'/lib%' \
				> $${MF} ;\
		done \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \
#		CPPFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
#		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \



## ,-----
## |	Build
## +-----

${NTI_LIBGPHOTO2_BUILT}: ${NTI_LIBGPHOTO2_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP} || exit 1 ;\
		make \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBGPHOTO2_INSTALLED}: ${NTI_LIBGPHOTO2_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBGPHOTO2_TEMP} || exit 1 ;\
		make install \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-libgphoto2
nti-libgphoto2: nti-pkg-config \
	${NTI_LIBGPHOTO2_INSTALLED}
#nti-libgphoto2: nti-zlib nti-pkg-config nti-libtool ${NTI_LIBGPHOTO2_INSTALLED}

ALL_NTI_TARGETS+= nti-libgphoto2

endif	# HAVE_LIBGPHOTO2_CONFIG
