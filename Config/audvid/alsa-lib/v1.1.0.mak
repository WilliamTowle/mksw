# alsa-lib v1.1.0		[ EARLIEST v1.0.28, c.2012-11-30 ]
# last mod WmT, 2016-12-25	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_ALSA_LIB_CONFIG},y)
HAVE_ALSA_LIB_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

DESCRLIST+= "'nti-alsa-lib' -- alsa-lib"
DESCRLIST+= "'cui-alsa-lib' -- alsa-lib"

ifeq (${ALSA_LIB_VERSION},)
#ALSA_LIB_VERSION=1.0.13
#ALSA_LIB_VERSION=1.0.25
#ALSA_LIB_VERSION=1.0.27.2
#ALSA_LIB_VERSION=1.0.28
#ALSA_LIB_VERSION=1.0.29
ALSA_LIB_VERSION=1.1.0
endif

ALSA_LIB_SRC=${SOURCES}/a/alsa-lib-${ALSA_LIB_VERSION}.tar.bz2
URLS+= ftp://ftp.alsa-project.org/pub/lib/alsa-lib-${ALSA_LIB_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


CUI_ALSA_LIB_TEMP=cui-alsa-lib-${ALSA_LIB_VERSION}

CUI_ALSA_LIB_EXTRACTED=${EXTTEMP}/${CUI_ALSA_LIB_TEMP}/configure
CUI_ALSA_LIB_CONFIGURED=${EXTTEMP}/${CUI_ALSA_LIB_TEMP}/config.log
CUI_ALSA_LIB_BUILT=${EXTTEMP}/${CUI_ALSA_LIB_TEMP}/src/libasound.la
CUI_ALSA_LIB_INSTALLED=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/alsa.pc


NTI_ALSA_LIB_TEMP=nti-alsa-lib-${ALSA_LIB_VERSION}

NTI_ALSA_LIB_EXTRACTED=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/configure
NTI_ALSA_LIB_CONFIGURED=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/config.log
NTI_ALSA_LIB_BUILT=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/src/libasound.la
NTI_ALSA_LIB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/alsa.pc


## ,-----
## |	Extract
## +-----

${CUI_ALSA_LIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION} ] || rm -rf ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION}
	bzcat ${ALSA_LIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_ALSA_LIB_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_ALSA_LIB_TEMP}
	mv ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION} ${EXTTEMP}/${CUI_ALSA_LIB_TEMP}

##

${NTI_ALSA_LIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION} ] || rm -rf ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION}
	bzcat ${ALSA_LIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSA_LIB_TEMP}
	mv ${EXTTEMP}/alsa-lib-${ALSA_LIB_VERSION} ${EXTTEMP}/${NTI_ALSA_LIB_TEMP}


## ,-----
## |	Configure
## +-----

## [v1.1.0] build failure against uClibc due to missing 'include's

${CUI_ALSA_LIB_CONFIGURED}: ${CUI_ALSA_LIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_ALSA_LIB_TEMP} || exit 1 ;\
		case ${ALSA_LIB_VERSION} in \
		1.1.0) \
			[ -r src/topology/parser.c.OLD ] || cp src/topology/parser.c src/topology/parser.c.OLD || exit 1 ;\
			cat src/topology/parser.c.OLD \
				| sed '/list.h/	s%^%#include <sys/stat.h>\n%' \
				> src/topology/parser.c \
		;; \
		esac ;\
		CFLAGS='-O2' \
		LIBTOOL=${CUI_TC_ROOT}/usr/bin/${TARGSPEC}-libtool \
		PKG_CONFIG=${CUI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
		  ./configure \
			--prefix=/usr \
			--with-pkgconfdir=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \
			|| exit 1 \
	)


${NTI_ALSA_LIB_CONFIGURED}: ${NTI_ALSA_LIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
		case ${ALSA_LIB_VERSION} in \
		1.1.0) \
			[ -r src/topology/parser.c.OLD ] || cp src/topology/parser.c src/topology/parser.c.OLD || exit 1 ;\
			cat src/topology/parser.c.OLD \
				| sed '/list.h/	s%^%#include <sys/stat.h>\n%' \
				> src/topology/parser.c \
		;; \
		esac ;\
		CFLAGS='-O2' \
		LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSA_LIB_BUILT}: ${NTI_ALSA_LIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

## [2016-12-25] ipc_gid needs to refer to a group name that exists

${NTI_ALSA_LIB_INSTALLED}: ${NTI_ALSA_LIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		if [ -r /lib/ld-uClibc.so.0 ] ; then \
			[ -r  ${NTI_TC_ROOT}/usr/share/alsa/alsa.conf.bak ] || cp ${NTI_TC_ROOT}/usr/share/alsa/alsa.conf ${NTI_TC_ROOT}/usr/share/alsa/alsa.conf.bak || exit 1 ;\
			cat ${NTI_TC_ROOT}/usr/share/alsa/alsa.conf.bak \
				| sed '/ipc_gid/	s/audio/root/' \
				> ${NTI_TC_ROOT}/usr/share/alsa/alsa.conf ;\
		fi \
	)

##

.PHONY: cui-alsa-lib
cui-alsa-lib: cti-libtool cti-pkg-config ${CUI_ALSA_LIB_INSTALLED}

ALL_CUI_TARGETS+= cui-alsa-lib


.PHONY: nti-alsa-lib
nti-alsa-lib: nti-libtool nti-pkg-config ${NTI_ALSA_LIB_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-lib

endif	# HAVE_ALSA_LIB_CONFIG
