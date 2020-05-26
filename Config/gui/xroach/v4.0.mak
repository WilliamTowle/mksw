# xroach v4.0			[ since v4.0, c. 2016-12-28 ]
# last mod WmT, 2016-12-28	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XROACH_CONFIG},y)
HAVE_XROACH_CONFIG:=y

DESCRLIST+= "'nti-xroach' -- xroach"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XROACH_VERSION},)
XROACH_VERSION=4.0
endif

XROACH_SRC=${SOURCES}/x/xroach-${XROACH_VERSION}.tar.gz
URLS+= http://ibiblio.org/pub/Linux/X11/demos/xroach-2.1tp.tar.gz

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/x11-r7.5/libXaw/v1.0.7.mak
##include ${CFG_ROOT}/x11-r7.6/libXaw/v1.0.8.mak
#include ${CFG_ROOT}/x11-r7.5/libXmu/v1.0.5.mak
##include ${CFG_ROOT}/x11-r7.6/libXmu/v1.1.0.mak
#include ${CFG_ROOT}/x11-r7.5/libXrender/v0.9.5.mak
##include ${CFG_ROOT}/x11-r7.6/libXrender/v0.9.6.mak

NTI_XROACH_TEMP=nti-xroach-${XROACH_VERSION}

NTI_XROACH_EXTRACTED=${EXTTEMP}/${NTI_XROACH_TEMP}/README
NTI_XROACH_CONFIGURED=${EXTTEMP}/${NTI_XROACH_TEMP}/config.log
NTI_XROACH_BUILT=${EXTTEMP}/${NTI_XROACH_TEMP}/xroach
NTI_XROACH_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xroach


## ,-----
## |	Extract
## +-----

${NTI_XROACH_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xroach-${XROACH_VERSION} ] || rm -rf ${EXTTEMP}/xroach-${XROACH_VERSION}
	#[ ! -d ${EXTTEMP}/xroach ] || rm -rf ${EXTTEMP}/xroach
	zcat ${XROACH_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XROACH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XROACH_TEMP}
	mv ${EXTTEMP}/xroach-${XROACH_VERSION} ${EXTTEMP}/${NTI_XROACH_TEMP}
	#mv ${EXTTEMP}/xroach ${EXTTEMP}/${NTI_XROACH_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XROACH_CONFIGURED}: ${NTI_XROACH_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XROACH_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^[A-Z]*FLAGS/	s%/usr/X11R6/%'${NTI_TC_ROOT}'/usr/%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_XROACH_BUILT}: ${NTI_XROACH_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XROACH_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XROACH_INSTALLED}: ${NTI_XROACH_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XROACH_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xroach
nti-xroach: nti-pkg-config \
	nti-libX11 \
	${NTI_XROACH_INSTALLED}

ALL_NTI_TARGETS+= nti-xroach

endif	# HAVE_XROACH_CONFIG
