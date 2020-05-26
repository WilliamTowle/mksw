# fftw v3.3.6-pl1		[ since v3.3.4, c.2015-11-12 ]
# last mod WmT, 2017-03-01	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_FFTW},y)
HAVE_FFTW:=y

#DESCRLIST+= "'nti-fftw' -- fftw"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FFTW3_VERSION},)
#FFTW3_VERSION=3.3.4
FFTW3_VERSION=3.3.6-pl1
endif

FFTW3_SRC=${SOURCES}/f/fftw-${FFTW3_VERSION}.tar.gz
URLS+= http://www.fftw.org/fftw-${FFTW3_VERSION}.tar.gz

# build deps
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

# misc deps?

NTI_FFTW3_TEMP=nti-fftw3-${FFTW3_VERSION}

NTI_FFTW3_EXTRACTED=${EXTTEMP}/${NTI_FFTW3_TEMP}/configure
NTI_FFTW3_CONFIGURED=${EXTTEMP}/${NTI_FFTW3_TEMP}/Makefile
NTI_FFTW3_BUILT=${EXTTEMP}/${NTI_FFTW3_TEMP}/tools/fftw-wisdom
NTI_FFTW3_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/fftw3.pc


## ,-----
## |	Extract
## +-----

${NTI_FFTW3_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fftw-${FFTW3_VERSION} ] || rm -rf ${EXTTEMP}/fftw-${FFTW3_VERSION}
	zcat ${FFTW3_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FFTW3_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FFTW3_TEMP}
	mv ${EXTTEMP}/fftw-${FFTW3_VERSION} ${EXTTEMP}/${NTI_FFTW3_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FFTW3_CONFIGURED}: ${NTI_FFTW3_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FFTW3_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FFTW3_BUILT}: ${NTI_FFTW3_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FFTW3_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_FFTW3_INSTALLED}: ${NTI_FFTW3_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FFTW3_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-fftw3
nti-fftw3: nti-pkg-config ${NTI_FFTW3_INSTALLED}

ALL_NTI_TARGETS+= nti-fftw3

endif	# HAVE_FFTW3_CONFIG
