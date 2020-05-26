# views v0.3beta		[ EARLIEST v?.?? ]
# last mod WmT, 2014-03-12	[ (c) and GPLv2 1999-2014 ]

#ifneq (${HAVE_VIEWS_CONFIG},y)
#HAVE_VIEWS_CONFIG:=y
#
#DESCRLIST+= "'nti-views' -- views"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
#endif
#
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak
#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#include ${CFG_ROOT}/gui/SDL_image/v1.2.10.mak
##else
##include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#endif
#
#VIEWS_VER=0.3beta
#VIEWS_SRC=${SRCDIR}/v/views-0.3beta.tar.gz
#
#URLS+= http://www.referee.at/unix/views/download/views-0.3beta.tar.gz
#
#
### ,-----
### |	Extract
### +-----
#
#CUI_VIEWS_TEMP=cui-views-${VIEWS_VER}
#CUI_VIEWS_INSTTEMP=${EXTTEMP}/insttemp
#
#CUI_VIEWS_EXTRACTED=${EXTTEMP}/${CUI_VIEWS_TEMP}/Makefile
#
#.PHONY: cui-views-extracted
#cui-views-extracted: ${CUI_VIEWS_EXTRACTED}
#
#${CUI_VIEWS_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${CUI_VIEWS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_VIEWS_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${VIEWS_SRC}
#	mv ${EXTTEMP}/views ${EXTTEMP}/${CUI_VIEWS_TEMP}
#
###
#
#NTI_VIEWS_TEMP=nti-views-${VIEWS_VER}
#
#NTI_VIEWS_EXTRACTED=${EXTTEMP}/${NTI_VIEWS_TEMP}/Makefile
#
#.PHONY: nti-views-extracted
#nti-views-extracted: ${NTI_VIEWS_EXTRACTED}
#
#${NTI_VIEWS_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${NTI_VIEWS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VIEWS_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${VIEWS_SRC}
#	mv ${EXTTEMP}/views ${EXTTEMP}/${NTI_VIEWS_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#CUI_VIEWS_CONFIGURED=${EXTTEMP}/${CUI_VIEWS_TEMP}/config.status
#
#.PHONY: cui-views-configured
#
#cui-views-configured: cui-views-extracted ${CUI_VIEWS_CONFIGURED}
#
#${CUI_VIEWS_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CTI_VIEWS_TEMP} || exit 1 ;\
#		CC=${CTI_GCC} \
#		  CFLAGS='-O2' \
#		  LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
#		  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
#			./configure \
#			  --prefix=/usr \
#			  --build=${NTI_SPEC} \
#			  --host=${CTI_SPEC} \
#			  || exit 1 \
#	)
#
###
#
#NTI_VIEWS_CONFIGURED=${EXTTEMP}/${NTI_VIEWS_TEMP}/config.status
#
#.PHONY: nti-views-configured
#nti-views-configured: nti-views-extracted ${NTI_VIEWS_CONFIGURED}
#
#${NTI_VIEWS_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
#	  CC=${NTI_GCC} \
#	  CFLAGS='-O2' \
#	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
#		./configure \
#			--prefix=${NTI_TC_ROOT}/usr/ \
#			|| exit 1 \
#	)
#
#
### ,-----
### |	Build
### +-----
#
#CUI_VIEWS_BUILT=${EXTTEMP}/${CUI_VIEWS_TEMP}/src/views
#
#.PHONY: cui-views-built
#cui-views-built: cui-views-configured ${CUI_VIEWS_BUILT}
#
#${CUI_VIEWS_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_VIEWS_TEMP} || exit 1 ;\
#		make || exit 1 \
#	)
#
#
###
#
#NTI_VIEWS_BUILT=${EXTTEMP}/${NTI_VIEWS_TEMP}/src/views
#
#.PHONY: nti-views-built
#nti-views-built: nti-views-configured ${NTI_VIEWS_BUILT}
#
#${NTI_VIEWS_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
#		make || exit 1 \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#CUI_VIEWS_INSTALLED=${CUI_VIEWS_INSTTEMP}/usr/bin/views
#
#.PHONY: cui-views-installed
#cui-views-installed: cui-views-built ${CUI_VIEWS_INSTALLED}
#
#${CUI_VIEWS_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	mkdir -p ${CUI_VIEWS_INSTTEMP}/usr/bin
#	( cd ${EXTTEMP}/${CUI_VIEWS_TEMP} || exit 1 ;\
#		make DESTDIR=${CUI_VIEWS_INSTTEMP} install || exit 1 \
#	)
#
###
#
#NTI_VIEWS_INSTALLED=${NTI_TC_ROOT}/usr/bin/views
#
#.PHONY: nti-views-installed
#nti-views-installed: nti-views-built ${NTI_VIEWS_INSTALLED}
#
#${NTI_VIEWS_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
#		make install || exit 1 \
#	)
#
###
#
#.PHONY: cui-views
#cui-views: cti-cross-gcc cti-SDL cui-SDL cui-views-installed
#
#CTARGETS+= cui-views
#
#.PHONY: nti-views
#nti-views: nti-native-gcc nti-SDL nti-SDL_image nti-views-installed
#
#NTARGETS+= nti-views
#
#endif	# HAVE_VIEWS_CONFIG

