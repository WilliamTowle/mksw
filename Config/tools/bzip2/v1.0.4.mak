# bzip2 v1.0.4			[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-03-25	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_BZIP2_CONFIG},y)
HAVE_BZIP2_CONFIG:=y

#DESCRLIST+= "'nti-bzip2' -- bzip2"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${BZIP2_VERSION},)
BZIP2_VERSION=1.0.4
endif

BZIP2_SRC=${SOURCES}/b/bzip2-${BZIP2_VERSION}.tar.gz
URLS+= http://www.bzip.org/${BZIP2_VERSION}/bzip2-${BZIP2_VERSION}.tar.gz

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak


NTI_BZIP2_TEMP=nti-bzip2-${BZIP2_VERSION}

NTI_BZIP2_EXTRACTED=${EXTTEMP}/${NTI_BZIP2_TEMP}/LICENSE
NTI_BZIP2_CONFIGURED=${EXTTEMP}/${NTI_BZIP2_TEMP}/Makefile.OLD
NTI_BZIP2_BUILT=${EXTTEMP}/${NTI_BZIP2_TEMP}/bzip2
NTI_BZIP2_INSTALLED=${NTI_TC_ROOT}/usr/bin/bzip2


## ,-----
## |	Extract
## +-----

${NTI_BZIP2_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bzip2-${BZIP2_VERSION} ] || rm -rf ${EXTTEMP}/bzip2-${BZIP2_VERSION}
	zcat ${BZIP2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BZIP2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BZIP2_TEMP}
	mv ${EXTTEMP}/bzip2-${BZIP2_VERSION} ${EXTTEMP}/${NTI_BZIP2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BZIP2_CONFIGURED}: ${NTI_BZIP2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BZIP2_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_BZIP2_BUILT}: ${NTI_BZIP2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BZIP2_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BZIP2_INSTALLED}: ${NTI_BZIP2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BZIP2_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-bzip2
nti-bzip2: ${NTI_BZIP2_INSTALLED}

ALL_NTI_TARGETS+= nti-bzip2

endif	# HAVE_BZIP2_CONFIG
