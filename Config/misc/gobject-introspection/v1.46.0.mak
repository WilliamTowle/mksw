# gobject-introspection v1.46.0	[ earliest v1.46.0, c.2015-09-30 ]
# last mod WmT, 2015-10-26	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_GOBJECT_INTROSPECTION_CONFIG},y)
HAVE_GOBJECT_INTROSPECTION_CONFIG:=y

DESCRLIST+= "'nti-gobject-introspection' -- gobject-introspection"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${GOBJECT_INTROSPECTION_VERSION},)
GOBJECT_INTROSPECTION_VERSION= 1.45.4
#GOBJECT_INTROSPECTION_VERSION= 1.46.0
endif
GOBJECT_INTROSPECTION_SRC= ${SOURCES}/g/gobject-introspection-${GOBJECT_INTROSPECTION_VERSION}.tar.xz
URLS+= http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.46/gobject-introspection-${GOBJECT_INTROSPECTION_VERSION}.tar.xz

include ${CFG_ROOT}/misc/glib/v2.46.0.mak
include ${CFG_ROOT}/python/python2/v2.7.9.mak

NTI_GOBJECT_INTROSPECTION_TEMP=nti-gobject-introspection-${GOBJECT_INTROSPECTION_VERSION}

NTI_GOBJECT_INTROSPECTION_EXTRACTED=${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP}/gobject-introspection-1.0.pc.in
NTI_GOBJECT_INTROSPECTION_CONFIGURED=${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP}/gio/Makefile.OLD
NTI_GOBJECT_INTROSPECTION_BUILT=${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP}/gobject-introspection/.libs/libgobject-introspection-1.0.la
NTI_GOBJECT_INTROSPECTION_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/gobject-introspection-1.0.pc


## ,-----
## |	Extract
## +-----

${NTI_GOBJECT_INTROSPECTION_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/gobject-introspection-${GOBJECT_INTROSPECTION_VERSION} ] || rm -rf ${EXTTEMP}/gobject-introspection-${GOBJECT_INTROSPECTION_VERSION}
	#bzcat ${GOBJECT_INTROSPECTION_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${GOBJECT_INTROSPECTION_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP}
	mv ${EXTTEMP}/gobject-introspection-${GOBJECT_INTROSPECTION_VERSION} ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP}


## ,-----
## |	Configure
## +-----

## "-m32" prevents error re 'LONGBIT' definition (because xk120 is x86_64)

${NTI_GOBJECT_INTROSPECTION_CONFIGURED}: ${NTI_GOBJECT_INTROSPECTION_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_GOBJECT_INTROSPECTION_BUILT}: ${NTI_GOBJECT_INTROSPECTION_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP} || exit 1 ;\
		make \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
	)

## ,-----
## |	Install
## +-----

${NTI_GOBJECT_INTROSPECTION_INSTALLED}: ${NTI_GOBJECT_INTROSPECTION_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GOBJECT_INTROSPECTION_TEMP} || exit 1 ;\
		make install \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
			|| exit 1 \
	)

.PHONY: nti-gobject-introspection
nti-gobject-introspection: \
	nti-pkg-config nti-libtool nti-python2 \
	\
	nti-glib \
	\
	${NTI_GOBJECT_INTROSPECTION_INSTALLED}

ALL_NTI_TARGETS+= nti-gobject-introspection

endif	# HAVE_GOBJECT_INTROSPECTION_CONFIG
