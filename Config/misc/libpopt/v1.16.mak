# libpopt v1.16			[ since v1.16, c.2016-06-21 ]
# last mod WmT, 2016-06-21	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_LIBPOPT_CONFIG},y)
HAVE_LIBPOPT_CONFIG:=y

#DESCRLIST+= "'nti-libpopt' -- libpopt"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBPOPT_VERSION},)
LIBPOPT_VERSION=1.16
endif

LIBPOPT_SRC=${SOURCES}/p/popt-${LIBPOPT_VERSION}.tar.gz
URLS+= http://rpm5.org/files/popt/popt-${LIBPOPT_VERSION}.tar.gz

##include ${CFG_ROOT}/misc/zlib/v1.2.7.mak
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_LIBPOPT_TEMP=nti-libpopt-${LIBPOPT_VERSION}

NTI_LIBPOPT_EXTRACTED=${EXTTEMP}/${NTI_LIBPOPT_TEMP}/README
NTI_LIBPOPT_CONFIGURED=${EXTTEMP}/${NTI_LIBPOPT_TEMP}/config.log
NTI_LIBPOPT_BUILT=${EXTTEMP}/${NTI_LIBPOPT_TEMP}/libpopt/libpopt.la
#NTI_LIBPOPT_INSTALLED=${NTI_TC_ROOT}/usr/lib/libpopt.la
NTI_LIBPOPT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/popt.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBPOPT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/popt-${LIBPOPT_VERSION} ] || rm -rf ${EXTTEMP}/popt-${LIBPOPT_VERSION}
	#[ ! -d ${EXTTEMP}/libpopt-${LIBPOPT_VERSION} ] || rm -rf ${EXTTEMP}/libpopt-${LIBPOPT_VERSION}
	zcat ${LIBPOPT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPOPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPOPT_TEMP}
	mv ${EXTTEMP}/popt-${LIBPOPT_VERSION} ${EXTTEMP}/${NTI_LIBPOPT_TEMP}
	#mv ${EXTTEMP}/libpopt-${LIBPOPT_VERSION} ${EXTTEMP}/${NTI_LIBPOPT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBPOPT_CONFIGURED}: ${NTI_LIBPOPT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPOPT_TEMP} || exit 1 ;\
		for MF in Makefile.in ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^pkgconfigdir/	s%$$(prefix)%$$(prefix)/'${HOSTSPEC}'%' \
				> $${MF} ;\
		done ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBPOPT_BUILT}: ${NTI_LIBPOPT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPOPT_TEMP} || exit 1 ;\
		make \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBPOPT_INSTALLED}: ${NTI_LIBPOPT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPOPT_TEMP} || exit 1 ;\
		make install \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-libpopt
nti-libpopt: nti-pkg-config \
	${NTI_LIBPOPT_INSTALLED}
#nti-libpopt: nti-zlib nti-pkg-config nti-libtool ${NTI_LIBPOPT_INSTALLED}

ALL_NTI_TARGETS+= nti-libpopt

endif	# HAVE_LIBPOPT_CONFIG
