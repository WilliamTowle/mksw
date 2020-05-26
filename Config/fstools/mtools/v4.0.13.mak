# mtools v4.0.13		[ since v3.9.9, c.2003-05-28 ]
# last mod WmT, 2011-06-02	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MTOOLS_CONFIG},y)
HAVE_MTOOLS_CONFIG:=y

DESCRLIST+= "'nti-mtools' -- mtools"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif


#MTOOLS_VER=4.0.12
MTOOLS_VER=4.0.13
MTOOLS_SRC=${SRCDIR}/m/mtools-${MTOOLS_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/mtools/mtools-${MTOOLS_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_MTOOLS_TEMP=nti-mtools-${MTOOLS_VER}

NTI_MTOOLS_EXTRACTED=${EXTTEMP}/${NTI_MTOOLS_TEMP}/Makefile

.PHONY: nti-mtools-extracted

nti-mtools-extracted: ${NTI_MTOOLS_EXTRACTED}

${NTI_MTOOLS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MTOOLS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MTOOLS_SRC}
	mv ${EXTTEMP}/mtools-${MTOOLS_VER} ${EXTTEMP}/${NTI_MTOOLS_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MTOOLS_CONFIGURED=${EXTTEMP}/${NTI_MTOOLS_TEMP}/config.status

.PHONY: nti-mtools-configured

nti-mtools-configured: nti-mtools-extracted ${NTI_MTOOLS_CONFIGURED}

${NTI_MTOOLS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  CC=${NTI_GCC} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_MTOOLS_BUILT=${EXTTEMP}/${NTI_MTOOLS_TEMP}/mtools

.PHONY: nti-mtools-built
nti-mtools-built: nti-mtools-configured ${NTI_MTOOLS_BUILT}

${NTI_MTOOLS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_MTOOLS_INSTALLED=${NTI_TC_ROOT}/usr/bin/mtools

.PHONY: nti-mtools-installed

nti-mtools-installed: nti-mtools-built ${NTI_MTOOLS_INSTALLED}

${NTI_MTOOLS_INSTALLED}:
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mtools
nti-mtools: nti-native-gcc nti-mtools-installed

NTARGETS+= nti-mtools

endif	# HAVE_MTOOLS_CONFIG
