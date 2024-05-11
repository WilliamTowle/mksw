# ftgl v2.1.3-rc5		[ since v2.1.3-rc5, c.2010-07-30 ]
# last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_FTGL_CONFIG},y)
HAVE_FTGL_CONFIG:=y

#DESCRLIST+= "'nti-ftgl' -- ftgl"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${FTGL_VERSION},)
FTGL_VERSION=2.1.3-rc5
endif

FTGL_SRC=${SOURCES}/f/ftgl-2.1.3-rc5.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz?use_mirror=netcologne&ts=1280489540'

include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
#include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak
include ${CFG_ROOT}/gui/libgl-mesa/v17.0.0.mak

NTI_FTGL_TEMP=nti-ftgl-${FTGL_VERSION}

NTI_FTGL_EXTRACTED=${EXTTEMP}/${NTI_FTGL_TEMP}/README
NTI_FTGL_CONFIGURED=${EXTTEMP}/${NTI_FTGL_TEMP}/config.status
NTI_FTGL_BUILT=${EXTTEMP}/${NTI_FTGL_TEMP}/lib/ftgl.la
NTI_FTGL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ftgl.pc


## ,-----
## |	Extract
## +-----

${NTI_FTGL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/ftgl-${FTGL_VERSION} ] || rm -rf ${EXTTEMP}/ftgl-${FTGL_VERSION}
	[ ! -d ${EXTTEMP}/ftgl-2.1.3~rc5 ] || rm -rf ${EXTTEMP}/ftgl-2.1.3~rc5
	zcat ${FTGL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FTGL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FTGL_TEMP}
	#mv ${EXTTEMP}/ftgl-${FTGL_VERSION} ${EXTTEMP}/${NTI_FTGL_TEMP}
	mv ${EXTTEMP}/ftgl-2.1.3~rc5 ${EXTTEMP}/${NTI_FTGL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FTGL_CONFIGURED}: ${NTI_FTGL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FTGL_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^SUBDIRS/	s/doc *//' \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FTGL_BUILT}: ${NTI_FTGL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FTGL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FTGL_INSTALLED}: ${NTI_FTGL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FTGL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ftgl
#nti-ftgl: nti-libtool nti-pkg-config \
#	nti-libogg \
#	${NTI_FTGL_INSTALLED}
nti-ftgl: \
	nti-freetype2 nti-libgl-mesa \
	${NTI_FTGL_INSTALLED}

ALL_NTI_TARGETS+= nti-ftgl

endif	# HAVE_FTGL_CONFIG
