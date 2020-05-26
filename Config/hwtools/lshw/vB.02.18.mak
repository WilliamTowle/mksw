# lshw vB.02.18			[ since vB.02.16, 2013-05-01 ]
# last mod WmT, 2016-05-09	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_LSHW_CONFIG},y)
HAVE_LSHW_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-lshw' -- lshw"
#DESCRLIST+= "'nti-lshw' -- lshw"

ifeq (${LSHW_VERSION},)
#LSHW_VERSION=B.02.16
LSHW_VERSION=B.02.18
endif

LSHW_SRC=${SOURCES}/l/lshw-${LSHW_VERSION}.tar.gz
#URLS+= http://ezix.org/software/files/lshw-B.02.16.tar.gz
URLS+= http://ezix.org/software/files/lshw-${LSHW_VERSION}.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.16.2.mak

CUI_LSHW_TEMP=cui-lshw-${LSHW_VERSION}
CUI_LSHW_INSTTEMP=${EXTTEMP}/insttemp-cui

CUI_LSHW_EXTRACTED=${EXTTEMP}/${CUI_LSHW_TEMP}/COPYING
CUI_LSHW_CONFIGURED=${EXTTEMP}/${CUI_LSHW_TEMP}/.configure.done
CUI_LSHW_BUILT=${EXTTEMP}/${CUI_LSHW_TEMP}/src/lshw
CUI_LSHW_INSTALLED=${CUI_LSHW_INSTTEMP}/usr/sbin/lshw


NTI_LSHW_TEMP=nti-lshw-${LSHW_VERSION}

NTI_LSHW_EXTRACTED=${EXTTEMP}/${NTI_LSHW_TEMP}/COPYING
NTI_LSHW_CONFIGURED=${EXTTEMP}/${NTI_LSHW_TEMP}/.configure.done
NTI_LSHW_BUILT=${EXTTEMP}/${NTI_LSHW_TEMP}/src/lshw
NTI_LSHW_INSTALLED=${NTI_TC_ROOT}/usr/sbin/lshw


## ,-----
## |	Extract
## +-----

${CUI_LSHW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lshw-${LSHW_VERSION} ] || rm -rf ${EXTTEMP}/lshw-${LSHW_VERSION}
	zcat ${LSHW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_LSHW_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_LSHW_TEMP}
	mv ${EXTTEMP}/lshw-${LSHW_VERSION} ${EXTTEMP}/${CUI_LSHW_TEMP}

##

${NTI_LSHW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lshw-${LSHW_VERSION} ] || rm -rf ${EXTTEMP}/lshw-${LSHW_VERSION}
	zcat ${LSHW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LSHW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LSHW_TEMP}
	mv ${EXTTEMP}/lshw-${LSHW_VERSION} ${EXTTEMP}/${NTI_LSHW_TEMP}


## ,-----
## |	Configure
## +-----

${CUI_LSHW_CONFIGURED}: ${CUI_LSHW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_LSHW_TEMP} || exit 1 ;\
		case ${LSHW_VERSION} in \
		B.02.18) \
			for MF in src/Makefile src/core/Makefile ; do \
				[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
				cat $${MF}.OLD \
					| sed '/^PREFIX[?=]/	s%/usr%'${CUI_LSHW_INSTTEMP}'/usr%' \
					| sed '/^CXX[?=]/		s%g*c++%'${TARGSPEC}'-g++%' \
					> $${MF} ;\
			done \
		;; \
		esac ;\
		touch $@ \
	)


${NTI_LSHW_CONFIGURED}: ${NTI_LSHW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		case ${LSHW_VERSION} in \
		B.02.18) \
			[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
			cat src/Makefile.OLD \
				| sed '/^PREFIX?/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
				> src/Makefile \
		;; \
		esac ;\
		touch $@ \
	)


## ,-----
## |	Build
## +-----

${CUI_LSHW_BUILT}: ${CUI_LSHW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_LSHW_TEMP} || exit 1 ;\
		make \
	)

##

${NTI_LSHW_BUILT}: ${NTI_LSHW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CUI_LSHW_INSTALLED}: ${CUI_LSHW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_LSHW_TEMP} || exit 1 ;\
		make install \
	)

${NTI_LSHW_INSTALLED}: ${NTI_LSHW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cui-lshw
cui-lshw: ${CUI_LSHW_INSTALLED}

ALL_CUI_TARGETS+= cui-lshw


.PHONY: nti-lshw
nti-lshw: ${NTI_LSHW_INSTALLED}

ALL_NTI_TARGETS+= nti-lshw

endif	# HAVE_LSHW_CONFIG
