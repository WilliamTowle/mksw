# diffutils v3.3			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-06-10	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_DIFFUTILS_CONFIG},y)
HAVE_DIFFUTILS_CONFIG:=y

#DESCRLIST+= "'nti-diffutils' -- diffutils"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DIFFUTILS_VERSION},)
DIFFUTILS_VERSION=3.3
endif

#DIFFUTILS_SRC=${SOURCES}/d/diffutils-${DIFFUTILS_VERSION}.tar.bz2
#DIFFUTILS_SRC=${SOURCES}/d/diffutils-${DIFFUTILS_VERSION}.tar.gz
DIFFUTILS_SRC=${SOURCES}/d/diffutils-${DIFFUTILS_VERSION}.tar.xz
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/diffutils/diffutils-${DIFFUTILS_VERSION}.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/diffutils/diffutils-${DIFFUTILS_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/diffutils/diffutils-${DIFFUTILS_VERSION}.tar.xz


CUI_DIFFUTILS_INSTTEMP=${EXTTEMP}/insttemp
CUI_DIFFUTILS_TEMP=cui-diffutils-${DIFFUTILS_VERSION}

CUI_DIFFUTILS_EXTRACTED=${EXTTEMP}/${CUI_DIFFUTILS_TEMP}/configure
CUI_DIFFUTILS_CONFIGURED=${EXTTEMP}/${CUI_DIFFUTILS_TEMP}/config.status
CUI_DIFFUTILS_BUILT=${EXTTEMP}/${CUI_DIFFUTILS_TEMP}/find/find
CUI_DIFFUTILS_INSTALLED=${CUI_TC_ROOT}/bin/find


NTI_DIFFUTILS_TEMP=nti-diffutils-${DIFFUTILS_VERSION}

NTI_DIFFUTILS_EXTRACTED=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/configure
NTI_DIFFUTILS_CONFIGURED=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/config.status
NTI_DIFFUTILS_BUILT=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/find/find
NTI_DIFFUTILS_INSTALLED=${NTI_TC_ROOT}/bin/find


## ,-----
## |	Extract
## +-----

${CUI_DIFFUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ] || rm -rf ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION}
	#bzcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_DIFFUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_DIFFUTILS_TEMP}
	mv ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ${EXTTEMP}/${CUI_DIFFUTILS_TEMP}


${NTI_DIFFUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ] || rm -rf ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION}
	#bzcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIFFUTILS_TEMP}
	mv ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ${EXTTEMP}/${NTI_DIFFUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${CUI_DIFFUTILS_CONFIGURED}: ${CUI_DIFFUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DIFFUTILS_TEMP} || exit 1 ;\
		CC=${TARGSPEC}-gcc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${CUI_DIFFUTILS_INSTTEMP}/usr \
			--bindir=${CUI_DIFFUTILS_INSTTEMP}/bin \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			|| exit 1 \
	)

${NTI_DIFFUTILS_CONFIGURED}: ${NTI_DIFFUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)



## ,-----
## |	Build
## +-----

${CUI_DIFFUTILS_BUILT}: ${CUI_DIFFUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DIFFUTILS_TEMP} || exit 1 ;\
		make \
	)


${NTI_DIFFUTILS_BUILT}: ${NTI_DIFFUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CUI_DIFFUTILS_INSTALLED}: ${CUI_DIFFUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DIFFUTILS_TEMP} || exit 1 ;\
		make install \
	)


${NTI_DIFFUTILS_INSTALLED}: ${NTI_DIFFUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cui-diffutils
cui-diffutils: ${CUI_DIFFUTILS_INSTALLED}

ALL_CUI_TARGETS+= cui-diffutils


.PHONY: nti-diffutils
nti-diffutils: ${NTI_DIFFUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-diffutils

endif	# HAVE_DIFFUTILS_CONFIG
