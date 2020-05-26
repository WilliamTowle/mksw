# treewm v0.21pl2		[ since v0.21pl2, 2017-04-19 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_TREEWM_CONFIG},y)
HAVE_TREEWM_CONFIG:=y

#DESCRLIST+= "'cui-treewm' -- treewm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${TREEWM_VERSION},)
TREEWM_VERSION=0.4.5
endif

TREEWM_SRC=${SOURCES}/t/treewm-${TREEWM_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/treewm/treewm/0.4.5/treewm-0.4.5.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ftreewm%2F&ts=1492771683&use_mirror=netcologne"


#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak
include ${CFG_ROOT}/x11-r7.5/libXxf86vm/v1.1.0.mak

NTI_TREEWM_TEMP=nti-treewm-${TREEWM_VERSION}
NTI_TREEWM_EXTRACTED=${EXTTEMP}/${NTI_TREEWM_TEMP}/COPYING
NTI_TREEWM_CONFIGURED=${EXTTEMP}/${NTI_TREEWM_TEMP}/Makefile.OLD
NTI_TREEWM_BUILT=${EXTTEMP}/${NTI_TREEWM_TEMP}/treewm
NTI_TREEWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/treewm


# ,-----
# |	Extract
# +-----

${NTI_TREEWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/treewm-${TREEWM_VERSION} ] || rm -rf ${EXTTEMP}/treewm-${TREEWM_VERSION}
	#bzcat ${TREEWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${TREEWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TREEWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TREEWM_TEMP}
	mv ${EXTTEMP}/treewm-${TREEWM_VERSION} ${EXTTEMP}/${NTI_TREEWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_TREEWM_CONFIGURED}: ${NTI_TREEWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TREEWM_TEMP} || exit 1 ;\
		[ -r src/resmanager.h.OLD ] || mv src/resmanager.h src/resmanager.h.OLD || exit 1 ;\
		cat src/resmanager.h.OLD \
			| sed '/define RESMANAGER_H/	s%$$%\n\n#include <string.h>\n\n%' \
			> src/resmanager.h ;\
		[ -r xprop/dsimple.c.OLD ] || mv xprop/dsimple.c xprop/dsimple.c.OLD || exit 1 ;\
		cat xprop/dsimple.c.OLD \
			| sed '/<stdio.h>/	s%$$%\n#include <stdlib.h>%' \
			| sed '/^	char/	s/, \*[mr][a-z]*alloc();/;/' \
			> xprop/dsimple.c ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^INCLUDES/	s%-I/usr/X11R6/include%'"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags x11 `"'%' \
			| sed '/^LIBS/		s%-L/usr/X11R6/lib%'"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --libs x11 `"'%' \
			> Makefile \
	)


# ,-----
# |	Build
# +-----

${NTI_TREEWM_BUILT}: ${NTI_TREEWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TREEWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_TREEWM_INSTALLED}: ${NTI_TREEWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TREEWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-treewm
nti-treewm: nti-pkg-config \
	nti-libXpm \
	nti-libXxf86vm \
	${NTI_TREEWM_INSTALLED}

ALL_NTI_TARGETS+= nti-treewm

endif	# HAVE_TREEWM_CONFIG
