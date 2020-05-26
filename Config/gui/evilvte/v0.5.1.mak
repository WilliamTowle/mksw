# evilvte v0.5.1		[ since v0.70.1, c.2013-04-29 ]
# last mod WmT, 2013-12-25	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_EVILVTE_CONFIG},y)
HAVE_EVILVTE_CONFIG:=y

#DESCRLIST+= "'cui-evilvte' -- evilvte"

ifeq (${EVILVTE_VERSION},)
EVILVTE_VERSION=0.5.1
endif

EVILVTE_SRC=${SOURCES}/e/evilvte-${EVILVTE_VERSION}.tar.gz
URLS+= http://www.calno.com/evilvte/evilvte-0.5.1.tar.gz

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/misc/vte/v0.28.2.mak

NTI_EVILVTE_TEMP=nti-evilvte-${EVILVTE_VERSION}
NTI_EVILVTE_EXTRACTED=${EXTTEMP}/${NTI_EVILVTE_TEMP}/Makefile
NTI_EVILVTE_CONFIGURED=${EXTTEMP}/${NTI_EVILVTE_TEMP}/config.log
NTI_EVILVTE_BUILT=${EXTTEMP}/${NTI_EVILVTE_TEMP}/evilvte
NTI_EVILVTE_INSTALLED=${NTI_TC_ROOT}/usr/bin/evilvte


# ,-----
# |	Extract
# +-----

${NTI_EVILVTE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/evilvte-${EVILVTE_VERSION} ] || rm -rf ${EXTTEMP}/evilvte-${EVILVTE_VERSION}
	zcat ${EVILVTE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_EVILVTE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_EVILVTE_TEMP}
	mv ${EXTTEMP}/evilvte-${EVILVTE_VERSION} ${EXTTEMP}/${NTI_EVILVTE_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_EVILVTE_CONFIGURED}: ${NTI_EVILVTE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_EVILVTE_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/`/	s%pkg-config%'${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config'%' \
			| sed '/exec/	s%pkg-config%'${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config'%' \
			> configure ;\
		chmod a+x configure ;\
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)
#	PKGCONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \


# ,-----
# |	Build
# +-----

${NTI_EVILVTE_BUILT}: ${NTI_EVILVTE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_EVILVTE_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_EVILVTE_INSTALLED}: ${NTI_EVILVTE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_EVILVTE_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-evilvte
nti-evilvte: ${NTI_EVILVTE_INSTALLED}
#nti-evilvte: nti-libX11 ${NTI_EVILVTE_INSTALLED}

ALL_NTI_TARGETS+= nti-vte nti-evilvte

endif	# HAVE_EVILVTE_CONFIG
