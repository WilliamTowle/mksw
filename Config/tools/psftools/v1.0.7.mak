# psftools v1.0.7		[ since v1.0.7, c.2017-04-05 ]
# last mod WmT, 2017-04-05	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_PSFTOOLS_CONFIG},y)
HAVE_PSFTOOLS_CONFIG:=y

#DESCRLIST+= "'nti-psftools' -- psftools"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PSFTOOLS_VERSION},)
PSFTOOLS_VERSION=1.0.7
endif

PSFTOOLS_SRC=${SOURCES}/p/psftools-${PSFTOOLS_VERSION}.tar.gz
URLS+= http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz

NTI_PSFTOOLS_TEMP=nti-psftools-${PSFTOOLS_VERSION}

NTI_PSFTOOLS_EXTRACTED=${EXTTEMP}/${NTI_PSFTOOLS_TEMP}/configure
NTI_PSFTOOLS_CONFIGURED=${EXTTEMP}/${NTI_PSFTOOLS_TEMP}/config.status
NTI_PSFTOOLS_BUILT=${EXTTEMP}/${NTI_PSFTOOLS_TEMP}/tools/cpicomp
NTI_PSFTOOLS_INSTALLED=${NTI_TC_ROOT}/usr/bin/cpicomp


## ,-----
## |	Extract
## +-----

${NTI_PSFTOOLS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/psftools-${PSFTOOLS_VERSION} ] || rm -rf ${EXTTEMP}/psftools-${PSFTOOLS_VERSION}
	zcat ${PSFTOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PSFTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PSFTOOLS_TEMP}
	mv ${EXTTEMP}/psftools-${PSFTOOLS_VERSION} ${EXTTEMP}/${NTI_PSFTOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PSFTOOLS_CONFIGURED}: ${NTI_PSFTOOLS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PSFTOOLS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PSFTOOLS_BUILT}: ${NTI_PSFTOOLS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PSFTOOLS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PSFTOOLS_INSTALLED}: ${NTI_PSFTOOLS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PSFTOOLS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-psftools
nti-psftools: ${NTI_PSFTOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-psftools

endif	# HAVE_PSFTOOLS_CONFIG
