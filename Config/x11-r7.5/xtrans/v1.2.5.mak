# xtrans v1.2.5			[ since v1.2, c.2008-06-12 ]
# last mod WmT, 2013-01-04	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XTRANS_CONFIG},y)
HAVE_XTRANS_CONFIG:=y

#DESCRLIST+= "'nti-xtrans' -- xtrans"

include ${CFG_ROOT}/ENV/buildtype.mak

#ifneq (${HAVE_CROSS_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VERSION}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VERSION}.mak
#endif

ifeq (${XTRANS_VERSION},)
XTRANS_VERSION=1.2.5
endif

XTRANS_SRC=${SOURCES}/x/xtrans-${XTRANS_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/lib/xtrans-1.2.5.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

NTI_XTRANS_TEMP=nti-xtrans-${XTRANS_VERSION}

NTI_XTRANS_EXTRACTED=${EXTTEMP}/${NTI_XTRANS_TEMP}/configure
NTI_XTRANS_CONFIGURED=${EXTTEMP}/${NTI_XTRANS_TEMP}/config.status
NTI_XTRANS_BUILT=${EXTTEMP}/${NTI_XTRANS_TEMP}/xtrans.pc
NTI_XTRANS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xtrans.pc


## ,-----
## |	Extract
## +-----

${NTI_XTRANS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xtrans-${XTRANS_VERSION} ] || rm -rf ${EXTTEMP}/xtrans-${XTRANS_VERSION}
	bzcat ${XTRANS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XTRANS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XTRANS_TEMP}
	mv ${EXTTEMP}/xtrans-${XTRANS_VERSION} ${EXTTEMP}/${NTI_XTRANS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XTRANS_CONFIGURED}: ${NTI_XTRANS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XTRANS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)
#ifeq (${XTRANS_VERSION},1.2.5)
#	( cd ${EXTTEMP}/${NTI_XTRANS_TEMP} || exit 1 ;\
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			| sed '/^pkgconfigdir/	s%=.*%= '${NTI_TC_ROOT}'/usr/lib/pkgconfig%' \
#			> Makefile \
#	)
#endif


## ,-----
## |	Build
## +-----

${NTI_XTRANS_BUILT}: ${NTI_XTRANS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XTRANS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XTRANS_INSTALLED}: ${NTI_XTRANS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XTRANS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xtrans
nti-xtrans: nti-pkg-config ${NTI_XTRANS_INSTALLED}

ALL_NTI_TARGETS+= nti-xtrans

endif	# HAVE_XTRANS_CONFIG
