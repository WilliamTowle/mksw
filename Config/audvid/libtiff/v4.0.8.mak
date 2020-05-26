# tiff v4.0.8			[ since v3.9.4, c. 2010-06-28 ]
# last mod WmT, 2017-09-06	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_LIBTIFF_CONFIG},y)
HAVE_LIBTIFF_CONFIG:=y

#DESCRLIST+= "'nti-libtiff' -- tiff"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBTIFF_VERSION},)
#LIBTIFF_VERSION=3.8.2
#LIBTIFF_VERSION=3.9.5
#LIBTIFF_VERSION=4.0.3
LIBTIFF_VERSION=4.0.8
endif

LIBTIFF_SRC=${SOURCES}/t/tiff-${LIBTIFF_VERSION}.tar.gz
#URLS+= ftp://ftp.remotesensing.org/pub/tiff/tiff-${LIBTIFF_VERSION}.tar.gz
URLS+= http://download.osgeo.org/libtiff/tiff-${LIBTIFF_VERSION}.tar.gz

NTI_LIBTIFF_TEMP=nti-libtiff-${LIBTIFF_VERSION}

NTI_LIBTIFF_EXTRACTED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/README
NTI_LIBTIFF_CONFIGURED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/config.status
NTI_LIBTIFF_BUILT=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/tools/tiffmedian
NTI_LIBTIFF_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libtiff-4.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBTIFF_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tiff-${LIBTIFF_VERSION} ] || rm -rf ${EXTTEMP}/tiff-${LIBTIFF_VERSION}
	zcat ${LIBTIFF_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBTIFF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTIFF_TEMP}
	mv ${EXTTEMP}/tiff-${LIBTIFF_VERSION} ${EXTTEMP}/${NTI_LIBTIFF_TEMP}


## ,-----
## |	Configure
## +-----

# tiff has no dependencies to recover from pkg-config
${NTI_LIBTIFF_CONFIGURED}: ${NTI_LIBTIFF_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-cxx \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBTIFF_BUILT}: ${NTI_LIBTIFF_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBTIFF_INSTALLED}: ${NTI_LIBTIFF_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
		make install ;\
		mkdir -p `dirname ${NTI_LIBTIFF_INSTALLED}` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/libtiff-4.pc ${NTI_LIBTIFF_INSTALLED} \
	)

##

.PHONY: nti-libtiff
nti-libtiff: ${NTI_LIBTIFF_INSTALLED}

ALL_NTI_TARGETS+= nti-libtiff

endif	# HAVE_LIBTIFF_CONFIG
