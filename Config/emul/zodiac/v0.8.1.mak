# zodiac v0.8.1			[ EARLIEST v0.8.1, c.2017-03-14 ]
# last mod WmT, 2017-03-14	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_ZODIAC_CONFIG},y)
HAVE_ZODIAC_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

DESCRLIST+= "'nti-zodiac' -- zodiac"

#include ${CFG_ROOT}/tools/unzip/v60.mak

ifeq (${ZODIAC_VERSION},)
ZODIAC_VERSION=0.8.1
endif

ZODIAC_SRC=${SOURCES}/z/zodiac-${ZODIAC_VERSION}.tar.gz
URLS+= https://sourceforge.net/projects/zodiac/files/source/0.8.1/zodiac-0.8.1.tar.gz/download

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_ZODIAC_TEMP=nti-zodiac-${ZODIAC_VERSION}

NTI_ZODIAC_EXTRACTED=${EXTTEMP}/${NTI_ZODIAC_TEMP}/autogen.sh
NTI_ZODIAC_CONFIGURED=${EXTTEMP}/${NTI_ZODIAC_TEMP}/config.log
NTI_ZODIAC_BUILT=${EXTTEMP}/${NTI_ZODIAC_TEMP}/zodiac/Unix/zodiac
NTI_ZODIAC_INSTALLED=${NTI_TC_ROOT}/usr/bin/zodiac


## ,-----
## |	Extract
## +-----

${NTI_ZODIAC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/zodiac-${ZODIAC_VERSION} ] || rm -rf ${EXTTEMP}/zodiac-${ZODIAC_VERSION}
	zcat ${ZODIAC_SRC} | tar xvf - -C ${EXTTEMP}
	#unzip ${ZODIAC_SRC} -d ${EXTTEMP}/zodiac-${ZODIAC_VERSION}
	[ ! -d ${EXTTEMP}/${NTI_ZODIAC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZODIAC_TEMP}
	mv ${EXTTEMP}/zodiac-${ZODIAC_VERSION} ${EXTTEMP}/${NTI_ZODIAC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ZODIAC_CONFIGURED}: ${NTI_ZODIAC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ZODIAC_TEMP} || exit 1 ;\
		sh autogen.sh || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ZODIAC_BUILT}: ${NTI_ZODIAC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ZODIAC_TEMP} || exit 1 ;\
		make -C zodiac/Unix/ \
	)


## ,-----
## |	Install
## +-----

${NTI_ZODIAC_INSTALLED}: ${NTI_ZODIAC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ZODIAC_TEMP} || exit 1 ;\
		echo '...cp zodiac/Unix/zodiac SOMEWHERE' 1>&2 ;\
		exit 1 \
	)

##

.PHONY: nti-zodiac
#nti-zodiac: nti-unzip \
#	${NTI_ZODIAC_INSTALLED}
nti-zodiac: nti-autoconf nti-automake \
	${NTI_ZODIAC_INSTALLED}

ALL_NTI_TARGETS+= nti-zodiac

endif	# HAVE_ZODIAC_CONFIG
