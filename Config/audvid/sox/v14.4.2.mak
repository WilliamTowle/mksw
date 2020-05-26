# sox v14.4.2			[ EARLIEST v?.?? ]
# last mod WmT, 2016-08-18	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_SOX_CONFIG},y)
HAVE_SOX_CONFIG:=y

#DESCRLIST+= "'nti-sox' -- sox"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SOX_VERSION},)
SOX_VERSION=14.4.2
endif
SOX_SRC=${SOURCES}/s/sox-${SOX_VERSION}.tar.gz

URLS+= "http://downloads.sourceforge.net/project/sox/sox/${SOX_VERSION}/sox-${SOX_VERSION}.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsox%2Ffiles%2Fsox%2F${SOX_VERSION}%2F&ts=1347119566&use_mirror=garr"

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

NTI_SOX_TEMP=nti-sox-${SOX_VERSION}

NTI_SOX_EXTRACTED=${EXTTEMP}/${NTI_SOX_TEMP}/Makefile
NTI_SOX_CONFIGURED=${EXTTEMP}/${NTI_SOX_TEMP}/config.log
NTI_SOX_BUILT=${EXTTEMP}/${NTI_SOX_TEMP}/src/sox
NTI_SOX_INSTALLED=${NTI_TC_ROOT}/usr/bin/sox


## ,-----
## |	Extract
## +-----

${NTI_SOX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/sox-${SOX_VERSION} ] || rm -rf ${EXTTEMP}/sox-${SOX_VERSION}
	zcat ${SOX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SOX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SOX_TEMP}
	mv ${EXTTEMP}/sox-${SOX_VERSION} ${EXTTEMP}/${NTI_SOX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SOX_CONFIGURED}: ${NTI_SOX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SOX_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SOX_BUILT}: ${NTI_SOX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SOX_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SOX_INSTALLED}: ${NTI_SOX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SOX_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-sox
nti-sox: ${NTI_SOX_INSTALLED}

ALL_NTI_TARGETS+= nti-sox

endif	# HAVE_SOX_CONFIG
