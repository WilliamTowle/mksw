# bochs v20130729		[ since v?.?, c.????-??-?? ]
# last mod WmT, 2013-08-02	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_BOCHS_CONFIG},y)
HAVE_BOCHS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#ifeq (${USE_SDL},true)
#include ${CFG_ROOT}/SDL/v1.2.14.mak
#else
#include ${CFG_ROOT}/libX11/v1.2.2.mak
#endif

DESCRLIST+= "'nti-bochs' -- bochs"

ifeq (${BOCHS_VERSION},)
#BOCHS_VERSION=2.4.5
BOCHS_VERSION=20130729
endif

BOCHS_SRC=${SOURCES}/b/bochs-${BOCHS_VERSION}.tar.gz

#URLS+=http://downloads.sourceforge.net/project/bochs/bochs/2.4.5/bochs-2.4.5.tar.gz?use_mirror=surfnet
URLS+= http://bochs.sourceforge.net/svn-snapshot/bochs-20130729.tar.gz

NTI_BOCHS_TEMP=nti-bochs-${BOCHS_VERSION}

NTI_BOCHS_EXTRACTED=${EXTTEMP}/${NTI_BOCHS_TEMP}/Makefile
NTI_BOCHS_CONFIGURED=${EXTTEMP}/${NTI_BOCHS_TEMP}/config.status
NTI_BOCHS_BUILT=${EXTTEMP}/${NTI_BOCHS_TEMP}/bochs
NTI_BOCHS_INSTALLED=${HTC_ROOT}/usr/bin/bochs


## ,-----
## |	Extract
## +-----


${NTI_BOCHS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/bochs-${BOCHS_VERSION} ] || rm -rf ${EXTTEMP}/bochs-${BOCHS_VERSION}
	zcat ${BOCHS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BOCHS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BOCHS_TEMP}
	mv ${EXTTEMP}/bochs-${BOCHS_VERSION} ${EXTTEMP}/${NTI_BOCHS_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_BOCHS_CONFIGURED}: ${NTI_BOCHS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BOCHS_BUILT}: ${NTI_BOCHS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BOCHS_INSTALLED}: ${NTI_BOCHS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-bochs
nti-bochs: ${NTI_BOCHS_INSTALLED}

ALL_NTI_TARGETS+= nti-bochs

endif	# HAVE_BOCHS_CONFIG
