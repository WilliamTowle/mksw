# banner v1.3.2			[ since v?.?, c. ????-??-?? ]
# last mod WmT, 2014-03-27	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_BANNER_CONFIG},y)
HAVE_BANNER_CONFIG:=y

#DESCRLIST+= "'nti-banner' -- banner"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

##include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak

ifeq (${BANNER_VERSION},)
BANNER_VERSION=1.3.2
endif

BANNER_SRC=${SOURCES}/b/banner-${BANNER_VERSION}.tar.gz
URLS+= http://software.cedar-solutions.com/ftp/software/banner-1.3.2.tar.gz

NTI_BANNER_TEMP=nti-banner-${BANNER_VERSION}

NTI_BANNER_EXTRACTED=${EXTTEMP}/${NTI_BANNER_TEMP}/configure
NTI_BANNER_CONFIGURED=${EXTTEMP}/${NTI_BANNER_TEMP}/config.status
NTI_BANNER_BUILT=${EXTTEMP}/${NTI_BANNER_TEMP}/banner
NTI_BANNER_INSTALLED=${NTI_TC_ROOT}/usr/bin/banner


## ,-----
## |	Extract
## +-----

${NTI_BANNER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/banner-${BANNER_VERSION} ] || rm -rf ${EXTTEMP}/banner-${BANNER_VERSION}
	zcat ${BANNER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BANNER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BANNER_TEMP}
	mv ${EXTTEMP}/banner-${BANNER_VERSION} ${EXTTEMP}/${NTI_BANNER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BANNER_CONFIGURED}: ${NTI_BANNER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BANNER_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_BANNER_BUILT}: ${NTI_BANNER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BANNER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BANNER_INSTALLED}: ${NTI_BANNER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BANNER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-banner
nti-banner: ${NTI_BANNER_INSTALLED}
#nti-banner: nti-ncurses ${NTI_BANNER_INSTALLED}

ALL_NTI_TARGETS+= nti-banner

endif	# HAVE_BANNER_CONFIG
