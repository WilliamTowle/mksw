# wmctrl v1.07			[ since v1.07, c.2017-11-01 ]
# last mod WmT, 2017-11-01	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_WMCTRL_CONFIG},y)
HAVE_WMCTRL_CONFIG:=y

DESCRLIST+= "'nti-wmctrl' -- wmctrl"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${WMCTRL_VERSION},)
WMCTRL_VERSION=1.07
endif

WMCTRL_SRC=${SOURCES}/w/wmctrl-1.07.tar.gz
URLS+= http://tripie.sweb.cz/utils/wmctrl/dist/wmctrl-1.07.tar.gz

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_WMCTRL_TEMP=nti-wmctrl-${WMCTRL_VERSION}
NTI_WMCTRL_EXTRACTED=${EXTTEMP}/${NTI_WMCTRL_TEMP}/configure
NTI_WMCTRL_CONFIGURED=${EXTTEMP}/${NTI_WMCTRL_TEMP}/config.log
NTI_WMCTRL_BUILT=${EXTTEMP}/${NTI_WMCTRL_TEMP}/wmctrl
NTI_WMCTRL_INSTALLED=${NTI_TC_ROOT}/usr/bin/wmctrl


# ,-----
# |	Extract
# +-----

${NTI_WMCTRL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/wmctrl-${WMCTRL_VERSION} ] || rm -rf ${EXTTEMP}/wmctrl-${WMCTRL_VERSION}
	#bzcat ${WMCTRL_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${WMCTRL_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${WMCTRL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WMCTRL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WMCTRL_TEMP}
	mv ${EXTTEMP}/wmctrl-${WMCTRL_VERSION} ${EXTTEMP}/${NTI_WMCTRL_TEMP}



# ,-----
# |	Configure
# +-----

${NTI_WMCTRL_CONFIGURED}: ${NTI_WMCTRL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_WMCTRL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_WMCTRL_BUILT}: ${NTI_WMCTRL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_WMCTRL_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_WMCTRL_INSTALLED}: ${NTI_WMCTRL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_WMCTRL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-wmctrl
nti-wmctrl: \
	${NTI_WMCTRL_INSTALLED}

ALL_NTI_TARGETS+= nti-wmctrl

endif	# HAVE_WMCTRL_CONFIG
