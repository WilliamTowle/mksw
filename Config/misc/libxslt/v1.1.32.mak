# libxslt v1.1.32		[ since v1.1.28, c. 2015-10-15 ]
# last mod WmT, 2018-03-14	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXSLT_CONFIG},y)
HAVE_LIBXSLT_CONFIG:=y

DESCRLIST+= "'nti-libxslt' -- libxslt"

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXSLT_VERSION},)
#LIBXSLT_VERSION=1.1.28
LIBXSLT_VERSION=1.1.32
endif

LIBXSLT_SRC=${SOURCES}/l/libxslt-${LIBXSLT_VERSION}.tar.gz
#LIBXSLT_SRC=${SOURCES}/l/libxslt-${LIBXSLT_VERSION}.tar.bz2
URLS+= ftp://xmlsoft.org/libxml2/libxslt-${LIBXSLT_VERSION}.tar.gz

#include ${CFG_ROOT}/gui/x11proto/v7.0.23.mak
include ${CFG_ROOT}/misc/libxml2/v2.9.8.mak


NTI_LIBXSLT_TEMP=nti-libxslt-${LIBXSLT_VERSION}

NTI_LIBXSLT_EXTRACTED=${EXTTEMP}/${NTI_LIBXSLT_TEMP}/configure
NTI_LIBXSLT_CONFIGURED=${EXTTEMP}/${NTI_LIBXSLT_TEMP}/config.status
NTI_LIBXSLT_BUILT=${EXTTEMP}/${NTI_LIBXSLT_TEMP}/libxslt.pc
NTI_LIBXSLT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libxslt.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXSLT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxslt-${LIBXSLT_VERSION} ] || rm -rf ${EXTTEMP}/libxslt-${LIBXSLT_VERSION}
	#bzcat ${LIBXSLT_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${LIBXSLT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXSLT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXSLT_TEMP}
	mv ${EXTTEMP}/libxslt-${LIBXSLT_VERSION} ${EXTTEMP}/${NTI_LIBXSLT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXSLT_CONFIGURED}: ${NTI_LIBXSLT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSLT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-python=no \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXSLT_BUILT}: ${NTI_LIBXSLT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSLT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXSLT_INSTALLED}: ${NTI_LIBXSLT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSLT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libxslt
nti-libxslt: ${NTI_LIBXSLT_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-libxml2 \
	nti-libxslt

endif	# HAVE_LIBXSLT_CONFIG
