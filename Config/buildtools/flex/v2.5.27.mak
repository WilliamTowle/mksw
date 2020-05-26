# flex v2.5.27			[ EARLIEST v1.34, c.2002-10-09 ]
# last mod WmT, 2016-02-09	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_FLEX_CONFIG},y)
HAVE_FLEX_CONFIG:=y

#DESCRLIST+= "'nti-flex' -- flex"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FLEX_VERSION},)
# debian 'flex-old'
#FLEX_VERSION=2.5.4a
# unavailable older
FLEX_VERSION=2.5.27
# "regular" flex
#FLEX_VERSION=2.6.0
endif

FLEX_SRC=${SOURCES}/f/flex-${FLEX_VERSION}.tar.bz2
#FLEX_SRC=${SOURCES}/f/flex-old_2.5.4a.orig.tar.gz
URLS+= http://sourceforge.net/projects/flex/files/flex/2.5.27/flex-2.5.27.tar.bz2/download
#URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/f/flex-old/flex-old_2.5.4a.orig.tar.gz

include ${CFG_ROOT}/buildtools/m4/v1.4.12.mak
#include ${CFG_ROOT}/buildtools/m4/v1.4.16.mak
#include ${CFG_ROOT}/buildtools/m4/v1.4.17.mak

NTI_FLEX_TEMP=nti-flex-${FLEX_VERSION}

NTI_FLEX_EXTRACTED=${EXTTEMP}/${NTI_FLEX_TEMP}/README
NTI_FLEX_CONFIGURED=${EXTTEMP}/${NTI_FLEX_TEMP}/config.log
NTI_FLEX_BUILT=${EXTTEMP}/${NTI_FLEX_TEMP}/flex
NTI_FLEX_INSTALLED=${NTI_TC_ROOT}/usr/bin/flex


## ,-----
## |	Extract
## +-----

${NTI_FLEX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/flex-${FLEX_VERSION} ] || rm -rf ${EXTTEMP}/flex-${FLEX_VERSION}
	#[ ! -d ${EXTTEMP}/flex-2.5.4 ] || rm -rf ${EXTTEMP}/flex-2.5.4
	bzcat ${FLEX_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${FLEX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FLEX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FLEX_TEMP}
	mv ${EXTTEMP}/flex-${FLEX_VERSION} ${EXTTEMP}/${NTI_FLEX_TEMP}
	#mv ${EXTTEMP}/flex-2.5.4 ${EXTTEMP}/${NTI_FLEX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FLEX_CONFIGURED}: ${NTI_FLEX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FLEX_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FLEX_BUILT}: ${NTI_FLEX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FLEX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FLEX_INSTALLED}: ${NTI_FLEX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FLEX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-flex
nti-flex: nti-m4 ${NTI_FLEX_INSTALLED}

ALL_NTI_TARGETS+= nti-flex

endif	# HAVE_FLEX_CONFIG
