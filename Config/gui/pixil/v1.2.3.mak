# pixil v1.2.3			[ since v1.2.3, c.2017-03-20 ]
# last mod WmT, 2017-03-20	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_PIXIL_CONFIG},y)
HAVE_PIXIL_CONFIG:=y

DESCRLIST+= "'nti-pixil' -- pixil"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PIXIL_VERSION},)
PIXIL_VERSION=1.2.3
endif

PIXIL_SRC=${SOURCES}/p/pixil-${PIXIL_VERSION}.tar.gz
URLS+= ftp://ftp.pixil.org/pub/pixil/pixil-1.2.3.tar.gz

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak

NTI_PIXIL_TEMP=nti-pixil-${PIXIL_VERSION}
NTI_PIXIL_EXTRACTED=${EXTTEMP}/${NTI_PIXIL_TEMP}/.configured
NTI_PIXIL_CONFIGURED=${EXTTEMP}/${NTI_PIXIL_TEMP}/config.log
NTI_PIXIL_BUILT=${EXTTEMP}/${NTI_PIXIL_TEMP}/src/pixil
NTI_PIXIL_INSTALLED=${NTI_TC_ROOT}/usr/bin/pixil


# ,-----
# |	Extract
# +-----

${NTI_PIXIL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/pixil-${PIXIL_VERSION} ] || rm -rf ${EXTTEMP}/pixil-${PIXIL_VERSION}
	#bzcat ${PIXIL_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${PIXIL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PIXIL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PIXIL_TEMP}
	mv ${EXTTEMP}/pixil-${PIXIL_VERSION} ${EXTTEMP}/${NTI_PIXIL_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_PIXIL_CONFIGURED}: ${NTI_PIXIL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PIXIL_TEMP} || exit 1 ;\
		touch ${NTI_PIXIL_CONFIGURED} \
	)


# ,-----
# |	Build
# +-----

${NTI_PIXIL_BUILT}: ${NTI_PIXIL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PIXIL_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_PIXIL_INSTALLED}: ${NTI_PIXIL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PIXIL_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

#.PHONY: nti-pixil
#nti-pixil: nti-libX11 ${NTI_PIXIL_INSTALLED}
.PHONY: nti-pixil
nti-pixil: ${NTI_PIXIL_INSTALLED}

ALL_NTI_TARGETS+= nti-pixil

endif	# HAVE_PIXIL_CONFIG
