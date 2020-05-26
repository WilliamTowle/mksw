# fim v0.4-rc1			[ EARLIEST v0.4-rc1, 2014-03-25 ]
# last mod WmT, 2014-03-28	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FIM_CONFIG},y)
HAVE_FIM_CONFIG:=y

#DESCRLIST+= "'nti-fim' -- fim"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
#include ${CFG_ROOT}/audvid/libpng/v1.2.33.mak
#include ${CFG_ROOT}/audvid/libpng/v1.4.12.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
#include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak
include ${CFG_ROOT}/buildtools/bison/v3.0.2.mak

ifeq (${FIM_VERSION},)
FIM_VERSION=0.4-rc1
endif

FIM_SRC=${SOURCES}/f/fim-${FIM_VERSION}.tar.bz2
URLS+= http://download.savannah.gnu.org/releases/fbi-improved/fim-0.4-rc1.tar.bz2

NTI_FIM_TEMP=nti-fim-${FIM_VERSION}

NTI_FIM_EXTRACTED=${EXTTEMP}/${NTI_FIM_TEMP}/README
NTI_FIM_CONFIGURED=${EXTTEMP}/${NTI_FIM_TEMP}/Makefile.OLD
NTI_FIM_BUILT=${EXTTEMP}/${NTI_FIM_TEMP}/fim
NTI_FIM_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/fim


## ,-----
## |	Extract
## +-----

${NTI_FIM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fim-${FIM_VERSION} ] || rm -rf ${EXTTEMP}/fim-${FIM_VERSION}
	bzcat ${FIM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FIM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FIM_TEMP}
	mv ${EXTTEMP}/fim-${FIM_VERSION} ${EXTTEMP}/${NTI_FIM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FIM_CONFIGURED}: ${NTI_FIM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FIM_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)
#		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_FIM_BUILT}: ${NTI_FIM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FIM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FIM_INSTALLED}: ${NTI_FIM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FIM_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
	)

##

.PHONY: nti-fim
nti-fim: nti-flex nti-bison ${NTI_FIM_INSTALLED}
#nti-fim: nti-SDL ${NTI_FIM_INSTALLED}

ALL_NTI_TARGETS+= nti-fim

endif	# HAVE_FIM_CONFIG
