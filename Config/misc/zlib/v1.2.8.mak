# zlib v1.2.8			[ since v1.1.4, c.2003-06-03 ]
# last mod WmT, 2015-09-30	[ (c) and GPLv2 1999-2015* ]

# [2013-12-24] install w/ LDCONFIG=true
# [2013-12-24] buildroot suggests '--shared' and CFLAGS='...-fPIC...'
 
ifneq (${HAVE_ZLIB_CONFIG},y)
HAVE_ZLIB_CONFIG:=y

#DESCRLIST+= "'nti-zlib' -- zlib"
#DESCRLIST+= "'cti-zlib' -- zlib"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ZLIB_VERSION},)
#ZLIB_VERSION= 1.2.5
#ZLIB_VERSION= 1.2.7
ZLIB_VERSION= 1.2.8
endif

ZLIB_SRC=${SOURCES}/z/zlib-${ZLIB_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/libpng/zlib/${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.gz?use_mirror=ignum


CTI_ZLIB_TEMP=cti-zlib-${ZLIB_VERSION}

CTI_ZLIB_EXTRACTED=${EXTTEMP}/${CTI_ZLIB_TEMP}/configure
CTI_ZLIB_CONFIGURED=${EXTTEMP}/${CTI_ZLIB_TEMP}/zlib.pc
CTI_ZLIB_BUILT=${EXTTEMP}/${CTI_ZLIB_TEMP}/example
CTI_ZLIB_INSTALLED=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/zlib.pc


NTI_ZLIB_TEMP=nti-zlib-${ZLIB_VERSION}

NTI_ZLIB_EXTRACTED=${EXTTEMP}/${NTI_ZLIB_TEMP}/configure
NTI_ZLIB_CONFIGURED=${EXTTEMP}/${NTI_ZLIB_TEMP}/zlib.pc
NTI_ZLIB_BUILT=${EXTTEMP}/${NTI_ZLIB_TEMP}/example
NTI_ZLIB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/zlib.pc


## ,-----
## |	Extract
## +-----

${CTI_ZLIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/zlib-${ZLIB_VERSION} ] || rm -rf ${EXTTEMP}/zlib-${ZLIB_VERSION}
	zcat ${ZLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_ZLIB_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_ZLIB_TEMP}
	mv ${EXTTEMP}/zlib-${ZLIB_VERSION} ${EXTTEMP}/${CTI_ZLIB_TEMP}

##

${NTI_ZLIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/zlib-${ZLIB_VERSION} ] || rm -rf ${EXTTEMP}/zlib-${ZLIB_VERSION}
	zcat ${ZLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZLIB_TEMP}
	mv ${EXTTEMP}/zlib-${ZLIB_VERSION} ${EXTTEMP}/${NTI_ZLIB_TEMP}



## ,-----
## |	Configure
## +-----

## [2014-07-24] v1.2.8 ignores --sysconfdir
## [2015-09-29] just set CC= (no --{build|host}) for cross compilation

${CTI_ZLIB_CONFIGURED}: ${CTI_ZLIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_ZLIB_TEMP} || exit 1 ;\
		CC=${CUI_GCC} \
		CFLAGS='-O2 -fPIC' \
		  ./configure \
			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--shared \
			|| exit 1 \
	)

##

${NTI_ZLIB_CONFIGURED}: ${NTI_ZLIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2 -fPIC' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--shared \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${CTI_ZLIB_BUILT}: ${CTI_ZLIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_ZLIB_TEMP} || exit 1 ;\
		make all \
	)

##

${NTI_ZLIB_BUILT}: ${NTI_ZLIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${CTI_ZLIB_INSTALLED}: ${CTI_ZLIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_ZLIB_TEMP} || exit 1 ;\
		make install LDCONFIG=true pkgconfigdir=`dirname ${CTI_ZLIB_INSTALLED}` \
	)


.PHONY: cti-zlib
cti-zlib: ${CTI_ZLIB_INSTALLED}

ALL_CTI_TARGETS+= cti-zlib

##

${NTI_ZLIB_INSTALLED}: ${NTI_ZLIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		make install LDCONFIG=true pkgconfigdir=`dirname ${NTI_ZLIB_INSTALLED}` \
	)


.PHONY: nti-zlib
nti-zlib: ${NTI_ZLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-zlib

endif	# HAVE_ZLIB_CONFIG
