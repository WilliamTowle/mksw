# x11proto-input v2.2		[ since v1.4.3, c.2008-06-01 ]
# last mod WmT, 2018-03-12	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_X11PROTO_INPUT_CONFIG},y)
HAVE_X11PROTO_INPUT_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-input' -- x11proto-input"
#DESCRLIST+= "'cti-x11proto-input' -- x11proto-input"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_INPUT_VERSION},)
#X11PROTO_INPUT_VERSION=2.0
#X11PROTO_INPUT_VERSION=2.0.1
X11PROTO_INPUT_VERSION=2.2
endif
#X11PROTO_INPUT_SRC=${SOURCES}/x/x11proto-input_${X11PROTO_INPUT_VERSION}.orig.tar.gz
X11PROTO_INPUT_SRC=${SOURCES}/i/inputproto-${X11PROTO_INPUT_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/proto/inputproto-2.0.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/proto/inputproto-2.0.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/proto/inputproto-2.2.tar.bz2

NTI_X11PROTO_INPUT_TEMP=nti-x11proto-input-${X11PROTO_INPUT_VERSION}

NTI_X11PROTO_INPUT_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP}/configure
NTI_X11PROTO_INPUT_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP}/config.status
NTI_X11PROTO_INPUT_BUILT=${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP}/inputproto.pc
NTI_X11PROTO_INPUT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/inputproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_INPUT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/inputproto-${X11PROTO_INPUT_VERSION} ] || rm -rf ${EXTTEMP}/inputproto-${X11PROTO_INPUT_VERSION}
	bzcat ${X11PROTO_INPUT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP}
	mv ${EXTTEMP}/inputproto-${X11PROTO_INPUT_VERSION} ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_INPUT_CONFIGURED}: ${NTI_X11PROTO_INPUT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_INPUT_BUILT}: ${NTI_X11PROTO_INPUT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_INPUT_INSTALLED}: ${NTI_X11PROTO_INPUT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-input
nti-x11proto-input: nti-pkg-config ${NTI_X11PROTO_INPUT_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-input

endif	# HAVE_X11PROTO_INPUT_CONFIG
