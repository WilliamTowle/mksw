# native-gcc 4.3.6		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-11-06	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_HOST_GCC_CONFIG},y)
HAVE_HOST_GCC_CONFIG:=y

DESCRLIST+= "'nti-native-gcc' -- native-gcc"

include ${CFG_ROOT}/ENV/buildtype.mak
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
#
#ifneq (${HAVE_HOST_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/native-binutils/v${HAVE_NATIVE_BINUTILS_VER}.mak
#else
#endif

ifeq (${NTI_HOST_GCC_VERSION},)
#NTI_HOST_GCC_VERSION:=4.1.2
#NTI_HOST_GCC_VERSION:=4.2.4
NTI_HOST_GCC_VERSION:=4.3.6
endif

#NTI_HOST_GCC_SRC=${SRCDIR}/g/gcc-core-${NTI_HOST_GCC_VERSION}.tar.bz2
NTI_HOST_GCC_SRC=${SOURCES}/g/gcc-core-${NTI_HOST_GCC_VERSION}.tar.bz2
NTI_HOST_GCC_PATCHES=
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${NTI_HOST_GCC_VERSION}/gcc-core-${NTI_HOST_GCC_VERSION}.tar.bz2

ifeq (${NTI_HOST_GCC_VERSION},4.1.2)
NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-patches-1.3.tar.bz2
#NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
endif

ifeq (${NTI_HOST_GCC_VERSION},4.2.4)
NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-patches-1.1.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-patches-1.1.tar.bz2
#NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
endif

ifeq (${NTI_HOST_GCC_VERSION},4.3.6)
GCC_GMP_VERSION:= 4.3.2
#GCC_GMP_ARCHIVE:= ${SRCDIR}/g/gmp-${GCC_GMP_VERSION}.tar.bz2
GCC_GMP_ARCHIVE:= ${SOURCES}/g/gmp-${GCC_GMP_VERSION}.tar.bz2
GCC_GMP_SUBDIR:= gcc-${NTI_HOST_GCC_VERSION}/gmp
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2

GCC_MPFR_VERSION:= 2.4.2
#MPFR_VERSION:= 3.1.0
#GCC_MPFR_ARCHIVE:= ${SRCDIR}/m/mpfr-${GCC_MPFR_VERSION}.tar.bz2
GCC_MPFR_ARCHIVE:= ${SOURCES}/m/mpfr-${GCC_MPFR_VERSION}.tar.bz2
GCC_MPFR_SUBDIR:= gcc-${NTI_HOST_GCC_VERSION}/mpfr
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.bz2

NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-patches-1.0.tar.bz2
#NTI_HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
endif


NTI_HOST_GCC_TEMP=nti-native-gcc-${NTI_HOST_GCC_VERSION}
NTI_HOST_GCC_EXTRACTED=${EXTTEMP}/${NTI_HOST_GCC_TEMP}/configure
NTI_HOST_GCC_CONFIGURED=${EXTTEMP}/${NTI_HOST_GCC_TEMP}/config.status
NTI_HOST_GCC_BUILT=${EXTTEMP}/${NTI_HOST_GCC_TEMP}/host-${NTI_SPEC}/gcc
NTI_HOST_GCC_INSTALLED=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-gcc


# ,-----
# |	Extract
# +-----

${NTI_HOST_GCC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/gcc-${NTI_HOST_GCC_VERSION} ] || rm -rf ${EXTTEMP}/gcc-${NTI_HOST_GCC_VERSION}
	bzcat ${NTI_HOST_GCC_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${GCC_GMP_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${GCC_GMP_SUBDIR} ] ; then \
		bzcat ${GCC_GMP_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/gmp-${GCC_GMP_VERSION} ${EXTTEMP}/${GCC_GMP_SUBDIR} ;\
	fi
endif
ifneq (${GCC_MPFR_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${GCC_MPFR_SUBDIR} ] ; then \
		bzcat ${GCC_MPFR_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/mpfr-${GCC_MPFR_VERSION} ${EXTTEMP}/${GCC_MPFR_SUBDIR} ;\
	fi
endif
#ifneq (${GCC_MPC_ARCHIVE},)
#	if [ ! -d ${EXTTEMP}/${GCC_MPC_SUBDIR} ] ; then \
#		zcat ${GCC_MPC_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
#		mv ${EXTTEMP}/mpc-${GCC_MPC_VERSION} ${EXTTEMP}/${GCC_MPC_SUBDIR} ;\
#	fi
#endif
	[ ! -d ${EXTTEMP}/${NTI_HOST_GCC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_HOST_GCC_TEMP}
	mv ${EXTTEMP}/gcc-${NTI_HOST_GCC_VERSION} ${EXTTEMP}/${NTI_HOST_GCC_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_HOST_GCC_CONFIGURED}: ${NTI_HOST_GCC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_HOST_GCC_TEMP} || exit 1 ;\
	  	CC=${NUI_CC_PREFIX}cc \
	  	AR=$(shell echo ${NUI_CC_PREFIX} | sed 's/g*$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${NTI_SPEC} \
			  --with-local-prefix=${NTI_TC_ROOT}/usr \
			  --disable-libmudflap \
			  --disable-libssp \
			  --enable-languages=c \
			  --disable-nls \
			  --enable-shared \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_HOST_GCC_BUILT}: ${NTI_HOST_GCC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_HOST_GCC_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_HOST_GCC_INSTALLED}: ${NTI_HOST_GCC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_HOST_GCC_TEMP} || exit 1 ;\
		make install \
	)

#.PHONY: nti-native-gcc
#nti-native-gcc: nti-native-binutils nti-native-gcc-installed
#NTARGETS+= nti-native-gcc

.PHONY: nti-native-gcc
nti-native-gcc: ${NTI_HOST_GCC_INSTALLED}

ALL_NTI_TARGETS+= nti-native-gcc


endif	# HAVE_HOST_GCC_CONFIG