ifneq (${HAVE_VIEWS_CONFIG},y)
HAVE_VIEWS_CONFIG:=y

#DESCRLIST+= "'nti-views' -- views"

include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
#include ${CFG_ROOT}/audvid/libpng/v1.2.33.mak
include ${CFG_ROOT}/audvid/libpng/v1.4.12.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak

ifeq (${VIEWS_VERSION},)
VIEWS_VERSION=0.3beta
endif
VIEWS_SRC=${SOURCES}/z/views-${VIEWS_VERSION}.tar.gz

URLS+= http://www.referee.at/unix/views/download/views-0.3beta.tar.gz

NTI_VIEWS_TEMP=nti-views-${VIEWS_VERSION}

NTI_VIEWS_EXTRACTED=${EXTTEMP}/${NTI_VIEWS_TEMP}/Makefile
NTI_VIEWS_CONFIGURED=${EXTTEMP}/${NTI_VIEWS_TEMP}/src/views.c.OLD
NTI_VIEWS_BUILT=${EXTTEMP}/${NTI_VIEWS_TEMP}/app/views
NTI_VIEWS_INSTALLED=${NTI_TC_ROOT}/usr/bin/views


## ,-----
## |	Extract
## +-----

${NTI_VIEWS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/views-${VIEWS_VERSION} ] || rm -rf ${EXTTEMP}/views-${VIEWS_VERSION}
	zcat ${VIEWS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VIEWS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VIEWS_TEMP}
	mv ${EXTTEMP}/views-${VIEWS_VERSION} ${EXTTEMP}/${NTI_VIEWS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VIEWS_CONFIGURED}: ${NTI_VIEWS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
		[ -r config.mk.OLD ] || mv config.mk config.mk.OLD || exit 1 ;\
		cat config.mk.OLD \
			| sed '/BACKEND=SVGALIB/ s/^/#/' \
			| sed '/BACKEND=SDL/	s/^#*//' \
			| sed '/^PREFIX=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> config.mk ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CFLAGS+=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^VIEWS_LIBS=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/	s%$$(BINDIR)%$${DESTDIR}/$$(BINDIR)%' \
			> src/Makefile ;\
		[ -r src/views.c.OLD ] || mv src/views.c src/views.c.OLD || exit 1 ;\
		cat src/views.c.OLD \
			| sed '/stop complaints/ s/^/break;/' \
			> src/views.c \
	)
# [ config.mk ] | sed '/^CC/		s%g*cc%'${NTI_GCC}'%'


## ,-----
## |	Build
## +-----

${NTI_VIEWS_BUILT}: ${NTI_VIEWS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VIEWS_INSTALLED}: ${NTI_VIEWS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIEWS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-views
nti-views: ${NTI_VIEWS_INSTALLED}
#nti-views: nti-jpegsrc nti-libpng nti-tiff ${NTI_VIEWS_INSTALLED}

ALL_NTI_TARGETS+= nti-views

endif	# HAVE_VIEWS_CONFIG
