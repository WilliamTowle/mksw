# libpthread-stubs v0.3		[ since v0.3, c. 2013-05-27 ]
# last mod WmT, 2015-10-09	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBPTHREAD_STUBS_CONFIG},y)
HAVE_LIBPTHREAD_STUBS_CONFIG:=y

#DESCRLIST+= "'nti-libpthread-stubs' -- libpthread-stubs"
#DESCRLIST+= "'cti-libpthread-stubs' -- libpthread-stubs"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBPTHREAD_STUBS_VERSION},)
LIBPTHREAD_STUBS_VERSION=0.3
endif

LIBPTHREAD_STUBS_SRC=${SOURCES}/l/libpthread-stubs-0.3.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/xcb/libpthread-stubs-0.3.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/xcb/libpthread-stubs-0.3.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


CTI_LIBPTHREAD_STUBS_TEMP=cti-libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}

CTI_LIBPTHREAD_STUBS_EXTRACTED=${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP}/configure
CTI_LIBPTHREAD_STUBS_CONFIGURED=${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP}/config.status
CTI_LIBPTHREAD_STUBS_BUILT=${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP}/pthread-stubs.pc
CTI_LIBPTHREAD_STUBS_INSTALLED=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/pthread-stubs.pc


NTI_LIBPTHREAD_STUBS_TEMP=nti-libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}

NTI_LIBPTHREAD_STUBS_EXTRACTED=${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP}/configure
NTI_LIBPTHREAD_STUBS_CONFIGURED=${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP}/config.status
NTI_LIBPTHREAD_STUBS_BUILT=${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP}/pthread-stubs.pc
NTI_LIBPTHREAD_STUBS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/pthread-stubs.pc


## ,-----
## |	Extract
## +-----

${CTI_LIBPTHREAD_STUBS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION} ] || rm -rf ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}
	bzcat ${LIBPTHREAD_STUBS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP}
	mv ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION} ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP}

##

${NTI_LIBPTHREAD_STUBS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION} ] || rm -rf ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}
	bzcat ${LIBPTHREAD_STUBS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP}
	mv ${EXTTEMP}/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION} ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP}



## ,-----
## |	Configure
## +-----

${CTI_LIBPTHREAD_STUBS_CONFIGURED}: ${CTI_LIBPTHREAD_STUBS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
		PKG_CONFIG_PATH=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			|| exit 1 \
	)

##

${NTI_LIBPTHREAD_STUBS_CONFIGURED}: ${NTI_LIBPTHREAD_STUBS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
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

${CTI_LIBPTHREAD_STUBS_BUILT}: ${CTI_LIBPTHREAD_STUBS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make \
	)

##

${NTI_LIBPTHREAD_STUBS_BUILT}: ${NTI_LIBPTHREAD_STUBS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CTI_LIBPTHREAD_STUBS_INSTALLED}: ${CTI_LIBPTHREAD_STUBS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-libpthread-stubs
cti-libpthread-stubs: cti-pkg-config ${CTI_LIBPTHREAD_STUBS_INSTALLED}

ALL_CTI_TARGETS+= cti-libpthread-stubs

##

${NTI_LIBPTHREAD_STUBS_INSTALLED}: ${NTI_LIBPTHREAD_STUBS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libpthread-stubs
nti-libpthread-stubs: nti-pkg-config ${NTI_LIBPTHREAD_STUBS_INSTALLED}

ALL_NTI_TARGETS+= nti-libpthread-stubs

endif	# HAVE_LIBPTHREAD_STUBS_CONFIG
