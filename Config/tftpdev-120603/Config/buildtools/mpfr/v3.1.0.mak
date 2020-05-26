# mpfr v3.1.0			[ EARLIEST v3.1.0, c. 2011-10-30 ]
# last mod WmT, 2011-10-30	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MPFR_CONFIG},y)
HAVE_MPFR_CONFIG:=y

DESCRLIST+= "'nti-mpfr' -- mpfr"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/buildtools/gmp/v4.3.2.mak

MPFR_VER=3.1.0
MPFR_SRC=${SRCDIR}/m/mpfr-${MPFR_VER}.tar.bz2

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/mpfr/mpfr-${MPFR_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_MPFR_TEMP=nti-mpfr-${MPFR_VER}

NTI_MPFR_EXTRACTED=${EXTTEMP}/${NTI_MPFR_TEMP}/Makefile

.PHONY: nti-mpfr-extracted
nti-mpfr-extracted: ${NTI_MPFR_EXTRACTED}

${NTI_MPFR_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MPFR_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MPFR_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MPFR_SRC}
	mv ${EXTTEMP}/mpfr-${MPFR_VER} ${EXTTEMP}/${NTI_MPFR_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MPFR_CONFIGURED=${EXTTEMP}/${NTI_MPFR_TEMP}/config.status

.PHONY: nti-mpfr-configured
nti-mpfr-configured: nti-mpfr-extracted ${NTI_MPFR_CONFIGURED}

${NTI_MPFR_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MPFR_TEMP} || exit 1 ;\
	  	CC=${NUI_CC_PREFIX}cc \
		./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --with-gmp=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_MPFR_BUILT=${EXTTEMP}/${NTI_MPFR_TEMP}/mpfr

.PHONY: nti-mpfr-built
nti-mpfr-built: nti-mpfr-configured ${NTI_MPFR_BUILT}

${NTI_MPFR_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MPFR_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_MPFR_INSTALLED=${NTI_TC_ROOT}/usr/bin/mpfr

.PHONY: nti-mpfr-installed
nti-mpfr-installed: nti-mpfr-built ${NTI_MPFR_INSTALLED}

${NTI_MPFR_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MPFR_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mpfr
nti-mpfr: nti-gmp nti-mpfr-installed

NTARGETS+= nti-mpfr

endif	# HAVE_MPFR_CONFIG
