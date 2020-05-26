#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

## LEGACY: has '-core' in filename until v4.7.x
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gmp/gmp-${GCC_GMP_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpfr/mpfr-${GCC_MPFR_VERSION}.tar.bz2

# [gcc 4.3.6] building in own source directory fixes "libgcc.mvars" problem
GCC_SUBDIR= gcc-${GCC_VERSION}/_homebrew_xtc_gcc
## LEGACY: has '-core' in filename until v4.7.x
#GCC_ARCHIVE= ${SOURCES}/g/gcc-core-${GCC_VERSION}.tar.bz2
GCC_ARCHIVE= ${SOURCES}/g/gcc-${GCC_VERSION}.tar.bz2
ifneq (${GCC_GMP_VERSION},)
GCC_GMP_SUBDIR= gcc-${GCC_VERSION}/gmp
GCC_GMP_ARCHIVE= ${SOURCES}/g/gmp-${GCC_GMP_VERSION}.tar.bz2
endif
ifneq (${GCC_MPFR_VERSION},)
GCC_MPFR_SUBDIR= gcc-${GCC_VERSION}/mpfr
GCC_MPFR_ARCHIVE= ${SOURCES}/m/mpfr-${GCC_MPFR_VERSION}.tar.bz2
endif

GCC_EXTRACTED= ${EXTTEMP}/${GCC_SUBDIR}/../Makefile.in
GCC_CONFIGURED= ${EXTTEMP}/${GCC_SUBDIR}/libiberty/Makefile
GCC_BUILT= ${EXTTEMP}/${GCC_SUBDIR}/gcc
GCC_INSTALLED= ${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-gcc


## ,-----
## |	Extract
## +-----

${GCC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${GCC_ARCHIVE} | tar xvf - -C ${EXTTEMP}
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
	mkdir -p ${EXTTEMP}/${GCC_SUBDIR}


## ,-----
## |	Configure
## +-----

# possibly --disable-shared?
# --disable-decimal-float stops 'fenv.h' being a requirement [uClibc config?]
# --disable-threads stops 'pthread.h' being a requirement [uClibc config]
# libgomp incompatable with --disable-threads
# mudflap implied somehow (target iFOO-uClibc?); better disabled

# [2017-01-09] Issues with documentation format fixed by 'MAKEINFO=/bin/false'
# [2017-01-09] 'arm-*-uclibc' deprecated/obsolete in v4.7.x+
# [2017-01-09] "redefined" functions need '-fgnu89-inline' (host-gcc v6+?)

${GCC_CONFIGURED}: ${GCC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${GCC_SUBDIR} || exit 1 ;\
		CFLAGS='-O2' \
		MAKEINFO=/bin/false \
                ../configure --prefix=${CTI_TC_ROOT}'/usr/' \
			--host=${HOSTSPEC} --build=${HOSTSPEC} \
			--target=${TARGSPEC} \
			--with-sysroot=${CTI_TC_ROOT}'/usr/'${TARGSPEC} \
			--disable-nls --disable-werror \
			--disable-multilib \
			--disable-shared \
			--enable-languages=c \
			--enable-clocale=uclibc \
		 	--disable-__cxa_atexit \
			--disable-decimal-float \
			--disable-threads \
			--disable-libgomp \
			--disable-mudflap \
	)


## ,-----
## |	Build
## +-----

${GCC_BUILT}: ${GCC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${GCC_SUBDIR} || exit 1 ;\
		make all-gcc \
	)


## ,-----
## |	Install
## +-----

${GCC_INSTALLED}: ${GCC_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${GCC_SUBDIR} || exit 1 ;\
		make install-gcc ;\
		( cd ${CTI_TC_ROOT}'/usr/bin' && ln -sf ${TARGSPEC}-gcc-${GCC_VERSION} ${TARGSPEC}-gcc ) \
	)

.PHONY: xgcc
xgcc: ${GCC_INSTALLED}
