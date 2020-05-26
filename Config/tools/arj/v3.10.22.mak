# arj v3.10.22		[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-01	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_ARJ_CONFIG},y)
HAVE_ARJ_CONFIG:=y

#DESCRLIST+= "'nti-arj' -- arj"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ARJ_VERSION},)
ARJ_VERSION=3.10.22
endif

ARJ_SRC=${SOURCES}/a/arj-${ARJ_VERSION}.tar.gz
URLS+= http://arj.sourceforge.net/files/arj-3.10.22.tar.gz

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak


NTI_ARJ_TEMP=nti-arj-${ARJ_VERSION}

NTI_ARJ_EXTRACTED=${EXTTEMP}/${NTI_ARJ_TEMP}/configure
NTI_ARJ_CONFIGURED=${EXTTEMP}/${NTI_ARJ_TEMP}/config.status
NTI_ARJ_BUILT=${EXTTEMP}/${NTI_ARJ_TEMP}/gzexe
NTI_ARJ_INSTALLED=${NTI_TC_ROOT}/usr/bin/arj


## ,-----
## |	Extract
## +-----

${NTI_ARJ_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/arj-${ARJ_VERSION} ] || rm -rf ${EXTTEMP}/arj-${ARJ_VERSION}
	zcat ${ARJ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ARJ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ARJ_TEMP}
	mv ${EXTTEMP}/arj-${ARJ_VERSION} ${EXTTEMP}/${NTI_ARJ_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ARJ_CONFIGURED}: ${NTI_ARJ_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ARJ_TEMP} || exit 1 ;\
		cd gnu || exit 1 ;\
		autoheader || exit 1 ;\
		autoconf || exit 1 ;\
		./configure ;\
		cd .. \
		; echo '...' ; exit 1 \
	)
#		CC=${NTI_GCC} \
#		  CFLAGS='-O2' \
#			./configure --prefix=${NTI_TC_ROOT}/usr \
#			  || exit 1 ;\


## ,-----
## |	Build
## +-----

${NTI_ARJ_BUILT}: ${NTI_ARJ_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ARJ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ARJ_INSTALLED}: ${NTI_ARJ_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ARJ_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-arj
nti-arj: nti-autoconf nti-automake ${NTI_ARJ_INSTALLED}

ALL_NTI_TARGETS+= nti-arj

endif	# HAVE_ARJ_CONFIG
