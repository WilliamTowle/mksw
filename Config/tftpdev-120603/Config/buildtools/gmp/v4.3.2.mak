# gmp v4.3.2			[ EARLIEST v4.3.2, c. 2011-10-30 ]
# last mod WmT, 2011-10-30	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_GMP_CONFIG},y)
HAVE_GMP_CONFIG:=y

DESCRLIST+= "'nti-gmp' -- gmp"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


GMP_VER=4.3.2
GMP_SRC=${SRCDIR}/g/gmp-${GMP_VER}.tar.bz2

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gmp/gmp-${GMP_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_GMP_TEMP=nti-gmp-${GMP_VER}

NTI_GMP_EXTRACTED=${EXTTEMP}/${NTI_GMP_TEMP}/Makefile

.PHONY: nti-gmp-extracted
nti-gmp-extracted: ${NTI_GMP_EXTRACTED}

${NTI_GMP_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_GMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GMP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${GMP_SRC}
	mv ${EXTTEMP}/gmp-${GMP_VER} ${EXTTEMP}/${NTI_GMP_TEMP}


## ,-----
## |	Configure
## +-----

NTI_GMP_CONFIGURED=${EXTTEMP}/${NTI_GMP_TEMP}/config.status

.PHONY: nti-gmp-configured
nti-gmp-configured: nti-gmp-extracted ${NTI_GMP_CONFIGURED}

${NTI_GMP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GMP_TEMP} || exit 1 ;\
	  	CC=${NUI_CC_PREFIX}cc \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_GMP_BUILT=${EXTTEMP}/${NTI_GMP_TEMP}/gmp

.PHONY: nti-gmp-built
nti-gmp-built: nti-gmp-configured ${NTI_GMP_BUILT}

${NTI_GMP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GMP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_GMP_INSTALLED=${NTI_TC_ROOT}/usr/bin/gmp

.PHONY: nti-gmp-installed
nti-gmp-installed: nti-gmp-built ${NTI_GMP_INSTALLED}

${NTI_GMP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GMP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-gmp
nti-gmp: nti-gmp-installed

NTARGETS+= nti-gmp

endif	# HAVE_GMP_CONFIG
