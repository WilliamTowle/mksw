# libsndfile v1.0.27		[ since v1.0.27, c.2016-06-23 ]
# last mod WmT, 2016-06-23	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_LIBSNDFILE_CONFIG},y)
HAVE_LIBSNDFILE_CONFIG:=y

#DESCRLIST+= "'nti-libsndfile' -- libsndfile"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${LIBSNDFILE_VERSION},)
LIBSNDFILE_VERSION=1.0.27
endif

LIBSNDFILE_SRC=${SOURCES}/l/libsndfile-${LIBSNDFILE_VERSION}.tar.gz
URLS+= http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.27.tar.gz

#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_LIBSNDFILE_TEMP=nti-libsndfile-${LIBSNDFILE_VERSION}

NTI_LIBSNDFILE_EXTRACTED=${EXTTEMP}/${NTI_LIBSNDFILE_TEMP}/README
NTI_LIBSNDFILE_CONFIGURED=${EXTTEMP}/${NTI_LIBSNDFILE_TEMP}/config.log
NTI_LIBSNDFILE_BUILT=${EXTTEMP}/${NTI_LIBSNDFILE_TEMP}/src/libsndfile.la
#NTI_LIBSNDFILE_INSTALLED=${NTI_TC_ROOT}/usr/lib/libsndfile.la
NTI_LIBSNDFILE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sndfile.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBSNDFILE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libsndfile-${LIBSNDFILE_VERSION} ] || rm -rf ${EXTTEMP}/libsndfile-${LIBSNDFILE_VERSION}
	zcat ${LIBSNDFILE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP}
	mv ${EXTTEMP}/libsndfile-${LIBSNDFILE_VERSION} ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBSNDFILE_CONFIGURED}: ${NTI_LIBSNDFILE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --with-pkgconfigdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
				|| exit 1 \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \
#		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#		for MF in Makefile libsndfile_port/Makefile ; do \
#			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
#			cat $${MF}.OLD \
#				| sed '/^pkgconfigdir/	s%$${libdir}%$$(prefix)/'${HOSTSPEC}'/lib%' \
#				> $${MF} ;\
#		done \



## ,-----
## |	Build
## +-----

${NTI_LIBSNDFILE_BUILT}: ${NTI_LIBSNDFILE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP} || exit 1 ;\
		make \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBSNDFILE_INSTALLED}: ${NTI_LIBSNDFILE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBSNDFILE_TEMP} || exit 1 ;\
		make install \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-libsndfile
nti-libsndfile: \
	${NTI_LIBSNDFILE_INSTALLED}
#nti-pkg-config \

ALL_NTI_TARGETS+= nti-libsndfile

endif	# HAVE_LIBSNDFILE_CONFIG
