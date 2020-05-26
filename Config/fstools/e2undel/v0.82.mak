# e2undel v0.82			[ since v0.82, c.2017-09-22 ]
# last mod WmT, 2017-09-22	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_E2UNDEL_CONFIG},y)
HAVE_E2UNDEL_CONFIG:=y

#DESCRLIST+= "'nti-e2undel' -- e2undel"
#DESCRLIST+= "'cti-e2undel' -- e2undel"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${E2UNDEL_VERSION},)
E2UNDEL_VERSION=0.82
endif

E2UNDEL_SRC=${SOURCES}/e/e2undel-${E2UNDEL_VERSION}.tgz
URLS+= http://prdownloads.sourceforge.net/e2undel/e2undel-0.82.tgz

NTI_E2UNDEL_TEMP=nti-e2undel-${E2UNDEL_VERSION}

NTI_E2UNDEL_EXTRACTED=${EXTTEMP}/${NTI_E2UNDEL_TEMP}/README
NTI_E2UNDEL_CONFIGURED=${EXTTEMP}/${NTI_E2UNDEL_TEMP}/.configured
NTI_E2UNDEL_BUILT=${EXTTEMP}/${NTI_E2UNDEL_TEMP}/e2undel
NTI_E2UNDEL_INSTALLED=${NTI_TC_ROOT}/usr/bin/e2undel


## ,-----
## |	Extract
## +-----

${NTI_E2UNDEL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/e2undel-${E2UNDEL_VERSION} ] || rm -rf ${EXTTEMP}/e2undel-${E2UNDEL_VERSION}
	#bzcat ${E2UNDEL_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${E2UNDEL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_E2UNDEL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_E2UNDEL_TEMP}
	mv ${EXTTEMP}/e2undel-${E2UNDEL_VERSION} ${EXTTEMP}/${NTI_E2UNDEL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_E2UNDEL_CONFIGURED}: ${NTI_E2UNDEL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_E2UNDEL_TEMP} || exit 1 ;\
		touch ${NTI_E2UNDEL_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_E2UNDEL_BUILT}: ${NTI_E2UNDEL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_E2UNDEL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_E2UNDEL_INSTALLED}: ${NTI_E2UNDEL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_E2UNDEL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-e2undel
nti-e2undel: ${NTI_E2UNDEL_INSTALLED}

ALL_NTI_TARGETS+= nti-e2undel

endif	# HAVE_E2UNDEL_CONFIG
