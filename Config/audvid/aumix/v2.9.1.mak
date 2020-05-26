# aumix v2.9.1			[ EARLIEST v?.?? ]
# last mod WmT, 2012-08-30	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_AUMIX_CONFIG},y)
HAVE_AUMIX_CONFIG:=y

#DESCRLIST+= "'nti-aumix' -- aumix"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${AUMIX_VERSION},)
AUMIX_VERSION=2.9.1
endif
AUMIX_SRC=${SOURCES}/a/aumix-${AUMIX_VERSION}.tar.bz2

URLS+= http://jpj.net/~trevor/aumix/releases/aumix-${AUMIX_VERSION}.tar.bz2

NTI_AUMIX_TEMP=nti-aumix-${AUMIX_VERSION}

NTI_AUMIX_EXTRACTED=${EXTTEMP}/${NTI_AUMIX_TEMP}/Makefile
NTI_AUMIX_CONFIGURED=${EXTTEMP}/${NTI_AUMIX_TEMP}/config.log
NTI_AUMIX_BUILT=${EXTTEMP}/${NTI_AUMIX_TEMP}/src/aumix
NTI_AUMIX_INSTALLED=${NTI_TC_ROOT}/usr/bin/aumix


## ,-----
## |	Extract
## +-----

${NTI_AUMIX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/aumix-${AUMIX_VERSION} ] || rm -rf ${EXTTEMP}/aumix-${AUMIX_VERSION}
	bzcat ${AUMIX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AUMIX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AUMIX_TEMP}
	mv ${EXTTEMP}/aumix-${AUMIX_VERSION} ${EXTTEMP}/${NTI_AUMIX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_AUMIX_CONFIGURED}: ${NTI_AUMIX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AUMIX_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_AUMIX_BUILT}: ${NTI_AUMIX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AUMIX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_AUMIX_INSTALLED}: ${NTI_AUMIX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AUMIX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-aumix
nti-aumix: ${NTI_AUMIX_INSTALLED}

ALL_NTI_TARGETS+= nti-aumix

endif	# HAVE_AUMIX_CONFIG
