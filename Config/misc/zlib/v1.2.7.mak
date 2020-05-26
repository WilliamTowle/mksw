# zlib v1.2.7			[ since v1.1.4, c.2003-06-03 ]
# last mod WmT, 2014-05-27	[ (c) and GPLv2 1999-2014* ]

# 2013-12-24: install w/ LDCONFIG=true

ifneq (${HAVE_ZLIB_CONFIG},y)
HAVE_ZLIB_CONFIG:=y

#DESCRLIST+= "'nti-zlib' -- zlib"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ZLIB_VERSION},)
#ZLIB_VERSION= 1.2.5
ZLIB_VERSION= 1.2.7
endif

#ZLIB_SRC=${SOURCES}/z/zlib-${ZLIB_VERSION}.tar.bz2
ZLIB_SRC=${SOURCES}/z/zlib-${ZLIB_VERSION}.tar.gz
#URLS+= http://sourceforge.net/projects/libpng/files/zlib/1.2.7/zlib-1.2.7.tar.bz2/download
URLS+= 'http://downloads.sourceforge.net/project/libpng/zlib/1.2.7/zlib-1.2.7.tar.gz?r=http%3A%2F%2Fwww.zlib.net%2F&ts=1360672448&use_mirror=switch'

NTI_ZLIB_TEMP=nti-zlib-${ZLIB_VERSION}

NTI_ZLIB_EXTRACTED=${EXTTEMP}/${NTI_ZLIB_TEMP}/configure
NTI_ZLIB_CONFIGURED=${EXTTEMP}/${NTI_ZLIB_TEMP}/zlib.pc
NTI_ZLIB_BUILT=${EXTTEMP}/${NTI_ZLIB_TEMP}/libz.so
NTI_ZLIB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/zlib.pc


## ,-----
## |	Extract
## +-----

${NTI_ZLIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/zlib-${ZLIB_VERSION} ] || rm -rf ${EXTTEMP}/zlib-${ZLIB_VERSION}
	#bzcat ${ZLIB_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${ZLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZLIB_TEMP}
	mv ${EXTTEMP}/zlib-${ZLIB_VERSION} ${EXTTEMP}/${NTI_ZLIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ZLIB_CONFIGURED}: ${NTI_ZLIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--sysconfdir=${NTI_TC_ROOT}/etc \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ZLIB_BUILT}: ${NTI_ZLIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_ZLIB_INSTALLED}: ${NTI_ZLIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZLIB_TEMP} || exit 1 ;\
		make install LDCONFIG=true ;\
		mkdir -p `dirname ${NTI_ZLIB_INSTALLED}` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/zlib.pc ${NTI_ZLIB_INSTALLED} \
	)


##

.PHONY: nti-zlib
nti-zlib: ${NTI_ZLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-zlib

endif	# HAVE_ZLIB_CONFIG
