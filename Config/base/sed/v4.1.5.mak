# sed v4.1.5			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-30	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SED_CONFIG},y)
HAVE_SED_CONFIG:=y

#DESCRLIST+= "'nti-sed' -- sed"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SED_VERSION},)
SED_VERSION=4.1.5
endif

SED_SRC=${SOURCES}/s/sed-${SED_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/sed/sed-${SED_VERSION}.tar.bz2


NTI_SED_TEMP=nti-sed-${SED_VERSION}

NTI_SED_EXTRACTED=${EXTTEMP}/${NTI_SED_TEMP}/configure
NTI_SED_CONFIGURED=${EXTTEMP}/${NTI_SED_TEMP}/config.status
NTI_SED_BUILT=${EXTTEMP}/${NTI_SED_TEMP}/sed/sed
NTI_SED_INSTALLED=${NTI_TC_ROOT}/bin/sed


## ,-----
## |	Extract
## +-----

${NTI_SED_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/sed-${SED_VERSION} ] || rm -rf ${EXTTEMP}/sed-${SED_VERSION}
	zcat ${SED_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SED_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SED_TEMP}
	mv ${EXTTEMP}/sed-${SED_VERSION} ${EXTTEMP}/${NTI_SED_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SED_CONFIGURED}: ${NTI_SED_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SED_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SED_BUILT}: ${NTI_SED_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SED_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SED_INSTALLED}: ${NTI_SED_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SED_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-sed
nti-sed: ${NTI_SED_INSTALLED}

ALL_NTI_TARGETS+= nti-sed

endif	# HAVE_SED_CONFIG
