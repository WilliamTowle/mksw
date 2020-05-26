# dropbear v2016.74		[ since v0.43, c.2004-10-16 ]
# last mod WmT, 2017-01-05	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DROPBEAR_CONFIG},y)
HAVE_DROPBEAR_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-dropbear' -- dropbear"

ifeq (${DROPBEAR_VERSION},)
#DROPBEAR_VERSION=0.52
#DROPBEAR_VERSION=0.53
#DROPBEAR_VERSION=2012.55
#DROPBEAR_VERSION=2013.58
DROPBEAR_VERSION=2016.74
endif

DROPBEAR_SRC=${SOURCES}/d/dropbear-${DROPBEAR_VERSION}.tar.bz2
#DROPBEAR_SRC=${SOURCES}/d/dropbear-${DROPBEAR_VERSION}.tar.gz
#URLS+=http://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.bz2
URLS+=http://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.gz

NTI_DROPBEAR_TEMP=nti-dropbear-${DROPBEAR_VERSION}
#NTI_DROPBEAR_INSTTEMP=${EXTTEMP}/insttemp

NTI_DROPBEAR_EXTRACTED=${EXTTEMP}/${NTI_DROPBEAR_TEMP}/configure
NTI_DROPBEAR_CONFIGURED=${EXTTEMP}/${NTI_DROPBEAR_TEMP}/config.status
NTI_DROPBEAR_BUILT=${EXTTEMP}/${NTI_DROPBEAR_TEMP}/dropbearconvert
NTI_DROPBEAR_INSTALLED=${NTI_TC_ROOT}/usr/bin/dropbearconvert


# ,-----
# |	Extract
# +-----


${NTI_DROPBEAR_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/dropbear-${DROPBEAR_VERSION} ] || rm -rf ${EXTTEMP}/dropbear-${DROPBEAR_VERSION}
	bzcat ${DROPBEAR_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${DROPBEAR_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DROPBEAR_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DROPBEAR_TEMP}
	mv ${EXTTEMP}/dropbear-${DROPBEAR_VERSION} ${EXTTEMP}/${NTI_DROPBEAR_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_DROPBEAR_CONFIGURED}: ${NTI_DROPBEAR_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DROPBEAR_TEMP} || exit 1 ;\
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)


# ,-----
# |	Build
# +-----

${NTI_DROPBEAR_BUILT}: ${NTI_DROPBEAR_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DROPBEAR_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

${NTI_DROPBEAR_INSTALLED}: ${NTI_DROPBEAR_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DROPBEAR_TEMP} || exit 1 ;\
		make install || exit 1 ;\
	) || exit 1

##

.PHONY: nti-dropbear
nti-dropbear: ${NTI_DROPBEAR_INSTALLED}
#cui-dropbear: cti-cross-gcc cti-zlib cui-uClibc-rt cui-dropbear-installed

ALL_NTI_TARGETS+= nti-dropbear

endif	# HAVE_DROPBEAR_CONFIG
