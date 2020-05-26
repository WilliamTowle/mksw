# lhasa v0.2.0			[ since v0.2.0, 2015-04-09 ]
# last mod WmT, 2015-04-09	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_LHASA_CONFIG},y)
HAVE_LHASA_CONFIG:=y

#DESCRLIST+= "'nti-lhasa' -- lhasa"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${LHASA_VERSION},)
LHASA_VERSION=0.2.0
endif
LHASA_SRC=${SOURCES}/l/lhasa_0.2.0+git3fe46.orig.tar.xz

URLS+= http://ftp.de.debian.org/debian/pool/main/l/lhasa/lhasa_0.2.0+git3fe46.orig.tar.xz

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/buildtools/autoconf/v2.65.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak


NTI_LHASA_TEMP=nti-lhasa-${LHASA_VERSION}

NTI_LHASA_EXTRACTED=${EXTTEMP}/${NTI_LHASA_TEMP}/autogen.sh
NTI_LHASA_CONFIGURED=${EXTTEMP}/${NTI_LHASA_TEMP}/config.log
NTI_LHASA_BUILT=${EXTTEMP}/${NTI_LHASA_TEMP}/src/lha
NTI_LHASA_INSTALLED=${NTI_TC_ROOT}/usr/bin/lha


## ,-----
## |	Extract
## +-----

${NTI_LHASA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/lha-${LHASA_VERSION} ] || rm -rf ${EXTTEMP}/lha-${LHASA_VERSION}
	[ ! -d ${EXTTEMP}/lhasa-0.2.0+git3fe46 lha-${LHASA_VERSION} ] || rm -rf ${EXTTEMP}/lhasa-0.2.0+git3fe46
	xzcat ${LHASA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LHASA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LHASA_TEMP}
	#mv ${EXTTEMP}/lha-${LHASA_VERSION} ${EXTTEMP}/${NTI_LHASA_TEMP}
	mv ${EXTTEMP}/lhasa-0.2.0+git3fe46 ${EXTTEMP}/${NTI_LHASA_TEMP}


## ,-----
## |	Configure
## +-----

# TODO: autogen.sh - fix 'libtoolize' properly
# TODO: running autogen.sh wants 'Makefile.in'; has 'Makefile.am'
# FUTURE: autogen.sh passes its args to 'configure' :)

${NTI_LHASA_CONFIGURED}: ${NTI_LHASA_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHASA_TEMP} || exit 1 ;\
		[ -r autogen.sh.OLD ] || mv autogen.sh autogen.sh.OLD || exit 1 ;\
		cat autogen.sh.OLD \
			| sed 's/libtoolize/'${HOSTSPEC}'-libtoolize/' \
			> autogen.sh ;\
		chmod a+x autogen.sh ;\
		./autogen.sh --prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LHASA_BUILT}: ${NTI_LHASA_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHASA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LHASA_INSTALLED}: ${NTI_LHASA_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHASA_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-lhasa
nti-lhasa: nti-autoconf nti-automake nti-libtool \
	${NTI_LHASA_INSTALLED}

ALL_NTI_TARGETS+= nti-lhasa

endif	# HAVE_LHASA_CONFIG
