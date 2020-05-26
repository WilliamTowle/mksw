# diffstat v1.54		[ since v1.47, c.2009-09-24 ]
# last mod WmT, 2010-10-14	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_DIFFSTAT_CONFIG},y)
HAVE_DIFFSTAT_CONFIG:=y

DESCRLIST+= "'nti-diffstat' -- diffstat"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


#DIFFSTAT_VER=1.47
#DIFFSTAT_VER=1.53
DIFFSTAT_VER=1.54
#DIFFSTAT_SRC=${SRCDIR}/d/diffstat_${DIFFSTAT_VER}.orig.tar.gz
DIFFSTAT_SRC=${SRCDIR}/d/diffstat-1.54.tgz

#URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/d/diffstat/diffstat_${DIFFSTAT_VER}.orig.tar.gz
URLS+= ftp://invisible-island.net/diffstat/diffstat-1.54.tgz


## ,-----
## |	Extract
## +-----

NTI_DIFFSTAT_TEMP=nti-diffstat-${DIFFSTAT_VER}

NTI_DIFFSTAT_EXTRACTED=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/configure

.PHONY: nti-diffstat-extracted
nti-diffstat-extracted: ${NTI_DIFFSTAT_EXTRACTED}

${NTI_DIFFSTAT_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIFFSTAT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${DIFFSTAT_SRC}
	mv ${EXTTEMP}/diffstat-${DIFFSTAT_VER} ${EXTTEMP}/${NTI_DIFFSTAT_TEMP}


## ,-----
## |	Configure
## +-----

NTI_DIFFSTAT_CONFIGURED=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/config.status

.PHONY: nti-diffstat-configured
nti-diffstat-configured: nti-diffstat-extracted ${NTI_DIFFSTAT_CONFIGURED}

${NTI_DIFFSTAT_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
	  ./configure \
	  	--prefix=${NTI_TC_ROOT}/usr \
		|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_DIFFSTAT_BUILT=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/diffstat

.PHONY: nti-diffstat-built
nti-diffstat-built: nti-diffstat-configured ${NTI_DIFFSTAT_BUILT}

${NTI_DIFFSTAT_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_DIFFSTAT_INSTALLED=${NTI_TC_ROOT}/usr/bin/diffstat

.PHONY: nti-diffstat-installed
nti-diffstat-installed: nti-diffstat-built ${NTI_DIFFSTAT_INSTALLED}

${NTI_DIFFSTAT_INSTALLED}: ${NTI_DIFFSTAT_BUILT} ${NTI_TC_ROOT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-diffstat
nti-diffstat: nti-diffstat-installed

NTARGETS+= nti-diffstat

endif	# HAVE_DIFFSTAT_CONFIG
