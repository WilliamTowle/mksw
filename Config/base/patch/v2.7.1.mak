# patch v2.7.1			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-30	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_PATCH_CONFIG},y)
HAVE_PATCH_CONFIG:=y

#DESCRLIST+= "'nti-patch' -- patch"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PATCH_VERSION},)
#PATCH_VERSION=2.5.4
PATCH_VERSION=2.7.1
endif

PATCH_SRC=${SOURCES}/p/patch-${PATCH_VERSION}.tar.bz2
#PATCH_SRC=${SOURCES}/p/patch-${PATCH_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/patch/patch-${PATCH_VERSION}.tar.bz2

NTI_PATCH_TEMP=nti-patch-${PATCH_VERSION}

NTI_PATCH_EXTRACTED=${EXTTEMP}/${NTI_PATCH_TEMP}/configure
NTI_PATCH_CONFIGURED=${EXTTEMP}/${NTI_PATCH_TEMP}/config.status
NTI_PATCH_BUILT=${EXTTEMP}/${NTI_PATCH_TEMP}/src/patch
NTI_PATCH_INSTALLED=${NTI_TC_ROOT}/bin/patch


## ,-----
## |	Extract
## +-----

${NTI_PATCH_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/patch-${PATCH_VERSION} ] || rm -rf ${EXTTEMP}/patch-${PATCH_VERSION}
	bzcat ${PATCH_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${PATCH_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PATCH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PATCH_TEMP}
	mv ${EXTTEMP}/patch-${PATCH_VERSION} ${EXTTEMP}/${NTI_PATCH_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PATCH_CONFIGURED}: ${NTI_PATCH_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PATCH_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PATCH_BUILT}: ${NTI_PATCH_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PATCH_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PATCH_INSTALLED}: ${NTI_PATCH_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PATCH_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-patch
nti-patch: ${NTI_PATCH_INSTALLED}

ALL_NTI_TARGETS+= nti-patch

endif	# HAVE_PATCH_CONFIG
