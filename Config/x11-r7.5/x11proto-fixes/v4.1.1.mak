# x11proto-fixes v4.1.1		[ since v4.1.1, c.2013-03-03 ]
# last mod WmT, 2013-05-13	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_X11PROTO_FIXES_CONFIG},y)
HAVE_X11PROTO_FIXES_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-fixes' -- x11proto-fixes"
#DESCRLIST+= "'cti-x11proto-fixes' -- x11proto-fixes"

ifeq (${X11PROTO_FIXES_VERSION},)
X11PROTO_FIXES_VERSION=4.1.1
endif

X11PROTO_FIXES_SRC=${SOURCES}/f/fixesproto-${X11PROTO_FIXES_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/fixesproto-4.1.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_FIXES_TEMP=nti-x11proto-fixes-${X11PROTO_FIXES_VERSION}

NTI_X11PROTO_FIXES_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP}/configure
NTI_X11PROTO_FIXES_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP}/config.status
NTI_X11PROTO_FIXES_BUILT=${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP}/fixesproto.pc
NTI_X11PROTO_FIXES_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/fixesproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_FIXES_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/fixesproto-${X11PROTO_FIXES_VERSION} ] || rm -rf ${EXTTEMP}/fixesproto-${X11PROTO_FIXES_VERSION}
	bzcat ${X11PROTO_FIXES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP}
	mv ${EXTTEMP}/fixesproto-${X11PROTO_FIXES_VERSION} ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_FIXES_CONFIGURED}: ${NTI_X11PROTO_FIXES_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_FIXES_BUILT}: ${NTI_X11PROTO_FIXES_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_FIXES_INSTALLED}: ${NTI_X11PROTO_FIXES_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FIXES_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-fixes
nti-x11proto-fixes: nti-pkg-config ${NTI_X11PROTO_FIXES_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-fixes

endif	# HAVE_X11PROTO_FIXES_CONFIG
