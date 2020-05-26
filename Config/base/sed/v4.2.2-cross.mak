# sed v4.2.2			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-06-10	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SED_CONFIG},y)
HAVE_SED_CONFIG:=y

#DESCRLIST+= "'nti-sed' -- sed"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SED_VERSION},)
SED_VERSION=4.2.2
endif

SED_SRC=${SOURCES}/s/sed-${SED_VERSION}.tar.bz2
#SED_SRC=${SOURCES}/s/sed-${SED_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/sed/sed-${SED_VERSION}.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/sed/sed-${SED_VERSION}.tar.gz


CUI_SED_INSTTEMP=${EXTTEMP}/insttemp
CUI_SED_TEMP=cui-sed-${SED_VERSION}

CUI_SED_EXTRACTED=${EXTTEMP}/${CUI_SED_TEMP}/configure
CUI_SED_CONFIGURED=${EXTTEMP}/${CUI_SED_TEMP}/config.status
CUI_SED_BUILT=${EXTTEMP}/${CUI_SED_TEMP}/find/find
CUI_SED_INSTALLED=${CUI_TC_ROOT}/bin/find


NTI_SED_TEMP=nti-sed-${SED_VERSION}

NTI_SED_EXTRACTED=${EXTTEMP}/${NTI_SED_TEMP}/configure
NTI_SED_CONFIGURED=${EXTTEMP}/${NTI_SED_TEMP}/config.status
NTI_SED_BUILT=${EXTTEMP}/${NTI_SED_TEMP}/find/find
NTI_SED_INSTALLED=${NTI_TC_ROOT}/bin/find


## ,-----
## |	Extract
## +-----

${CUI_SED_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/sed-${SED_VERSION} ] || rm -rf ${EXTTEMP}/sed-${SED_VERSION}
	bzcat ${SED_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${SED_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_SED_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SED_TEMP}
	mv ${EXTTEMP}/sed-${SED_VERSION} ${EXTTEMP}/${CUI_SED_TEMP}


${NTI_SED_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/sed-${SED_VERSION} ] || rm -rf ${EXTTEMP}/sed-${SED_VERSION}
	bzcat ${SED_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${SED_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SED_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SED_TEMP}
	mv ${EXTTEMP}/sed-${SED_VERSION} ${EXTTEMP}/${NTI_SED_TEMP}


## ,-----
## |	Configure
## +-----

${CUI_SED_CONFIGURED}: ${CUI_SED_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_SED_TEMP} || exit 1 ;\
		CC=${TARGSPEC}-gcc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${CUI_SED_INSTTEMP}/usr \
			--bindir=${CUI_SED_INSTTEMP}/bin \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			|| exit 1 \
	)

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

${CUI_SED_BUILT}: ${CUI_SED_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CUI_SED_TEMP} || exit 1 ;\
		make \
	)


${NTI_SED_BUILT}: ${NTI_SED_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SED_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CUI_SED_INSTALLED}: ${CUI_SED_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CUI_SED_TEMP} || exit 1 ;\
		make install \
	)


${NTI_SED_INSTALLED}: ${NTI_SED_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SED_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cui-sed
cui-sed: ${CUI_SED_INSTALLED}

ALL_CUI_TARGETS+= cui-sed


.PHONY: nti-sed
nti-sed: ${NTI_SED_INSTALLED}

ALL_NTI_TARGETS+= nti-sed

endif	# HAVE_SED_CONFIG

