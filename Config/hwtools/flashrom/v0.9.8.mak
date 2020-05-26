# flashrom v0.9.8		[ since v0.9.8, c.2015-08-20 ]
# last mod WmT, 2015-08-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_FLASHROM_CONFIG},y)
HAVE_FLASHROM_CONFIG:=y

#DESCRLIST+= "'nti-flashrom' -- flashrom"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

ifeq (${FLASHROM_VERSION},)
FLASHROM_VERSION=0.9.8
endif

include ${CFG_ROOT}/hwtools/pciutils/v3.3.1.mak

FLASHROM_SRC=${SOURCES}/f/flashrom-${FLASHROM_VERSION}.tar.bz2
URLS+= http://download.flashrom.org/releases/flashrom-0.9.8.tar.bz2


NTI_FLASHROM_TEMP=nti-flashrom-${FLASHROM_VERSION}

NTI_FLASHROM_EXTRACTED=${EXTTEMP}/${NTI_FLASHROM_TEMP}/COPYING
NTI_FLASHROM_CONFIGURED=${EXTTEMP}/${NTI_FLASHROM_TEMP}/Makefile.OLD
NTI_FLASHROM_BUILT=${EXTTEMP}/${NTI_FLASHROM_TEMP}/flashrom/usr/sbin/flashrom
NTI_FLASHROM_INSTALLED=${NTI_TC_ROOT}/usr/sbin/QUX


## +-----
## |	Extract
## +-----

${NTI_FLASHROM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/flashrom-${FLASHROM_VERSION} ] || rm -rf ${EXTTEMP}/flashrom-${FLASHROM_VERSION}
	#[ ! -d ${EXTTEMP}/flashrom} ] || rm -rf ${EXTTEMP}/flashrom-${FLASHROM_VERSION}
	bzcat ${FLASHROM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FLASHROM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FLASHROM_TEMP}
	mv ${EXTTEMP}/flashrom-${FLASHROM_VERSION} ${EXTTEMP}/${NTI_FLASHROM_TEMP}
	#mv ${EXTTEMP}/flashrom ${EXTTEMP}/${NTI_FLASHROM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FLASHROM_CONFIGURED}: ${NTI_FLASHROM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FLASHROM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC /			s%g*cc%'${NTI_GCC}'%' \
			| sed '/^PREFIX /		s%/usr/local%'${NTI_TC_ROOT}'%' \
			| sed '/^PKG_CONFIG_LIBDIR /	s%^%#%' \
			> Makefile || exit 1 \
	)
#	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#	  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_FLASHROM_BUILT}: ${NTI_FLASHROM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FLASHROM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FLASHROM_INSTALLED}: ${NTI_FLASHROM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FLASHROM_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-flashrom
nti-flashrom: nti-pkg-config \
	nti-pciutils ${NTI_FLASHROM_INSTALLED}

ALL_NTI_TARGETS+= nti-flashrom

endif	# HAVE_FLASHROM_CONFIG
