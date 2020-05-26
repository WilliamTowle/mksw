# cross-gcc v4.3.6		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-10-17	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_GCC_CONFIG},y)
HAVE_CROSS_GCC_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'cti-cross-gcc' -- cross-gcc"

include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/cross-binutils/v${HAVE_CROSS_BINUTILS_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-dev/v${HAVE_TARGET_UCLIBC_VER}.mak

#CTI_CROSS_GCC_VER:=4.1.2
#CTI_CROSS_GCC_VER:=4.2.4
CTI_CROSS_GCC_VER:=4.3.6
CTI_CROSS_GCC_SRC=${SRCDIR}/g/gcc-core-${CTI_CROSS_GCC_VER}.tar.bz2
CTI_CROSS_GCC_PATCHES=

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${CTI_CROSS_GCC_VER}/gcc-core-${CTI_CROSS_GCC_VER}.tar.bz2

ifeq (${CTI_CROSS_GCC_VER},4.1.2)
CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-patches-1.3.tar.bz2
CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
endif

ifeq (${CTI_CROSS_GCC_VER},4.2.4)
CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-patches-1.1.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-patches-1.1.tar.bz2
CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
endif

ifeq (${CTI_CROSS_GCC_VER},4.3.6)
GMP_VER:= 4.3.2
CTI_CROSS_GCC_SRC+= ${SRCDIR}/g/gmp-${GMP_VER}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gmp/gmp-${GMP_VER}.tar.bz2

MPFR_VER:= 2.4.2
#MPFR_VER:= 3.1.0
CTI_CROSS_GCC_SRC+= ${SRCDIR}/m/mpfr-${MPFR_VER}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/mpfr/mpfr-${MPFR_VER}.tar.bz2

CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-patches-1.0.tar.bz2
CTI_CROSS_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
endif


# ,-----
# |	Extract
# +-----

CTI_CROSS_GCC_TEMP=cti-cross-gcc-${CTI_CROSS_GCC_VER}

CTI_CROSS_GCC_EXTRACTED=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/configure

.PHONY: cti-cross-gcc-extracted

cti-cross-gcc-extracted: ${CTI_CROSS_GCC_EXTRACTED}

${CTI_CROSS_GCC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_GCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES="${CTI_CROSS_GCC_SRC}"
ifneq (${CTI_CROSS_GCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CTI_CROSS_GCC_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CTI_CROSS_GCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
ifneq (${GMP_VER},)
	mv ${EXTTEMP}/gmp-${GMP_VER} ${EXTTEMP}/gcc-${CTI_CROSS_GCC_VER}/gmp
endif
ifneq (${MPFR_VER},)
	mv ${EXTTEMP}/mpfr-${MPFR_VER} ${EXTTEMP}/gcc-${CTI_CROSS_GCC_VER}/mpfr
endif
	mv ${EXTTEMP}/gcc-${CTI_CROSS_GCC_VER} ${EXTTEMP}/${CTI_CROSS_GCC_TEMP}


# ,-----
# |	Configure
# +-----

CTI_CROSS_GCC_CONFIGURED=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/config.status

.PHONY: cti-cross-gcc-configured

cti-cross-gcc-configured: cti-cross-gcc-extracted ${CTI_CROSS_GCC_CONFIGURED}

# 2011-10-17: v4.3.x+ has gmp, mpfr dependencies

${CTI_CROSS_GCC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  	CC=${NTI_GCC} \
	  	AR=$(shell echo ${NTI_GCC} | sed 's/g*cc$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${CTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${CTI_SPEC} \
			  ${CTI_GCC_ARCH_OPTS} \
			  --enable-languages='c' \
	        	--enable-clocale=uclibc \
	        	--disable-__cxa_atexit \
	        	--enable-shared \
			--disable-threads \
			--with-sysroot=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/' \
		        --with-local-prefix=${CTI_TC_ROOT}'/usr' \
	        	--disable-nls \
	        	--disable-libmudflap \
	        	--disable-libssp \
	        	--without-gmp \
	        	--without-mfpr \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

## full compiler - safe to `make all` (generates libiberty.a)

CTI_CROSS_GCC_BUILT=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/build-${NTI_SPEC}/libiberty/libiberty.a

.PHONY: cti-cross-gcc-built
cti-cross-gcc-built: cti-cross-gcc-configured ${CTI_CROSS_GCC_BUILT}

${CTI_CROSS_GCC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} || exit 1 ;\
		make all \
	)


# ,-----
# |	Install
# +-----

CTI_CROSS_GCC_INSTALLED=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-gcc

.PHONY: cti-cross-gcc-installed

cti-cross-gcc-installed: cti-cross-gcc-built ${CTI_CROSS_GCC_INSTALLED}

${CTI_CROSS_GCC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} || exit 1 ;\
		make install || exit 1 \
	)


.PHONY: cti-cross-gcc
cti-cross-gcc: nti-native-gcc cti-cross-binutils cti-uClibc-dev cti-cross-gcc-installed

NTARGETS+= cti-cross-gcc

endif	# HAVE_CROSS_GCC_CONFIG
