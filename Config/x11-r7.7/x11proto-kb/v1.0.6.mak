# x11proto-kb v1.0.7		[ since v1.0.3, c.2008-06-01 ]
# last mod WmT, 2018-03-12	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_X11PROTO_KB_CONFIG},y)
HAVE_X11PROTO_KB_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-kb' -- x11proto-kb"
#DESCRLIST+= "'cti-x11proto-kb' -- x11proto-kb"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_KB_VERSION},)
#X11PROTO_KB_VERSION=1.0.4
#X11PROTO_KB_VERSION=1.0.5
X11PROTO_KB_VERSION=1.0.6
endif

#X11PROTO_KB_SRC=${SOURCES}/x/x11proto-kb_1.0.3.orig.tar.gz
X11PROTO_KB_SRC=${SOURCES}/k/kbproto-${X11PROTO_KB_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/proto/kbproto-1.0.4.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/proto/kbproto-1.0.5.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/proto/kbproto-1.0.6.tar.bz2

NTI_X11PROTO_KB_TEMP=nti-x11proto-kb-${X11PROTO_KB_VERSION}

NTI_X11PROTO_KB_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_KB_TEMP}/configure
NTI_X11PROTO_KB_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_KB_TEMP}/config.status
NTI_X11PROTO_KB_BUILT=${EXTTEMP}/${NTI_X11PROTO_KB_TEMP}/kbproto.pc
NTI_X11PROTO_KB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/kbproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_KB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/kbproto-${X11PROTO_KB_VERSION} ] || rm -rf ${EXTTEMP}/kbproto-${X11PROTO_KB_VERSION}
	bzcat ${X11PROTO_KB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP}
	mv ${EXTTEMP}/kbproto-${X11PROTO_KB_VERSION} ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_KB_CONFIGURED}: ${NTI_X11PROTO_KB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_KB_BUILT}: ${NTI_X11PROTO_KB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_KB_INSTALLED}: ${NTI_X11PROTO_KB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/kbproto.pc ${NTI_X11PROTO_KB_INSTALLED} \

.PHONY: nti-x11proto-kb
nti-x11proto-kb: nti-pkg-config ${NTI_X11PROTO_KB_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-kb

endif	# HAVE_X11PROTO_KB_CONFIG
