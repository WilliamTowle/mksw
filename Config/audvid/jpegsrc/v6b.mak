# jpegsrc v6b			[ since v8b, c. 2005-01-07 ]
# last mod WmT, 2013-12-26	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_JPEGSRC_CONFIG},y)
HAVE_JPEGSRC_CONFIG:=y

#DESCRLIST+= "'nti-jpegsrc' -- jpegsrc"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${JPEGSRC_VERSION},)
JPEGSRC_VERSION=6b
# FIXME: versions to at least 8c available
endif
JPEGSRC_SRC=${SOURCES}/j/jpegsrc.v${JPEGSRC_VERSION}.tar.gz

URLS+= http://www.ijg.org/files/jpegsrc.v${JPEGSRC_VERSION}.tar.gz

NTI_JPEGSRC_TEMP=nti-jpegsrc-${JPEGSRC_VERSION}

NTI_JPEGSRC_EXTRACTED=${EXTTEMP}/${NTI_JPEGSRC_TEMP}/README
NTI_JPEGSRC_CONFIGURED=${EXTTEMP}/${NTI_JPEGSRC_TEMP}/config.log
NTI_JPEGSRC_BUILT=${EXTTEMP}/${NTI_JPEGSRC_TEMP}/libjpeg.a
NTI_JPEGSRC_INSTALLED=${NTI_TC_ROOT}/usr/lib/libjpeg.a


## ,-----
## |	Extract
## +-----

${NTI_JPEGSRC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/jpegsrc-${JPEGSRC_VERSION} ] || rm -rf ${EXTTEMP}/jpegsrc-${JPEGSRC_VERSION}
	zcat ${JPEGSRC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_JPEGSRC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_JPEGSRC_TEMP}
	mv ${EXTTEMP}/jpeg-${JPEGSRC_VERSION} ${EXTTEMP}/${NTI_JPEGSRC_TEMP}
#	mv ${EXTTEMP}/jpegsrc-${JPEGSRC_VERSION} ${EXTTEMP}/${NTI_JPEGSRC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_JPEGSRC_CONFIGURED}: ${NTI_JPEGSRC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JPEGSRC_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)

#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_JPEGSRC_BUILT}: ${NTI_JPEGSRC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JPEGSRC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_JPEGSRC_INSTALLED}: ${NTI_JPEGSRC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JPEGSRC_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/include ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib ;\
		make install-headers install-lib \
	)
#	mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
#	mkdir -p ${NTI_TC_ROOT}/usr/man/man1 ;\

##

.PHONY: nti-jpegsrc
nti-jpegsrc: ${NTI_JPEGSRC_INSTALLED}

ALL_NTI_TARGETS+= nti-jpegsrc

endif	# HAVE_JPEGSRC_CONFIG
