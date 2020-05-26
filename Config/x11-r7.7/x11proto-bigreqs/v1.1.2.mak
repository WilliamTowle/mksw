# x11proto-bigreqs v1.1.2	[ since v1.0.2, c.2008-06-08 ]
# last mod WmT, 2018-03-12	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_X11PROTO_BIGREQS_CONFIG},y)
HAVE_X11PROTO_BIGREQS_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-bigreqs' -- x11proto-bigreqs"
#DESCRLIST+= "'cti-x11proto-bigreqs' -- x11proto-bigreqs"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_BIGREQS_VERSION},)
#X11PROTO_BIGREQS_VERSION=1.1.0
#X11PROTO_BIGREQS_VERSION=1.1.1
X11PROTO_BIGREQS_VERSION=1.1.2
endif

#X11PROTO_BIGREQS_SRC=${SOURCES}/x/x11proto-bigreqs_${X11PROTO_BIGREQS_VERSION}.orig.tar.gz
X11PROTO_BIGREQS_SRC=${SOURCES}/b/bigreqsproto-${X11PROTO_BIGREQS_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/proto/bigreqsproto-1.1.0.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/proto/bigreqsproto-1.1.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/proto/bigreqsproto-1.1.2.tar.bz2

NTI_X11PROTO_BIGREQS_TEMP=nti-x11proto-bigreqs-${X11PROTO_BIGREQS_VERSION}

NTI_X11PROTO_BIGREQS_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP}/configure
NTI_X11PROTO_BIGREQS_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP}/config.status
NTI_X11PROTO_BIGREQS_BUILT=${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP}/bigreqsproto.pc
NTI_X11PROTO_BIGREQS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/bigreqsproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_BIGREQS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bigreqsproto-${X11PROTO_BIGREQS_VERSION} ] || rm -rf ${EXTTEMP}/bigreqsproto-${X11PROTO_BIGREQS_VERSION}
	bzcat ${X11PROTO_BIGREQS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP}
	mv ${EXTTEMP}/bigreqsproto-${X11PROTO_BIGREQS_VERSION} ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_BIGREQS_CONFIGURED}: ${NTI_X11PROTO_BIGREQS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_BIGREQS_BUILT}: ${NTI_X11PROTO_BIGREQS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_BIGREQS_INSTALLED}: ${NTI_X11PROTO_BIGREQS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_BIGREQS_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/bigreqsproto.pc ${NTI_X11PROTO_BIGREQS_INSTALLED} \

.PHONY: nti-x11proto-bigreqs
nti-x11proto-bigreqs: nti-pkg-config ${NTI_X11PROTO_BIGREQS_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-bigreqs

endif	# HAVE_X11PROTO_BIGREQS_CONFIG
