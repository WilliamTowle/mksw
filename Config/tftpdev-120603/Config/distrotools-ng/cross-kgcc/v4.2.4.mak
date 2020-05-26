# cross-kgcc v4.2.4		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-10-16	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_KGCC_CONFIG},y)
HAVE_CROSS_KGCC_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'cti-cross-kgcc' -- cross-kgcc"

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif
ifneq (${HAVE_CROSS_BINUTILS_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-kbinutils/v${HAVE_CROSS_BINUTILS_VER}.mak
endif

#CTI_CROSS_KGCC_VER:=4.1.2
CTI_CROSS_KGCC_VER:=4.2.4
CTI_CROSS_KGCC_SRC=${SRCDIR}/g/gcc-core-${CTI_CROSS_KGCC_VER}.tar.bz2
CTI_CROSS_KGCC_PATCHES=

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${CTI_CROSS_KGCC_VER}/gcc-core-${CTI_CROSS_KGCC_VER}.tar.bz2

ifeq (${CTI_CROSS_KGCC_VER},4.1.2)
CTI_CROSS_KGCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-patches-1.3.tar.bz2
CTI_CROSS_KGCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
endif

ifeq (${CTI_CROSS_KGCC_VER},4.2.4)
CTI_CROSS_KGCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-patches-1.1.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-patches-1.1.tar.bz2
CTI_CROSS_KGCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
endif


# ,-----
# |	Extract
# +-----

CTI_CROSS_KGCC_TEMP=cti-cross-kgcc-${CTI_CROSS_KGCC_VER}

CTI_CROSS_KGCC_EXTRACTED=${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}/configure

.PHONY: cti-cross-kgcc-extracted

cti-cross-kgcc-extracted: ${CTI_CROSS_KGCC_EXTRACTED}

${CTI_CROSS_KGCC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CTI_CROSS_KGCC_SRC}
ifneq (${CTI_CROSS_KGCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CTI_CROSS_KGCC_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CTI_CROSS_KGCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/gcc-${CTI_CROSS_KGCC_VER} ${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}


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
			  ${CTI_GCC_ARCH_OPTS} \
			  --enable-languages=c \
			  --disable-nls \
			  --disable-shared \
			  --disable-threads \
			  --without-headers \
			  --with-gnu-ld \
			  --with-gnu-as \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

## partial compiler -- just use 'all-gcc' target (no libiberty.a)

CTI_CROSS_KGCC_BUILT=${EXTTEMP}/${CTI_CROSS_KGCC_TEMP}/host-${NTI_SPEC}/libiberty/libiberty.a

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

NTARGETS+= cti-cross-kgcc

endif	# HAVE_CROSS_KGCC_CONFIG
