# xauth v1.0.4			[ since v1.0.1	2009-09-04 ]
# last mod WmT, 2013-12-24	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XAUTH_CONFIG},y)
HAVE_XAUTH_CONFIG:=y

#DESCRLIST+= "'cui-xauth' -- xauth"

ifeq (${XAUTH_VERSION},)
XAUTH_VERSION=1.0.4
endif

XAUTH_SRC=${SOURCES}/x/xauth-${XAUTH_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/app/xauth-1.0.4.tar.bz2

### X11R7.5 or R7.6/7.7?
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/gui/libXau/v1.0.5.mak
include ${CFG_ROOT}/gui/x11proto-xext/v7.1.1.mak
include ${CFG_ROOT}/gui/libXmu/v1.0.5.mak

NTI_XAUTH_TEMP=nti-xauth-${XAUTH_VERSION}
NTI_XAUTH_EXTRACTED=${EXTTEMP}/${NTI_XAUTH_TEMP}/configure
NTI_XAUTH_CONFIGURED=${EXTTEMP}/${NTI_XAUTH_TEMP}/config.log
NTI_XAUTH_BUILT=${EXTTEMP}/${NTI_XAUTH_TEMP}/xauth
NTI_XAUTH_INSTALLED=${NTI_TC_ROOT}/usr/bin/xauth


# ,-----
# |	Extract
# +-----

${NTI_XAUTH_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xauth-${XAUTH_VERSION} ] || rm -rf ${EXTTEMP}/xauth-${XAUTH_VERSION}
	bzcat ${XAUTH_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XAUTH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XAUTH_TEMP}
	mv ${EXTTEMP}/xauth-${XAUTH_VERSION} ${EXTTEMP}/${NTI_XAUTH_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_XAUTH_CONFIGURED}: ${NTI_XAUTH_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XAUTH_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\
#
#				--with-appdefaultdir=${NTI_TC_ROOT}/etc/X11/app-defaults \
#				--without-xft \


# ,-----
# |	Build
# +-----

${NTI_XAUTH_BUILT}: ${NTI_XAUTH_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XAUTH_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_XAUTH_INSTALLED}: ${NTI_XAUTH_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XAUTH_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xauth
nti-xauth: nti-libX11 nti-libXau nti-x11proto-xext nti-libXmu ${NTI_XAUTH_INSTALLED}

ALL_NTI_TARGETS+= nti-xauth

endif	# HAVE_XAUTH_CONFIG
