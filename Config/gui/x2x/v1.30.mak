# x2x v1.30			[ since v1.30, c.2017-11-01 ]
# last mod WmT, 2017-11-01	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_X2X_CONFIG},y)
HAVE_X2X_CONFIG:=y

DESCRLIST+= "'nti-x2x' -- x2x"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak

ifeq (${X2X_VERSION},)
X2X_VERSION=1.30
endif

#X2X_SRC=${SOURCES}/x/x2x-1.30.tar.gz
X2X_SRC=${SOURCES}/x/x2x_1.30.orig.tar.gz
URLS+= http://ftp.debian.org/debian/pool/main/x/x2x/x2x_1.30.orig.tar.gz

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_X2X_TEMP=nti-x2x-${X2X_VERSION}
NTI_X2X_EXTRACTED=${EXTTEMP}/${NTI_X2X_TEMP}/configure
NTI_X2X_CONFIGURED=${EXTTEMP}/${NTI_X2X_TEMP}/config.log
NTI_X2X_BUILT=${EXTTEMP}/${NTI_X2X_TEMP}/x2x
NTI_X2X_INSTALLED=${NTI_TC_ROOT}/usr/bin/x2x


# ,-----
# |	Extract
# +-----

${NTI_X2X_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/x2x-${X2X_VERSION} ] || rm -rf ${EXTTEMP}/x2x-${X2X_VERSION}
	#bzcat ${X2X_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${X2X_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${X2X_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X2X_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X2X_TEMP}
	mv ${EXTTEMP}/x2x-${X2X_VERSION} ${EXTTEMP}/${NTI_X2X_TEMP}



# ,-----
# |	Configure
# +-----

${NTI_X2X_CONFIGURED}: ${NTI_X2X_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X2X_TEMP} || exit 1 ;\
		  autoreconf -fi || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_X2X_BUILT}: ${NTI_X2X_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X2X_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_X2X_INSTALLED}: ${NTI_X2X_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X2X_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x2x
nti-x2x: \
	nti-autoconf \
	${NTI_X2X_INSTALLED}

ALL_NTI_TARGETS+= nti-x2x

endif	# HAVE_X2X_CONFIG
