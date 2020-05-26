# nasm v2.08.02			[ since v0.98.35, c.2002-10-21 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_NASM_CONFIG},y)
HAVE_NASM_CONFIG:=y

DESCRLIST+= "'nti-nasm' -- nasm"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


#NASM_VER=2.07
#NASM_VER=2.08.01
NASM_VER=2.08.02
NASM_SRC=${SRCDIR}/n/nasm-${NASM_VER}.tar.bz2

URLS+=http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2


# ,-----
# |	Extract
# +-----

NTI_NASM_TEMP=nti-nasm-${NASM_VER}

NTI_NASM_EXTRACTED=${EXTTEMP}/${NTI_NASM_TEMP}/configure

.PHONY: nti-nasm-extracted

nti-nasm-extracted: ${NTI_NASM_EXTRACTED}

${NTI_NASM_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NASM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NASM_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NASM_SRC}
	mv ${EXTTEMP}/nasm-${NASM_VER} ${EXTTEMP}/${NTI_NASM_TEMP}


# ,-----
# |	Configure
# +-----

NTI_NASM_CONFIGURED=${EXTTEMP}/${NTI_NASM_TEMP}/config.status

.PHONY: nti-nasm-configured

nti-nasm-configured: nti-nasm-extracted ${NTI_NASM_CONFIGURED}

${NTI_NASM_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
	  CC=${NUI_CC_PREFIX}cc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_NASM_BUILT=${EXTTEMP}/${NTI_NASM_TEMP}/nasm

.PHONY: nti-nasm-built
nti-nasm-built: nti-nasm-configured ${NTI_NASM_BUILT}

${NTI_NASM_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_NASM_INSTALLED=${NTI_TC_ROOT}/usr/bin/nasm

.PHONY: nti-nasm-installed

nti-nasm-installed: nti-nasm-built ${NTI_NASM_INSTALLED}

${NTI_NASM_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-nasm
nti-nasm: nti-nasm-installed

NTARGETS+= nti-nasm

endif	# HAVE_NASM_CONFIG
