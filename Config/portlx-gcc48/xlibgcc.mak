#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

## LEGACY: has '-core' in filename until v4.7.x
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gmp/gmp-${GCC_GMP_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpfr/mpfr-${GCC_MPFR_VERSION}.tar.bz2


# TODO: deps: cross compiler on PATH

# [gcc 4.3.6] building in own source directory fixes "libgcc.mvars" problem
LIBGCC_SUBDIR= gcc-${GCC_VERSION}/_homebrew_xtc_libgcc
## LEGACY: has '-core' in filename until v4.7.x
#LIBGCC_ARCHIVE= ${SOURCES}/g/gcc-core-${GCC_VERSION}.tar.bz2
LIBGCC_ARCHIVE= ${SOURCES}/g/gcc-${GCC_VERSION}.tar.bz2
ifneq (${GCC_GMP_VERSION},)
GCC_GMP_SUBDIR= gcc-${GCC_VERSION}/gmp
GCC_GMP_ARCHIVE= ${SOURCES}/g/gmp-${GCC_GMP_VERSION}.tar.bz2
endif
ifneq (${GCC_MPFR_VERSION},)
GCC_MPFR_SUBDIR= gcc-${GCC_VERSION}/mpfr
GCC_MPFR_ARCHIVE= ${SOURCES}/m/mpfr-${GCC_MPFR_VERSION}.tar.bz2
endif


LIBGCC_EXTRACTED= ${EXTTEMP}/${LIBGCC_SUBDIR}/../Makefile.in
LIBGCC_CONFIGURED= ${EXTTEMP}/${LIBGCC_SUBDIR}/libiberty/Makefile
LIBGCC_BUILT= ${EXTTEMP}/${LIBGCC_SUBDIR}/gcc/libgcc.a
LIBGCC_INSTALLED= ${CTI_TC_ROOT}/usr/lib/gcc/${TARGSPEC}/${GCC_VERSION}/libgcc.a



## ,-----
## |	Extract
## +-----

${LIBGCC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${LIBGCC_ARCHIVE} | tar xvf - -C ${EXTTEMP}
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
	mkdir -p ${EXTTEMP}/${LIBGCC_SUBDIR}


## ,-----
## |	Configure
## +-----

# Introduce libgcc so it becomes available during uClibc build
# Cross-compilation settings should match those for kernel compiler

# Don't need anything complicated (mudflap, ssp, threads...)
# --disable-shared cuts down what we build for libgcc
#
# uClibc vs libgcc config:
# * --disable-decimal-float stops 'fenv.h' being a requirement [uClibc vs libgcc config]
# * --disable-threads stops 'pthread.h' being a requirement
# * libgomp incompatible with --disable-threads

# [2017-01-09] Issues with documentation format fixed by 'MAKEINFO=/bin/false'
# [2017-01-09] 'arm-*-uclibc' deprecated/obsolete in v4.7.x+
# [2017-01-09] "redefined" functions need '-fgnu89-inline' (host-gcc v6+?)

${LIBGCC_CONFIGURED}: ${LIBGCC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${LIBGCC_SUBDIR} || exit 1 ;\
		CFLAGS='-O2' \
		MAKEINFO=/bin/false \
		../configure --prefix=${CTI_TC_ROOT}'/usr/' \
			--host=${HOSTSPEC} --build=${HOSTSPEC} \
			--target=${TARGSPEC} \
			--program-transform-name='s%^%'${TARGSPEC}'-k%' \
			--disable-nls --disable-werror \
			--without-headers \
			--with-newlib \
			--enable-languages=c \
			--disable-__cxa_atexit \
			--disable-mutilib \
			--disable-decimal-float \
			--disable-mudflap \
			--disable-ssp \
			--disable-shared \
			--disable-threads \
			--disable-libgomp \
	)


## ,-----
## |	Build
## +-----

# 'libgcc' needed to build uClibc runtime
# ...dependency varies based on uClibc .config ("Target CPU has an FPU")

${LIBGCC_BUILT}: ${LIBGCC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${LIBGCC_SUBDIR} || exit 1 ;\
		make all-target-libgcc \
	)


## ,-----
## |	Install
## +-----

${LIBGCC_INSTALLED}: ${LIBGCC_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${LIBGCC_SUBDIR} || exit 1 ;\
		make install-target-libgcc \
	)

.PHONY: xlibgcc
xlibgcc: ${LIBGCC_INSTALLED}
