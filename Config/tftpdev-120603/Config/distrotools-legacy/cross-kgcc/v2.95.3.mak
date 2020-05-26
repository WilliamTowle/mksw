# cross-kgcc v2.95.3-2		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-10-20	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_KGCC_CONFIG},y)
HAVE_CROSS_KGCC_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/native-gcc/v2.95.3.mak
include ${CFG_ROOT}/distrotools-legacy/cross-kbinutils/v2.16.1.mak

DESCRLIST+= "'cti-cross-kgcc' -- cross-kgcc"

CROSS_KGCC_VER:=2.95.3
CROSS_KGCC_SRC=${SRCDIR}/g/gcc-${CROSS_KGCC_VER}.tar.gz
#CROSS_KGCC_SRC=${SRCDIR}/g/gcc-core-${CROSS_KGCC_VER}.tar.gz
CROSS_KGCC_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gcc/gcc-2.95.3/gcc-${NATIVE_GCC_VER}.tar.gz
#URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gcc/gcc-2.95.3/gcc-core-${NATIVE_GCC_VER}.tar.gz

#CROSS_KGCC_PATCHES+=${SRCDIR}/g/gcc-2.95.3-patches-1.3.tar.bz2
#URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-2.95.3-patches-1.3.tar.bz2
CROSS_KGCC_PATCHES+=${SRCDIR}/g/gcc-${CROSS_KGCC_VER}-2.patch
URLS+=http://www.linuxfromscratch.org/patches/downloads/gcc/gcc-2.95.3-2.patch


# ,-----
# |	Extract
# +-----

CTI_CROSS_KGCC_TEMP=cti-cross-kgcc-${CROSS_KGCC_VER}

CTI_CROSS_KGCC_EXTRACTED=${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}/configure

.PHONY: cti-cross-kgcc-extracted

cti-cross-kgcc-extracted: ${CTI_CROSS_KGCC_EXTRACTED}

${CTI_CROSS_KGCC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CROSS_KGCC_SRC}
ifneq (${CROSS_KGCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${CROSS_KGCC_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CROSS_KGCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/gcc-${CROSS_KGCC_VER} ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}


# ,-----
# |	Configure
# +-----

CTI_CROSS_KGCC_CONFIGURED=${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}/config.status

.PHONY: cti-cross-kgcc-configured

cti-cross-kgcc-configured: cti-cross-kgcc-extracted ${CTI_CROSS_KGCC_CONFIGURED}

${CTI_CROSS_KGCC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  	CC=${NTI_GCC} \
	  	AR=$(shell echo ${NTI_GCC} | sed 's/g*cc$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${CTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${CTI_MIN_SPEC} \
			  --enable-languages=c \
			  --disable-nls \
			  --enable-shared \
			  --without-headers \
			  --with-newlib \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

## partial compiler -- just use 'all-gcc' target (no libiberty.a)

CTI_CROSS_KGCC_BUILT=${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}/gcc/genattrtab

.PHONY: cti-cross-kgcc-built
cti-cross-kgcc-built: cti-cross-kgcc-configured ${CTI_CROSS_KGCC_BUILT}

${CTI_CROSS_KGCC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP} || exit 1 ;\
		make all-gcc \
	)


# ,-----
# |	Install
# +-----

## partial compiler -- just use 'all-gcc' target (no libiberty.a)

CTI_CROSS_KGCC_INSTALLED=${CTI_TC_ROOT}/usr/bin/${CTI_MIN_SPEC}-gcc

.PHONY: cti-cross-kgcc-installed

cti-cross-kgcc-installed: cti-cross-kgcc-built ${CTI_CROSS_KGCC_INSTALLED}

${CTI_CROSS_KGCC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP} || exit 1 ;\
		make install-gcc || exit 1 \
	)

.PHONY: cti-cross-kgcc
cti-cross-kgcc: nti-native-gcc cti-cross-kbinutils cti-cross-kgcc-installed

TARGETS+= cti-cross-kgcc

endif	# HAVE_CROSS_KGCC_CONFIG
