# xpra v1.30			[ since v1.30, c.2017-11-01 ]
# last mod WmT, 2018-02-14	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_XPRA_CONFIG},y)
HAVE_XPRA_CONFIG:=y

DESCRLIST+= "'nti-xpra' -- xpra"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak

ifeq (${XPRA_VERSION},)
XPRA_VERSION=2.2.4
endif

XPRA_SRC=${SOURCES}/x/xpra-${XPRA_VERSION}.tar.bz2
URLS+= https://xpra.org/src/xpra-${XPRA_VERSION}.tar.bz2

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_XPRA_TEMP=nti-xpra-${XPRA_VERSION}
NTI_XPRA_EXTRACTED=${EXTTEMP}/${NTI_XPRA_TEMP}/README
NTI_XPRA_CONFIGURED=${EXTTEMP}/${NTI_XPRA_TEMP}/.configure
NTI_XPRA_BUILT=${EXTTEMP}/${NTI_XPRA_TEMP}/xpra
NTI_XPRA_INSTALLED=${NTI_TC_ROOT}/usr/bin/xpra


# ,-----
# |	Extract
# +-----

${NTI_XPRA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/xpra-${XPRA_VERSION} ] || rm -rf ${EXTTEMP}/xpra-${XPRA_VERSION}
	bzcat ${XPRA_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${XPRA_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${XPRA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XPRA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XPRA_TEMP}
	mv ${EXTTEMP}/xpra-${XPRA_VERSION} ${EXTTEMP}/${NTI_XPRA_TEMP}



# ,-----
# |	Configure
# +-----

${NTI_XPRA_CONFIGURED}: ${NTI_XPRA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XPRA_TEMP} || exit 1 ;\
		touch ${NTI_XPRA_CONFIGURED} \
	)


# ,-----
# |	Build
# +-----

${NTI_XPRA_BUILT}: ${NTI_XPRA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XPRA_TEMP} || exit 1 ;\
		./setup.py install --home=install \
	)


# ,-----
# |	Install
# +-----


${NTI_XPRA_INSTALLED}: ${NTI_XPRA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XPRA_TEMP} || exit 1 ;\
		echo 'TODO: install {bin|lib|share} trees to /usr...' ; exit 1 ;\
		make install \
	)

.PHONY: nti-xpra
nti-xpra: \
	${NTI_XPRA_INSTALLED}

ALL_NTI_TARGETS+= nti-xpra

endif	# HAVE_XPRA_CONFIG
