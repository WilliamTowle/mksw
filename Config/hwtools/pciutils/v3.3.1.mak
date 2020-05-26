# pciutils v3.3.1		[ EARLIEST v?.?? ]
# last mod WmT, 2015-08-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_PCIUTILS_CONFIG},y)
HAVE_PCIUTILS_CONFIG:=y

#DESCRLIST+= "'nti-pciutils' -- pciutils"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

ifeq (${PCIUTILS_VERSION},)
#PCIUTILS_VERSION=3.1.10
PCIUTILS_VERSION=3.3.1
endif

#PCIUTILS_SRC=${SOURCES}/p/pciutils-${PCIUTILS_VERSION}.tar.bz2
PCIUTILS_SRC=${SOURCES}/p/pciutils-${PCIUTILS_VERSION}.tar.gz
#URLS+= ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-3.1.7.tar.gz
#URLS+= http://www.kernel.org/pub/software/utils/pciutils/pciutils-${PCIUTILS_VERSION}.tar.bz2
URLS+= http://www.kernel.org/pub/software/utils/pciutils/pciutils-${PCIUTILS_VERSION}.tar.gz

NTI_PCIUTILS_TEMP=nti-pciutils-${PCIUTILS_VERSION}

NTI_PCIUTILS_EXTRACTED=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/COPYING
NTI_PCIUTILS_CONFIGURED=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/Makefile.OLD
NTI_PCIUTILS_BUILT=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/lspci
#NTI_PCIUTILS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/lspci
NTI_PCIUTILS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libpci.pc


## ,-----
## |	Extract
## +-----

${NTI_PCIUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pciutils-${PCIUTILS_VERSION} ] || rm -rf ${EXTTEMP}/pciutils-${PCIUTILS_VERSION}
	#bzcat ${PCIUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${PCIUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PCIUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PCIUTILS_TEMP}
	mv ${EXTTEMP}/pciutils-${PCIUTILS_VERSION} ${EXTTEMP}/${NTI_PCIUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PCIUTILS_CONFIGURED}: ${NTI_PCIUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^PREFIX=/	s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^ZLIB=/		s/=.*/=no/' \
			| sed '/^PKGCFDIR=/	s%=.*%= '${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

# [2012-11-12] DNS=[yes|no]: requires -lresolv

${NTI_PCIUTILS_BUILT}: ${NTI_PCIUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		make DNS=no \
	)


## ,-----
## |	Install
## +-----

## NB: 'install' creates /usr/sbin/lspci

${NTI_PCIUTILS_INSTALLED}: ${NTI_PCIUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		make install-lib \
	)

##

.PHONY: nti-pciutils
nti-pciutils: nti-pkg-config \
	${NTI_PCIUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-pciutils

endif	# HAVE_PCIUTILS_CONFIG
