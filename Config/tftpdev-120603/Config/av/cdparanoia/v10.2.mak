# cdparanoia v10.2		[ since v10.2, c.2010-02-05 ]
# last mod WmT, 2010-02-05	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_CDPARANOIA_CONFIG},y)
HAVE_CDPARANOIA_CONFIG:=y

#include ${CFG_ROOT}/SDL/v1.2.13.mak
#include ${CFG_ROOT}/libX11/v1.2.2.mak

DESCRLIST+= "'nti-cdparanoia' -- cdparanoia"

CDPARANOIA_VER=10.2
CDPARANOIA_SRC=${SRCDIR}/c/cdparanoia-III-10.2.src.tgz

URLS+=http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz

##	package extract

NTI_CDPARANOIA_TEMP=nti-cdparanoia-${CDPARANOIA_VER}

NTI_CDPARANOIA_EXTRACTED=${EXTTEMP}/${NTI_CDPARANOIA_TEMP}/Makefile

.PHONY: nti-cdparanoia-extracted

nti-cdparanoia-extracted: ${NTI_CDPARANOIA_EXTRACTED}

${NTI_CDPARANOIA_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_CDPARANOIA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CDPARANOIA_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CDPARANOIA_SRC}
	mv ${EXTTEMP}/cdparanoia-III-${CDPARANOIA_VER} ${EXTTEMP}/${NTI_CDPARANOIA_TEMP}

##	package configure

NTI_CDPARANOIA_CONFIGURED=${EXTTEMP}/${NTI_CDPARANOIA_TEMP}/config.status

.PHONY: nti-cdparanoia-configured

nti-cdparanoia-configured: nti-cdparanoia-extracted ${NTI_CDPARANOIA_CONFIGURED}


${NTI_CDPARANOIA_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CDPARANOIA_TEMP} || exit 1 ;\
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

NTI_CDPARANOIA_BUILT=${EXTTEMP}/${NTI_CDPARANOIA_TEMP}/cdparanoia

.PHONY: nti-cdparanoia-built
nti-cdparanoia-built: nti-cdparanoia-configured ${NTI_CDPARANOIA_BUILT}

${NTI_CDPARANOIA_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CDPARANOIA_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_CDPARANOIA_INSTALLED=${HTC_ROOT}/usr/bin/cdparanoia

.PHONY: nti-cdparanoia-installed
nti-cdparanoia-installed: nti-cdparanoia-built ${NTI_CDPARANOIA_INSTALLED}

${NTI_CDPARANOIA_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CDPARANOIA_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-cdparanoia
nti-cdparanoia: nti-cdparanoia-installed

TARGETS+= nti-cdparanoia

endif	# HAVE_CDPARANOIA_CONFIG
