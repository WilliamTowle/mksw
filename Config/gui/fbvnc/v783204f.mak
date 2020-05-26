# fbvnc v783204f		[ EARLIEST v783204f, 2014-03-15 ]
# last mod WmT, 2014-03-19	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FBVNC_CONFIG},y)
HAVE_FBVNC_CONFIG:=y

#DESCRLIST+= "'nti-fbvnc' -- fbvnc"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

ifeq (${FBVNC_VERSION},)
FBVNC_VERSION=783204f
endif

FBVNC_SRC=${SOURCES}/f/fbvnc-${FBVNC_VERSION}.tar.gz
URLS+= https://github.com/zohead/fbvnc/archive/783204ff6c92afec33d6d36f7e74f1fcf2b1b601.tar.gz

NTI_FBVNC_TEMP=nti-fbvnc-${FBVNC_VERSION}

NTI_FBVNC_EXTRACTED=${EXTTEMP}/${NTI_FBVNC_TEMP}/README.md
NTI_FBVNC_CONFIGURED=${EXTTEMP}/${NTI_FBVNC_TEMP}/Makefile.OLD
NTI_FBVNC_BUILT=${EXTTEMP}/${NTI_FBVNC_TEMP}/fbvnc
NTI_FBVNC_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/fbvnc


## ,-----
## |	Extract
## +-----

${NTI_FBVNC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fbvnc-${FBVNC_VERSION} ] || rm -rf ${EXTTEMP}/fbvnc-${FBVNC_VERSION}
	zcat ${FBVNC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FBVNC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FBVNC_TEMP}
	mv ${EXTTEMP}/fbvnc-783204ff6c92afec33d6d36f7e74f1fcf2b1b601 ${EXTTEMP}/${NTI_FBVNC_TEMP}
	#mv ${EXTTEMP}/fbvnc-${FBVNC_VERSION} ${EXTTEMP}/${NTI_FBVNC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FBVNC_CONFIGURED}: ${NTI_FBVNC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBVNC_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC *=/	{ s%g*cc%'${NTI_GCC}'% }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_FBVNC_BUILT}: ${NTI_FBVNC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBVNC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FBVNC_INSTALLED}: ${NTI_FBVNC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBVNC_TEMP} || exit 1 ;\
		echo 'No install rule provided...' ; exit 1 ;\
		make install \
	)

##

.PHONY: nti-fbvnc
nti-fbvnc: ${NTI_FBVNC_INSTALLED}
#nti-fbvnc: nti-SDL ${NTI_FBVNC_INSTALLED}

ALL_NTI_TARGETS+= nti-fbvnc

endif	# HAVE_FBVNC_CONFIG
