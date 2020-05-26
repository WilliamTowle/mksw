# sg3_utils v1.30		[ since v1.30, c.2010-11-16 ]
# last mod WmT, 2010-11-16	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_SG3_UTILS_CONFIG},y)
HAVE_SG3_UTILS_CONFIG:=y

DESCRLIST+= "'nti-sg3_utils' -- sg3_utils"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif


SG3_UTILS_VER=1.30
SG3_UTILS_SRC=${SRCDIR}/s/sg3_utils-1.30.tgz

URLS+= http://sg.danny.cz/sg/p/sg3_utils-1.30.tgz


## ,-----
## |	Extract
## +-----

NTI_SG3_UTILS_TEMP=nti-sg3_utils-${SG3_UTILS_VER}

NTI_SG3_UTILS_EXTRACTED=${EXTTEMP}/${NTI_SG3_UTILS_TEMP}/configure

.PHONY: nti-sg3_utils-extracted

nti-sg3_utils-extracted: ${NTI_SG3_UTILS_EXTRACTED}

${NTI_SG3_UTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_SG3_UTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SG3_UTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SG3_UTILS_SRC}
	mv ${EXTTEMP}/sg3_utils-${SG3_UTILS_VER} ${EXTTEMP}/${NTI_SG3_UTILS_TEMP}


## ,-----
## |	Configure
## +-----

NTI_SG3_UTILS_CONFIGURED=${EXTTEMP}/${NTI_SG3_UTILS_TEMP}/config.status

.PHONY: nti-sg3_utils-configured

nti-sg3_utils-configured: nti-sg3_utils-extracted ${NTI_SG3_UTILS_CONFIGURED}

${NTI_SG3_UTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SG3_UTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_SG3_UTILS_BUILT=${EXTTEMP}/${NTI_SG3_UTILS_TEMP}/faked

.PHONY: nti-sg3_utils-built
nti-sg3_utils-built: nti-sg3_utils-configured ${NTI_SG3_UTILS_BUILT}

${NTI_SG3_UTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SG3_UTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_SG3_UTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked

.PHONY: nti-sg3_utils-installed

nti-sg3_utils-installed: nti-sg3_utils-built ${NTI_SG3_UTILS_INSTALLED}

${NTI_SG3_UTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SG3_UTILS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-sg3_utils
nti-sg3_utils: nti-sg3_utils-installed

NTARGETS+= nti-sg3_utils

endif	# HAVE_SG3_UTILS_CONFIG
