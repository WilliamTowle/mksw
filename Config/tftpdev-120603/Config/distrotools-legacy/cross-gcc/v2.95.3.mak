# cross-gcc v2.95.3-2		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-10-20	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_GCC_CONFIG},y)
HAVE_CROSS_GCC_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/native-gcc/v2.95.3.mak
include ${CFG_ROOT}/distrotools-legacy/cross-binutils/v2.16.1.mak
include ${CFG_ROOT}/distrotools-legacy/uClibc-dev/v0.9.26.mak

DESCRLIST+= "'cti-cross-gcc' -- cross-gcc"

CROSS_GCC_VER:=2.95.3
CROSS_GCC_SRC=${SRCDIR}/g/gcc-${CROSS_GCC_VER}.tar.gz
CROSS_GCC_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gcc/gcc-2.95.3/gcc-${NATIVE_GCC_VER}.tar.gz
#URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gcc/gcc-2.95.3/gcc-core-${NATIVE_GCC_VER}.tar.gz

#CROSS_GCC_PATCHES+=${SRCDIR}/g/gcc-2.95.3-patches-1.3.tar.bz2
#URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-2.95.3-patches-1.3.tar.bz2
CROSS_GCC_PATCHES+=${SRCDIR}/g/gcc-${CROSS_GCC_VER}-2.patch
URLS+=http://www.linuxfromscratch.org/patches/downloads/gcc/gcc-2.95.3-2.patch


# ,-----
# |	Extract
# +-----

CTI_CROSS_GCC_TEMP=cti-cross-gcc-${CROSS_GCC_VER}

CTI_CROSS_GCC_EXTRACTED=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/configure

.PHONY: cti-cross-gcc-extracted

cti-cross-gcc-extracted: ${CTI_CROSS_GCC_EXTRACTED}

${CTI_CROSS_GCC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_GCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CROSS_GCC_SRC}
ifneq (${CROSS_GCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${CROSS_GCC_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CROSS_GCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/gcc-${CROSS_GCC_VER} ${EXTTEMP}/${CTI_CROSS_GCC_TEMP}


# ,-----
# |	Configure
# +-----

CTI_CROSS_GCC_CONFIGURED=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/config.status

.PHONY: cti-cross-gcc-configured

cti-cross-gcc-configured: cti-cross-gcc-extracted ${CTI_CROSS_GCC_CONFIGURED}

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
			  --enable-languages=c \
			  --disable-nls \
			  --enable-shared \
			  --with-headers=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include' \
			  --with-libs=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/lib' \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

## full compiler - safe to do regular `make`

CTI_CROSS_GCC_BUILT=${EXTTEMP}/${CTI_CROSS_GCC_TEMP}/gcc/genattrtab

.PHONY: cti-cross-gcc-built
cti-cross-gcc-built: cti-cross-gcc-configured ${CTI_CROSS_GCC_BUILT}

${CTI_CROSS_GCC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_GCC_TEMP} || exit 1 ;\
		make \
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
		make install || exit 1 ;\
		cat gcc/specs \
			| sed 's/ld-linux.so.2/ld-uClibc.so.0/' > `${CTI_CROSS_GCC_INSTALLED} -v 2>&1 | grep specs | sed 's/.* //'` || exit 1 \
	)

.PHONY: cti-cross-gcc
cti-cross-gcc: nti-native-gcc cti-cross-binutils cti-uClibc-dev cti-cross-gcc-installed

TARGETS+= cti-cross-gcc

endif	# HAVE_CROSS_GCC_CONFIG
