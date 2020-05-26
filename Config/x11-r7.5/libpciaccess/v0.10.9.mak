# x11pciaccess v0.10.9		[ since v0.3, c. 2013-05-27 ]
# last mod WmT, 2013-05-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_X11PCIACCESS_CONFIG},y)
HAVE_X11PCIACCESS_CONFIG:=y

#DESCRLIST+= "'nti-x11pciaccess' -- x11pciaccess"
#DESCRLIST+= "'cti-x11pciaccess' -- x11pciaccess"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${X11PCIACCESS_VERSION},)
X11PCIACCESS_VERSION=0.10.9
endif

X11PCIACCESS_SRC=${SOURCES}/l/libpciaccess-0.10.9.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/lib/libpciaccess-0.10.9.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

##include ${CFG_ROOT}/gui/x11pciaccess-xext/v7.1.1.mak
#include ${CFG_ROOT}/gui/x11pciaccess-xext/v7.1.2.mak
##include ${CFG_ROOT}/gui/xtrans/v1.2.5.mak
#include ${CFG_ROOT}/gui/xtrans/v1.2.6.mak


NTI_X11PCIACCESS_TEMP=nti-x11pciaccess-${X11PCIACCESS_VERSION}

NTI_X11PCIACCESS_EXTRACTED=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/configure
NTI_X11PCIACCESS_CONFIGURED=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/config.status
NTI_X11PCIACCESS_BUILT=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/pciaccess.pc
NTI_X11PCIACCESS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/pciaccess.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PCIACCESS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/x11pciaccess-${X11PCIACCESS_VERSION} ] || rm -rf ${EXTTEMP}/x11pciaccess-${X11PCIACCESS_VERSION}
	bzcat ${X11PCIACCESS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}
	mv ${EXTTEMP}/libpciaccess-${X11PCIACCESS_VERSION} ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_X11PCIACCESS_CONFIGURED}: ${NTI_X11PCIACCESS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


## ,-----
## |	Build
## +-----

${NTI_X11PCIACCESS_BUILT}: ${NTI_X11PCIACCESS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PCIACCESS_INSTALLED}: ${NTI_X11PCIACCESS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/pciaccess.pc ${NTI_X11PCIACCESS_INSTALLED} \
	)

.PHONY: nti-x11pciaccess
nti-x11pciaccess: nti-pkg-config ${NTI_X11PCIACCESS_INSTALLED}

ALL_NTI_TARGETS+= nti-x11pciaccess

endif	# HAVE_X11PCIACCESS_CONFIG
