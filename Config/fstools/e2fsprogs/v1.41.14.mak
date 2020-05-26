# e2fsprogs 1.41.14		[ since v1.38, 2007-03-13 ]
# last mod WmT, 2011-05-24	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_E2FSPROGS_CONFIG},y)
HAVE_E2FSPROGS_CONFIG:=y

DESCRLIST+= "'nti-e2fsprogs' -- e2fsprogs"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

#E2FSPROGS_VER=1.41.12
E2FSPROGS_VER=1.41.14
E2FSPROGS_SRC=${SRCDIR}/e/e2fsprogs-${E2FSPROGS_VER}.tar.gz

URLS+= http://garr.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-${E2FSPROGS_VER}.tar.gz


## ,-----
## |	Extract
## +-----

NTI_E2FSPROGS_TEMP=nti-e2fsprogs-${E2FSPROGS_VER}

NTI_E2FSPROGS_EXTRACTED=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/configure

.PHONY: nti-e2fsprogs-extracted

nti-e2fsprogs-extracted: ${NTI_E2FSPROGS_EXTRACTED}

${NTI_E2FSPROGS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_E2FSPROGS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${E2FSPROGS_SRC}
	mv ${EXTTEMP}/e2fsprogs-${E2FSPROGS_VER} ${EXTTEMP}/${NTI_E2FSPROGS_TEMP}


## ,-----
## |	Configure
## +-----

NTI_E2FSPROGS_CONFIGURED=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/config.status

.PHONY: nti-e2fsprogs-configured

nti-e2fsprogs-configured: nti-e2fsprogs-extracted ${NTI_E2FSPROGS_CONFIGURED}

${NTI_E2FSPROGS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_E2FSPROGS_BUILT=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/resize/resize2fs

.PHONY: nti-e2fsprogs-built
nti-e2fsprogs-built: nti-e2fsprogs-configured ${NTI_E2FSPROGS_BUILT}

${NTI_E2FSPROGS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_E2FSPROGS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/resize2fs

.PHONY: nti-e2fsprogs-installed

nti-e2fsprogs-installed: nti-e2fsprogs-built ${NTI_E2FSPROGS_INSTALLED}

${NTI_E2FSPROGS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-e2fsprogs
nti-e2fsprogs: nti-e2fsprogs-installed

NTARGETS+= nti-e2fsprogs

endif	# HAVE_E2FSPROGS_CONFIG
