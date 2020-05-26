#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

# LEGACY: gcc has '-core' in filename until v4.7.x
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gmp/gmp-${GCC_GMP_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpfr/mpfr-${GCC_MPFR_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpc/mpc-${GCC_MPC_VERSION}.tar.gz

# [gcc 4.3.6] building in own source directory fixes "libgcc.mvars" problem
CTI_KGCC_SUBDIR= gcc-${GCC_VERSION}/_homebrew_xtc_kgcc
CTI_KGCC_ARCHIVE= ${SOURCES}/g/gcc-core-${GCC_VERSION}.tar.bz2
#CTI_KGCC_ARCHIVE= ${SOURCES}/g/gcc-${GCC_VERSION}.tar.bz2
ifneq (${GCC_GMP_VERSION},)
GCC_GMP_SUBDIR= gcc-${GCC_VERSION}/gmp
GCC_GMP_ARCHIVE= ${SOURCES}/g/gmp-${GCC_GMP_VERSION}.tar.bz2
endif
ifneq (${GCC_MPFR_VERSION},)
GCC_MPFR_SUBDIR= gcc-${GCC_VERSION}/mpfr
GCC_MPFR_ARCHIVE= ${SOURCES}/m/mpfr-${GCC_MPFR_VERSION}.tar.bz2
endif
ifneq (${GCC_MPC_VERSION},)
GCC_MPC_SUBDIR= gcc-${GCC_VERSION}/mpc
GCC_MPC_ARCHIVE= ${SOURCES}/m/mpc-${GCC_MPC_VERSION}.tar.gz
endif


CTI_KGCC_EXTRACTED= ${EXTTEMP}/${CTI_KGCC_SUBDIR}/../Makefile.in
CTI_KGCC_CONFIGURED= ${EXTTEMP}/${CTI_KGCC_SUBDIR}/libiberty/Makefile
CTI_KGCC_BUILT= ${EXTTEMP}/${CTI_KGCC_SUBDIR}/gcc
CTI_KGCC_INSTALLED= ${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-kgcc


## ,-----
## |	Extract
## +-----

${CTI_KGCC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${CTI_KGCC_ARCHIVE} | tar xvf - -C ${EXTTEMP}
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
ifneq (${GCC_MPC_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${GCC_MPC_SUBDIR} ] ; then \
		zcat ${GCC_MPC_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/mpc-${GCC_MPC_VERSION} ${EXTTEMP}/${GCC_MPC_SUBDIR} ;\
	fi
endif
	mkdir -p ${EXTTEMP}/${CTI_KGCC_SUBDIR}


## ,-----
## |	Configure
## +-----

# Don't need anything complicated (mudflap, ssp, threads...)
# --disable-shared matches our intended libgcc build configuration
#
# uClibc vs libgcc config:
# * --disable-decimal-float stops 'fenv.h' being a requirement [uClibc vs libgcc config]
# * --disable-threads stops 'pthread.h' being a requirement
# * libgomp incompatible with --disable-threads

# [2017-01-09] Issues with documentation format fixed by 'MAKEINFO=/bin/false'
# [2017-01-09] 'arm-*-uclibc' deprecated/obsolete in v4.7.x+
# [2017-01-09] "redefined" functions need '-fgnu89-inline' (host-gcc v6+?)

${CTI_KGCC_CONFIGURED}: ${CTI_KGCC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_KGCC_SUBDIR} || exit 1 ;\
		CFLAGS='-O2' \
		MAKEINFO=/bin/false \
		../configure --prefix=${CTI_TC_ROOT}'/usr/' \
			--host=${HOSTSPEC} --build=${HOSTSPEC} \
			--target=${TARGSPEC} \
			--program-transform-name='s%^%'${TARGSPEC}'-k%' \
			--disable-nls --disable-werror \
			--with-sysroot=${CTI_TC_ROOT}'/usr/'${TARGSPEC} \
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

# [2012-06-09] may want uClibc without "Target CPU has an FPU" - depends on some libgcc parts
${CTI_KGCC_BUILT}: ${CTI_KGCC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_KGCC_SUBDIR} || exit 1 ;\
		make all-gcc \
	)


## ,-----
## |	Install
## +-----

${CTI_KGCC_INSTALLED}: ${CTI_KGCC_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CTI_KGCC_SUBDIR} || exit 1 ;\
		make install-gcc \
	)

.PHONY: cti-xkgcc
cti-xkgcc: ${CTI_KGCC_INSTALLED}
