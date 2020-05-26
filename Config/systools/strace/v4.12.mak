# strace v4.12			[ since v4.8, c.2014-01-18 ]
# last mod WmT, 2016-06-01	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_STRACE},y)
HAVE_STRACE:=y

#DESCRLIST+= "'nti-strace' -- strace"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${STRACE_VERSION},)
#STRACE_VERSION=4.8
#STRACE_VERSION=4.9
#STRACE_VERSION=4.10
STRACE_VERSION=4.12
endif

STRACE_SRC=${SOURCES}/s/strace-${STRACE_VERSION}.tar.xz
URLS+= 'http://downloads.sourceforge.net/project/strace/strace/${STRACE_VERSION}/strace-${STRACE_VERSION}.tar.xz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fstrace%2F&ts=1389881134&use_mirror=skylink'

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.13.1.mak
#include ${CFG_ROOT}/buildtools/shtool/v2.0.8.mak

NTI_STRACE_TEMP=nti-strace-${STRACE_VERSION}

NTI_STRACE_EXTRACTED=${EXTTEMP}/${NTI_STRACE_TEMP}/README
NTI_STRACE_CONFIGURED=${EXTTEMP}/${NTI_STRACE_TEMP}/config.status
NTI_STRACE_BUILT=${EXTTEMP}/${NTI_STRACE_TEMP}/strace
NTI_STRACE_INSTALLED=${NTI_TC_ROOT}/usr/bin/strace


## ,-----
## |	Extract
## +-----

${NTI_STRACE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/strace-${STRACE_VERSION} ] || rm -rf ${EXTTEMP}/strace-${STRACE_VERSION}
	xzcat ${STRACE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_STRACE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_STRACE_TEMP}
	mv ${EXTTEMP}/strace-${STRACE_VERSION} ${EXTTEMP}/${NTI_STRACE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_STRACE_CONFIGURED}: ${NTI_STRACE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_STRACE_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_STRACE_BUILT}: ${NTI_STRACE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_STRACE_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_STRACE_INSTALLED}: ${NTI_STRACE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_STRACE_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-strace
#nti-strace: nti-autoconf nti-automake nti-libtool nti-shtool ${NTI_STRACE_INSTALLED}
nti-strace: ${NTI_STRACE_INSTALLED}

ALL_NTI_TARGETS+= nti-strace

endif	# HAVE_STRACE_CONFIG
