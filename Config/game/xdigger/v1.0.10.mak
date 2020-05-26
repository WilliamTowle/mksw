# xdigger v1.0.10		[ EARLIEST v?.?? ]
# last mod WmT, 2013-01-21	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_XDIGGER_CONFIG},y)
HAVE_XDIGGER_CONFIG:=y

#DESCRLIST+= "'nti-xdigger' -- xdigger"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${XDIGGER_VERSION},)
XDIGGER_VERSION=1.0.10
endif

XDIGGER_SRC=${SOURCES}/x/xdigger-${XDIGGER_VERSION}.tgz
URLS+= http://ibiblio.org/pub/linux/games/arcade/xdigger-1.0.10.tgz

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak


NTI_XDIGGER_TEMP=nti-xdigger-${XDIGGER_VERSION}

NTI_XDIGGER_EXTRACTED=${EXTTEMP}/${NTI_XDIGGER_TEMP}/README
NTI_XDIGGER_CONFIGURED=${EXTTEMP}/${NTI_XDIGGER_TEMP}/.configured
NTI_XDIGGER_BUILT=${EXTTEMP}/${NTI_XDIGGER_TEMP}/src/xdigger
NTI_XDIGGER_INSTALLED=${NTI_TC_ROOT}/usr/games/xdigger


## ,-----
## |	Extract
## +-----

${NTI_XDIGGER_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/xdigger-${XDIGGER_VERSION} ] || rm -rf ${EXTTEMP}/xdigger-${XDIGGER_VERSION}
	zcat ${XDIGGER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XDIGGER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XDIGGER_TEMP}
	mv ${EXTTEMP}/xdigger-${XDIGGER_VERSION} ${EXTTEMP}/${NTI_XDIGGER_TEMP}


## ,-----
## |	Configure
## +-----

## TODO: README says run 'xmkmf' (xutils-dev) and 'make' :(

${NTI_XDIGGER_CONFIGURED}: ${NTI_XDIGGER_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XDIGGER_TEMP} || exit 1 ;\
		touch ${NTI_XDIGGER_CONFIGURED} \
	)
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			| sed '/^TARGET_/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			> Makefile || exit 1 ;\
#		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
#		cat src/Makefile.OLD \
#			| sed '/^CC?=/	{ s/?// ; s%g*cc%'${NTI_GCC}'% }' \
#			| sed '/^CFLAGS+=/	{ s%$$% '"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags x11`"'% }' \
#			| sed '/^LIBS+=/	{ s%$$% '"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs-only-L x11`"'% }' \
#			> src/Makefile || exit 1 ;\


## ,-----
## |	Build
## +-----

${NTI_XDIGGER_BUILT}: ${NTI_XDIGGER_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XDIGGER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XDIGGER_INSTALLED}: ${NTI_XDIGGER_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XDIGGER_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-xdigger
nti-xdigger: \
	${NTI_XDIGGER_INSTALLED}
#nti-xdigger: nti-pkg-config \
#	nti-SDL nti-SDL_mixer ${NTI_XDIGGER_INSTALLED}

ALL_NTI_TARGETS+= nti-xdigger

endif	# HAVE_XDIGGER_CONFIG
