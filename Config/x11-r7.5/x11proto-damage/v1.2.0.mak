# x11proto-damage v1.2.0	[ since v1.2.0, c.2013-03-03 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_DAMAGE_CONFIG},y)
HAVE_X11PROTO_DAMAGE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-damage' -- x11proto-damage"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${X11PROTO_DAMAGE_VERSION},)
X11PROTO_DAMAGE_VERSION=1.2.0
#|X11PROTO_DAMAGE_VERSION=1.2.1
endif

X11PROTO_DAMAGE_SRC=${SOURCES}/d/damageproto-${X11PROTO_DAMAGE_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/damageproto-1.2.0.tar.bz2

#include ${CFG_ROOT}/x11-r7.5/util-macros/v1.3.0.mak
#|include ${CFG_ROOT}/x11-r7.5/util-macros/v1.17.1.mak

NTI_X11PROTO_DAMAGE_TEMP=nti-x11proto-damage-${X11PROTO_DAMAGE_VERSION}

NTI_X11PROTO_DAMAGE_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP}/configure
NTI_X11PROTO_DAMAGE_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP}/config.status
NTI_X11PROTO_DAMAGE_BUILT=${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP}/damageproto.pc
NTI_X11PROTO_DAMAGE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/damageproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_DAMAGE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/damageproto-${X11PROTO_DAMAGE_VERSION} ] || rm -rf ${EXTTEMP}/damageproto-${X11PROTO_DAMAGE_VERSION}
	bzcat ${X11PROTO_DAMAGE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP}
	mv ${EXTTEMP}/damageproto-${X11PROTO_DAMAGE_VERSION} ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_DAMAGE_CONFIGURED}: ${NTI_X11PROTO_DAMAGE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP} || exit 1 ;\
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
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_DAMAGE_BUILT}: ${NTI_X11PROTO_DAMAGE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_DAMAGE_INSTALLED}: ${NTI_X11PROTO_DAMAGE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DAMAGE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-damage
#nti-x11proto-damage: nti-pkg-config \
#	nti-util-macros \
#	${NTI_X11PROTO_DAMAGE_INSTALLED}
nti-x11proto-damage: nti-pkg-config \
	${NTI_X11PROTO_DAMAGE_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-damage

endif	# HAVE_X11PROTO_DAMAGE_CONFIG
