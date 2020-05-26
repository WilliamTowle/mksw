# tscat v1.0			[ since v1.0, 2006-02-25 ]
# last mod WmT, 2017-03-09	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_TSCAT},y)
HAVE_TSCAT:=y

#DESCRLIST+= "'nti-fftw' -- fftw"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TSCAT_VERSION},)
TSCAT_VERSION=1.0
endif

TSCAT_SRC=${SOURCES}/t/tscat-${TSCAT_VERSION}.tar.gz
URLS+= http://www.gerg.ca/software/tscat/tscat-1.0.tar.gz

# build deps
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

# misc deps?

NTI_TSCAT_TEMP=nti-tscat-${TSCAT_VERSION}

NTI_TSCAT_EXTRACTED=${EXTTEMP}/${NTI_TSCAT_TEMP}/README
NTI_TSCAT_CONFIGURED=${EXTTEMP}/${NTI_TSCAT_TEMP}/Makefile.OLD
NTI_TSCAT_BUILT=${EXTTEMP}/${NTI_TSCAT_TEMP}/tscat
NTI_TSCAT_INSTALLED=${NTI_TC_ROOT}/usr/bin/tscat


## ,-----
## |	Extract
## +-----

${NTI_TSCAT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tscat-${TSCAT_VERSION} ] || rm -rf ${EXTTEMP}/tscat-${TSCAT_VERSION}
	zcat ${TSCAT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TSCAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TSCAT_TEMP}
	mv ${EXTTEMP}/tscat-${TSCAT_VERSION} ${EXTTEMP}/${NTI_TSCAT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TSCAT_CONFIGURED}: ${NTI_TSCAT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TSCAT_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_TSCAT_BUILT}: ${NTI_TSCAT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TSCAT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TSCAT_INSTALLED}: ${NTI_TSCAT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TSCAT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-tscat
#nti-tscat: nti-pkg-config ${NTI_TSCAT_INSTALLED}
nti-tscat: ${NTI_TSCAT_INSTALLED}

ALL_NTI_TARGETS+= nti-tscat

endif	# HAVE_TSCAT_CONFIG
