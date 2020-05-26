# xdesktopwaves v1.3		[ EARLIEST v1.34, c.2002-10-09 ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XDESKTOPWAVES_CONFIG},y)
HAVE_XDESKTOPWAVES_CONFIG:=y

#DESCRLIST+= "'nti-xdesktopwaves' -- xdesktopwaves"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XDESKTOPWAVES_VERSION},)
#XDESKTOPWAVES_VERSION=1.2
XDESKTOPWAVES_VERSION=1.3
endif

XDESKTOPWAVES_SRC=${SOURCES}/x/xdesktopwaves-${XDESKTOPWAVES_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/xdesktopwaves/xdesktopwaves/${XDESKTOPWAVES_VERSION}/xdesktopwaves-${XDESKTOPWAVES_VERSION}.tar.gz?use_mirror=ignum

ifeq (${XDESKTOPWAVES_NEEDS_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak
#include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak
endif

NTI_XDESKTOPWAVES_TEMP=nti-xdesktopwaves-${XDESKTOPWAVES_VERSION}

NTI_XDESKTOPWAVES_EXTRACTED=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/README
NTI_XDESKTOPWAVES_CONFIGURED=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/Makefile.OLD
NTI_XDESKTOPWAVES_BUILT=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/xdesktopwaves
NTI_XDESKTOPWAVES_INSTALLED=${NTI_TC_ROOT}/usr/X11R6/bin/xdesktopwaves


## ,-----
## |	Extract
## +-----

${NTI_XDESKTOPWAVES_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION} ] || rm -rf ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION}
	zcat ${XDESKTOPWAVES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}
	mv ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION} ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}


## ,-----
## |	Configure
## +-----

# FIXME: munge Makefile for CC, CFLAGS, LDFLAGS (-> use toolchain)

${NTI_XDESKTOPWAVES_CONFIGURED}: ${NTI_XDESKTOPWAVES_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^[A-Z1]*DIR/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CFLAGS/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^LFLAGS/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_XDESKTOPWAVES_BUILT}: ${NTI_XDESKTOPWAVES_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XDESKTOPWAVES_INSTALLED}: ${NTI_XDESKTOPWAVES_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/X11R6/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/X11R6/man/man1 ;\
		make install \
	)

##

.PHONY: nti-xdesktopwaves
ifeq (${XDESKTOPWAVES_NEEDS_X11},true)
nti-xdesktopwaves: nti-libX11 \
	${NTI_XDESKTOPWAVES_INSTALLED}
else
nti-xdesktopwaves: ${NTI_XDESKTOPWAVES_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-xdesktopwaves

endif	# HAVE_XDESKTOPWAVES_CONFIG
