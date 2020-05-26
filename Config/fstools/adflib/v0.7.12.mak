# adflib v2.12			[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-04-01	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_ADFLIB_CONFIG},y)
HAVE_ADFLIB_CONFIG:=y

#DESCRLIST+= "'nti-adflib' -- adflib"
#DESCRLIST+= "'cti-adflib' -- adflib"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ADFLIB_VERSION},)
ADFLIB_VERSION=0.7.12
endif

ADFLIB_SRC=${SOURCES}/a/adflib-${ADFLIB_VERSION}.tar.bz2
URLS+= http://lclevy.free.fr/adflib/adflib-0.7.12.tar.bz2

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

NTI_ADFLIB_TEMP=nti-adflib-${ADFLIB_VERSION}

NTI_ADFLIB_EXTRACTED=${EXTTEMP}/${NTI_ADFLIB_TEMP}/autogen.sh
NTI_ADFLIB_CONFIGURED=${EXTTEMP}/${NTI_ADFLIB_TEMP}/config.status
NTI_ADFLIB_BUILT=${EXTTEMP}/${NTI_ADFLIB_TEMP}/dosfslabel
NTI_ADFLIB_INSTALLED=${NTI_TC_ROOT}/usr/sbin/dosfslabel


## ,-----
## |	Extract
## +-----

${NTI_ADFLIB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/adflib-${ADFLIB_VERSION} ] || rm -rf ${EXTTEMP}/adflib-${ADFLIB_VERSION}
	bzcat ${ADFLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ADFLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ADFLIB_TEMP}
	mv ${EXTTEMP}/adflib-${ADFLIB_VERSION} ${EXTTEMP}/${NTI_ADFLIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ADFLIB_CONFIGURED}: ${NTI_ADFLIB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		[ -r autogen.sh.OLD ] || mv autogen.sh autogen.sh.OLD || exit 1 ;\
		cat autogen.sh.OLD \
			| sed 's/libtoolize/'${HOSTSPEC}'-libtoolize/' \
			> autogen.sh ;\
		chmod a+x autogen.sh ;\
		sh autogen.sh || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ADFLIB_BUILT}: ${NTI_ADFLIB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ADFLIB_INSTALLED}: ${NTI_ADFLIB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-adflib
nti-adflib: nti-autoconf nti-automake nti-libtool ${NTI_ADFLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-adflib

endif	# HAVE_ADFLIB_CONFIG
