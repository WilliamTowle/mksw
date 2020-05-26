## convmv v1.15			[ since v1.15, c.2015-02-02 ]
## last mod WmT, 2015-02-02	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_CONVMV_CONFIG},y)
HAVE_CONVMV_CONFIG:=y

#DESCRLIST+= "'nti-convmv' -- convmv"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${CONVMV_VERSION},)
CONVMV_VERSION=1.15
endif

CONVMV_SRC=${SOURCES}/c/convmv-${CONVMV_VERSION}.tar.gz
URLS+= https://www.j3e.de/linux/convmv/convmv-1.15.tar.gz

NTI_CONVMV_TEMP=nti-convmv-${CONVMV_VERSION}

NTI_CONVMV_EXTRACTED=${EXTTEMP}/${NTI_CONVMV_TEMP}/GPL2
NTI_CONVMV_CONFIGURED=${EXTTEMP}/${NTI_CONVMV_TEMP}/Makefile.OLD
NTI_CONVMV_BUILT=${EXTTEMP}/${NTI_CONVMV_TEMP}/convmv
NTI_CONVMV_INSTALLED=${NTI_TC_ROOT}/usr/bin/convmv


## ,-----
## |	Extract
## +-----

${NTI_CONVMV_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/convmv-${CONVMV_VERSION} ] || rm -rf ${EXTTEMP}/convmv-${CONVMV_VERSION}
	zcat ${CONVMV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CONVMV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CONVMV_TEMP}
	mv ${EXTTEMP}/convmv-${CONVMV_VERSION} ${EXTTEMP}/${NTI_CONVMV_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CONVMV_CONFIGURED}: ${NTI_CONVMV_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CONVMV_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_CONVMV_BUILT}: ${NTI_CONVMV_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CONVMV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CONVMV_INSTALLED}: ${NTI_CONVMV_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CONVMV_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-convmv
nti-convmv: ${NTI_CONVMV_INSTALLED}

ALL_NTI_TARGETS+= nti-convmv

endif	# HAVE_CONVMV_CONFIG
