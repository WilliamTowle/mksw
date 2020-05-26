# xf86-driproto v2.1.0		[ since v2.1.0, c.2015-10-20 ]
# last mod WmT, 2015-10-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_XF86_DRIPROTO_CONFIG},y)
HAVE_XF86_DRIPROTO_CONFIG:=y

#DESCRLIST+= "'nti-xf86-driproto' -- xf86-driproto"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XF86_DRIPROTO_VERSION},)
XF86_DRIPROTO_VERSION=2.1.0
endif

XF86_DRIPROTO_SRC=${SOURCES}/x/xf86driproto-${XF86_DRIPROTO_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/proto/xf86driproto-2.1.0.tar.bz2


NTI_XF86_DRIPROTO_TEMP=nti-xf86-driproto-${XF86_DRIPROTO_VERSION}

NTI_XF86_DRIPROTO_EXTRACTED=${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP}/configure
NTI_XF86_DRIPROTO_CONFIGURED=${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP}/config.status
NTI_XF86_DRIPROTO_BUILT=${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP}/xf86driproto.pc
NTI_XF86_DRIPROTO_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xf86driproto.pc


## ,-----
## |	Extract
## +-----

${NTI_XF86_DRIPROTO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86driproto-${XF86_DRIPROTO_VERSION} ] || rm -rf ${EXTTEMP}/xf86driproto-${XF86_DRIPROTO_VERSION}
	bzcat ${XF86_DRIPROTO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP}
	mv ${EXTTEMP}/xf86driproto-${XF86_DRIPROTO_VERSION} ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XF86_DRIPROTO_CONFIGURED}: ${NTI_XF86_DRIPROTO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP} || exit 1 ;\
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

${NTI_XF86_DRIPROTO_BUILT}: ${NTI_XF86_DRIPROTO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XF86_DRIPROTO_INSTALLED}: ${NTI_XF86_DRIPROTO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_DRIPROTO_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_XF86_DRIPROTO_INSTALLED} ` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xf86driproto.pc ${NTI_XF86_DRIPROTO_INSTALLED} \

.PHONY: nti-xf86-driproto
nti-xf86-driproto: nti-pkg-config ${NTI_XF86_DRIPROTO_INSTALLED}

ALL_NTI_TARGETS+= nti-xf86-driproto

endif	# HAVE_XF86_DRIPROTO_CONFIG
