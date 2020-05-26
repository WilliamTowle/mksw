# giflib v5.0.6			[ since v5.0.6, c.2014-06-09 ]
# last mod WmT, 2014-06-09	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_GIFLIB_CONFIG},y)
HAVE_GIFLIB_CONFIG:=y

#DESCRLIST+= "'nti-giflib' -- giflib"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GIFLIB_VERSION},)
GIFLIB_VERSION=5.0.6
endif
GIFLIB_SRC=${SOURCES}/g/giflib-${GIFLIB_VERSION}.tar.bz2

URLS+= http://downloads.sourceforge.net/project/giflib/giflib-5.0.6.tar.bz2?use_mirror=garr

NTI_GIFLIB_TEMP=nti-giflib-${GIFLIB_VERSION}

NTI_GIFLIB_EXTRACTED=${EXTTEMP}/${NTI_GIFLIB_TEMP}/COPYING
NTI_GIFLIB_CONFIGURED=${EXTTEMP}/${NTI_GIFLIB_TEMP}/config.log
NTI_GIFLIB_BUILT=${EXTTEMP}/${NTI_GIFLIB_TEMP}/lib/libgif.la
NTI_GIFLIB_INSTALLED=${NTI_TC_ROOT}/usr/lib/libgif.la


## ,-----
## |	Extract
## +-----

${NTI_GIFLIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/giflib-${GIFLIB_VERSION} ] || rm -rf ${EXTTEMP}/giflib-${GIFLIB_VERSION}
	bzcat ${GIFLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GIFLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GIFLIB_TEMP}
	mv ${EXTTEMP}/giflib-${GIFLIB_VERSION} ${EXTTEMP}/${NTI_GIFLIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_GIFLIB_CONFIGURED}: ${NTI_GIFLIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GIFLIB_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_GIFLIB_BUILT}: ${NTI_GIFLIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GIFLIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_GIFLIB_INSTALLED}: ${NTI_GIFLIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GIFLIB_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-giflib
nti-giflib: ${NTI_GIFLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-giflib

endif	# HAVE_GIFLIB_CONFIG
