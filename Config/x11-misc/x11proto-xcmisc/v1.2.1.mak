# x11proto-xcmisc v1.2.1	[ since v1.1.2, c.2008-06-08 ]
# last mod WmT, 2013-05-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_X11PROTO_XCMISC_CONFIG},y)
HAVE_X11PROTO_XCMISC_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-xcmisc' -- x11proto-xcmisc"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/ENV/ifbuild.env
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
#endif
#
#ifneq (${HAVE_CROSS_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VERSION}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VERSION}.mak
#endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11_PROTO_XCMISC_VERSION},)
#X11PROTO_XCMISC_VERSION=1.2.0
X11PROTO_XCMISC_VERSION=1.2.1
endif
#X11PROTO_XCMISC_SRC=${SOURCES}/x/x11proto-xcmisc_${X11PROTO_XCMISC_VERSION}.orig.tar.gz
X11PROTO_XCMISC_SRC=${SOURCES}/x/xcmiscproto-${X11PROTO_XCMISC_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/proto/xcmiscproto-1.2.0.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/proto/xcmiscproto-1.2.1.tar.bz2

NTI_X11PROTO_XCMISC_TEMP=nti-x11proto-xcmisc-${X11PROTO_XCMISC_VERSION}

NTI_X11PROTO_XCMISC_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP}/configure
NTI_X11PROTO_XCMISC_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP}/config.status
NTI_X11PROTO_XCMISC_BUILT=${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP}/xcmiscproto.pc
NTI_X11PROTO_XCMISC_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcmiscproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_XCMISC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xcmiscproto-${X11PROTO_XCMISC_VERSION} ] || rm -rf ${EXTTEMP}/xcmiscproto-${X11PROTO_XCMISC_VERSION}
	bzcat ${X11PROTO_XCMISC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP}
	mv ${EXTTEMP}/xcmiscproto-${X11PROTO_XCMISC_VERSION} ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_XCMISC_CONFIGURED}: ${NTI_X11PROTO_XCMISC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
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
			  --enable-shared --disable-static \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_XCMISC_BUILT}: ${NTI_X11PROTO_XCMISC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_XCMISC_INSTALLED}: ${NTI_X11PROTO_XCMISC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xcmiscproto.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ \

.PHONY: nti-x11proto-xcmisc
nti-x11proto-xcmisc: nti-pkg-config ${NTI_X11PROTO_XCMISC_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-xcmisc

endif	# HAVE_X11PROTO_XCMISC_CONFIG
