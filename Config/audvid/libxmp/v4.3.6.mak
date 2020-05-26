# libxmp v4.3.6			[ since v4.3.1, c.2014-11-20 ]
# last mod WmT, 2015-03-26	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXMP_CONFIG},y)
HAVE_LIBXMP_CONFIG:=y

#DESCRLIST+= "'nti-libxmp' -- libxmp"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXMP_VERSION},)
#LIBXMP_VERSION=4.3.1
LIBXMP_VERSION=4.3.6
endif

LIBXMP_SRC=${SOURCES}/l/libxmp-${LIBXMP_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/xmp/libxmp/${LIBXMP_VERSION}/libxmp-${LIBXMP_VERSION}.tar.gz?r=&ts=1416491480&use_mirror=ignum'

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


NTI_LIBXMP_TEMP=nti-libxmp-${LIBXMP_VERSION}

NTI_LIBXMP_EXTRACTED=${EXTTEMP}/${NTI_LIBXMP_TEMP}/README
NTI_LIBXMP_CONFIGURED=${EXTTEMP}/${NTI_LIBXMP_TEMP}/Makefile.OLD
NTI_LIBXMP_BUILT=${EXTTEMP}/${NTI_LIBXMP_TEMP}/lib/libxmp.so.${LIBXMP_VERSION}
NTI_LIBXMP_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libxmp.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXMP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libxmp-${LIBXMP_VERSION} ] || rm -rf ${EXTTEMP}/libxmp-${LIBXMP_VERSION}
	zcat ${LIBXMP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXMP_TEMP}
	mv ${EXTTEMP}/libxmp-${LIBXMP_VERSION} ${EXTTEMP}/${NTI_LIBXMP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXMP_CONFIGURED}: ${NTI_LIBXMP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBXMP_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^	/	s%$$(LIBDIR)/pkgconfig%$${exec_prefix}/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXMP_BUILT}: ${NTI_LIBXMP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBXMP_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXMP_INSTALLED}: ${NTI_LIBXMP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBXMP_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		mkdir -p `dirname ${NTI_LIBXMP_INSTALLED}` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/libxmp.pc ${NTI_LIBXMP_INSTALLED} \

##

.PHONY: nti-libxmp
nti-libxmp: nti-libtool \
	${NTI_LIBXMP_INSTALLED}

ALL_NTI_TARGETS+= nti-libxmp

endif	# HAVE_LIBXMP_CONFIG
