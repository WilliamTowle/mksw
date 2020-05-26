# freefile v1.8			[ since v1.18, c.2003-05-10 ]
# last mod WmT, 2014-03-28	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FREEFILE_CONFIG},y)
HAVE_FREEFILE_CONFIG:=y

#DESCRLIST+= "'nti-freefile' -- freefile"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FREEFILE_VERSION},)
FREEFILE_VERSION=1.8
endif
FREEFILE_SRC=${SOURCES}/f/freefile-${FREEFILE_VERSION}.tar.gz

URLS+= http://www.ibiblio.org/pub/Linux/utils/file/freefile-1.8.tar.gz

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_FREEFILE_TEMP=nti-freefile-${FREEFILE_VERSION}

NTI_FREEFILE_EXTRACTED=${EXTTEMP}/${NTI_FREEFILE_TEMP}/file.h
NTI_FREEFILE_CONFIGURED=${EXTTEMP}/${NTI_FREEFILE_TEMP}/Makefile.OLD
NTI_FREEFILE_BUILT=${EXTTEMP}/${NTI_FREEFILE_TEMP}/file
NTI_FREEFILE_INSTALLED=${NTI_TC_ROOT}/usr/bin/freefile


## ,-----
## |	Extract
## +-----

${NTI_FREEFILE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/freefile-${FREEFILE_VERSION} ] || rm -rf ${EXTTEMP}/freefile-${FREEFILE_VERSION}
	zcat ${FREEFILE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FREEFILE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FREEFILE_TEMP}
	mv ${EXTTEMP}/freefile-${FREEFILE_VERSION} ${EXTTEMP}/${NTI_FREEFILE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FREEFILE_CONFIGURED}: ${NTI_FREEFILE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FREEFILE_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^prefix=/ s%=.*%='${NTI_TC_ROOT}'/usr%' \
			| sed '/^PROG=/	s%$$%\nCC= '${NUI_CC_PREFIX}'cc%' \
			| sed '/^	install.*PROG/	s%$$(BINDIR)%$$(BINDIR)/freefile%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_FREEFILE_BUILT}: ${NTI_FREEFILE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FREEFILE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FREEFILE_INSTALLED}: ${NTI_FREEFILE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FREEFILE_TEMP} || exit 1 ;\
		make install ;\
		cd ${NTI_TC_ROOT}/usr/bin && ln -sf freefile file \
	)

##

.PHONY: nti-freefile
nti-freefile: nti-flex ${NTI_FREEFILE_INSTALLED}

ALL_NTI_TARGETS+= nti-freefile

endif	# HAVE_FREEFILE_CONFIG
