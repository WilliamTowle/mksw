# ftgl v2.1.2			[ since v2.1.3-rc5, c.2010-07-30 ]
# last mod WmT, 2017-08-21	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_FTGL_CONFIG},y)
HAVE_FTGL_CONFIG:=y

#DESCRLIST+= "'nti-ftgl' -- ftgl"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${FTGL_VERSION},)
FTGL_VERSION=2.1.2
#FTGL_VERSION=2.1.3-rc5
endif

FTGL_SRC=${SOURCES}/f/ftgl-${FTGL_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/ftgl/FTGL%20Source/${FTGL_VERSION}/ftgl-${FTGL_VERSION}.tar.gz
#URLS+= 'http://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz?use_mirror=netcologne&ts=1280489540'

include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
#include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak

NTI_FTGL_TEMP=nti-ftgl-${FTGL_VERSION}

NTI_FTGL_EXTRACTED=${EXTTEMP}/${NTI_FTGL_TEMP}/README.txt
NTI_FTGL_CONFIGURED=${EXTTEMP}/${NTI_FTGL_TEMP}/unix/config.status
NTI_FTGL_BUILT=${EXTTEMP}/${NTI_FTGL_TEMP}/unix/src/libftgl.la
NTI_FTGL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ftgl.pc


## ,-----
## |	Extract
## +-----

${NTI_FTGL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/FTGL ] || rm -rf ${EXTTEMP}/FTGL
	#[ ! -d ${EXTTEMP}/ftgl-2.1.3~rc5 ] || rm -rf ${EXTTEMP}/ftgl-2.1.3~rc5
	zcat ${FTGL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FTGL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FTGL_TEMP}
	mv ${EXTTEMP}/FTGL ${EXTTEMP}/${NTI_FTGL_TEMP}
	#mv ${EXTTEMP}/ftgl-2.1.3~rc5 ${EXTTEMP}/${NTI_FTGL_TEMP}


## ,-----
## |	Configure
## +-----

## NB: "fixes" for v2.1.2

${NTI_FTGL_CONFIGURED}: ${NTI_FTGL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FTGL_TEMP} || exit 1 ;\
		[ -r include/FTTextureGlyph.h.OLD ] || cp include/FTTextureGlyph.h include/FTTextureGlyph.h.OLD || exit 1 ;\
		cat include/FTTextureGlyph.h.OLD \
			| sed '/class FTGL_EXPORT FTTextureGlyph/,/^};$$/	s/FTTextureGlyph:://' \
			> include/FTTextureGlyph.h ;\
		[ -r unix/Makefile.OLD ] || cp unix/Makefile unix/Makefile.OLD || exit 1 ;\
		cat unix/Makefile.OLD \
			| sed '/install-local:/,/^$$/	s%$$(libdir).*%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> unix/Makefile ;\
		cd unix || exit 1 ;\
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
		make -C unix \
	)


## ,-----
## |	Install
## +-----

# [v2.1.2] install (-> install.recursive) target broken

${NTI_FTGL_INSTALLED}: ${NTI_FTGL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FTGL_TEMP} || exit 1 ;\
		make -C unix/src install-local || exit 1 ;\
		make -C unix install-local || exit 1 \
	)

##

.PHONY: nti-ftgl
nti-ftgl: nti-pkg-config \
	nti-freetype2 \
	${NTI_FTGL_INSTALLED}

ALL_NTI_TARGETS+= nti-ftgl

endif	# HAVE_FTGL_CONFIG
