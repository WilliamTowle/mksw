# cross-kbinutils v2.22		[ since v2.9.1, c.2002-10-14 ]
# last mod WmT, 2011-12-11	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_KBINUTILS_CONFIG},y)
HAVE_CROSS_KBINUTILS_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'cti-cross-kbinutils' -- cross-kbinutils"

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif

CROSS_KBINUTILS_VER:=${HAVE_CROSS_BINUTILS_VER}
CROSS_KBINUTILS_SRC=${SRCDIR}/b/binutils-${CROSS_KBINUTILS_VER}.tar.bz2
CROSS_KBINUTILS_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-${CROSS_KBINUTILS_VER}.tar.bz2

ifeq (${CROSS_KBINUTILS_VER},2.17)
CROSS_KBINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-patches-1.3.tar.bz2
CROSS_KBINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-uclibc-patches-1.0.tar.bz2
endif
ifeq (${CROSS_KBINUTILS_VER},2.22)
CROSS_KBINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.22-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.22-patches-1.0.tar.bz2
#CROSS_KBINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.22-uclibc-patches-1.0.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.22-uclibc-patches-1.0.tar.bz2
endif


# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

CTI_CROSS_KBINUTILS_TEMP=cti-cross-kbinutils-${CROSS_KBINUTILS_VER}

CTI_CROSS_KBINUTILS_EXTRACTED=${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP}/configure

.PHONY: cti-cross-kbinutils-extracted

cti-cross-kbinutils-extracted: ${CTI_CROSS_KBINUTILS_EXTRACTED}

${CTI_CROSS_KBINUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CROSS_KBINUTILS_SRC}
ifneq (${CROSS_KBINUTILS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CROSS_KBINUTILS_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc-patches/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d binutils-${CROSS_KBINUTILS_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${CROSS_KBINUTILS_VER} -Np0 ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/binutils-${CROSS_KBINUTILS_VER} ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP}


# ,-----
# |	Configure
# +-----

CTI_CROSS_KBINUTILS_CONFIGURED=${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP}/config.status

.PHONY: cti-cross-kbinutils-configured

cti-cross-kbinutils-configured: cti-cross-kbinutils-extracted ${CTI_CROSS_KBINUTILS_CONFIGURED}

${CTI_CROSS_KBINUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  	CC=${NTI_SPEC}-gcc \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${CTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${CTI_MIN_SPEC} \
			--with-sysroot=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/' \
			  --enable-shared \
			  --disable-largefile --disable-nls \
			  || exit 1 \
	)
#	  	AR=$(shell echo ${NTI_GCC} | sed 's/g*cc$$/ar/') \


# ,-----
# |	Build
# +-----

CTI_CROSS_KBINUTILS_BUILT=${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP}/binutils/ar

.PHONY: cti-cross-kbinutils-built
cti-cross-kbinutils-built: cti-cross-kbinutils-configured ${CTI_CROSS_KBINUTILS_BUILT}

${CTI_CROSS_KBINUTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

CTI_CROSS_KBINUTILS_INSTALLED=${CTI_TC_ROOT}/usr/bin/${CTI_MIN_SPEC}-ar

.PHONY: cti-cross-kbinutils-installed

cti-cross-kbinutils-installed: cti-cross-kbinutils-built ${CTI_CROSS_KBINUTILS_INSTALLED}

${CTI_CROSS_KBINUTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_KBINUTILS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-cross-kbinutils
cti-cross-kbinutils: nti-native-gcc cti-cross-kbinutils-installed

NTARGETS+= cti-cross-kbinutils

endif	# HAVE_CROSS_KBINUTILS_CONFIG
