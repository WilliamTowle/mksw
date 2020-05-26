# cross-binutils v2.17		[ since v2.9.1, c.2002-10-14 ]
# last mod WmT, 2011-08-29	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CROSS_BINUTILS_CONFIG},y)
HAVE_CROSS_BINUTILS_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/native-gcc/v4.1.2.mak

DESCRLIST+= "'cti-cross-binutils' -- cross-binutils"

CROSS_BINUTILS_VER:=2.17
CROSS_BINUTILS_SRC=${SRCDIR}/b/binutils-${CROSS_BINUTILS_VER}.tar.bz2
CROSS_BINUTILS_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-${CROSS_BINUTILS_VER}.tar.bz2

CROSS_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-patches-1.3.tar.bz2
CROSS_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-uclibc-patches-1.0.tar.bz2

# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

CTI_CROSS_BINUTILS_TEMP=cti-cross-binutils-${CROSS_BINUTILS_VER}

CTI_CROSS_BINUTILS_EXTRACTED=${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP}/configure

.PHONY: cti-cross-binutils-extracted

cti-cross-binutils-extracted: ${CTI_CROSS_BINUTILS_EXTRACTED}

${CTI_CROSS_BINUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CROSS_BINUTILS_SRC}
ifneq (${CROSS_BINUTILS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CROSS_BINUTILS_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc-patches/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d binutils-${CROSS_BINUTILS_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${CROSS_BINUTILS_VER} -Np0 ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/binutils-${CROSS_BINUTILS_VER} ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP}


# ,-----
# |	Configure
# +-----

CTI_CROSS_BINUTILS_CONFIGURED=${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP}/config.status

.PHONY: cti-cross-binutils-configured

cti-cross-binutils-configured: cti-cross-binutils-extracted ${CTI_CROSS_BINUTILS_CONFIGURED}

${CTI_CROSS_BINUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	case ${CTI_SPEC} in \
	*gnu) \
		echo "$0: Bad CTI_SPEC ${CTI_SPEC}" 1>&2 ;\
		exit 1 \
	;; \
	esac
	( cd ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  	CC=${NTI_GCC} \
	  	AR=$(shell echo ${NTI_GCC} | sed 's/g*cc$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${CTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${CTI_SPEC} \
			--with-sysroot=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/' \
			  --enable-shared \
			  --disable-largefile --disable-nls \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

CTI_CROSS_BINUTILS_BUILT=${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP}/binutils/ar

.PHONY: cti-cross-binutils-built
cti-cross-binutils-built: cti-cross-binutils-configured ${CTI_CROSS_BINUTILS_BUILT}

${CTI_CROSS_BINUTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

CTI_CROSS_BINUTILS_INSTALLED=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-ar

.PHONY: cti-cross-binutils-installed

cti-cross-binutils-installed: cti-cross-binutils-built ${CTI_CROSS_BINUTILS_INSTALLED}

${CTI_CROSS_BINUTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_CROSS_BINUTILS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-cross-binutils
cti-cross-binutils: nti-native-gcc cti-cross-binutils-installed

TARGETS+= cti-cross-binutils

endif	# HAVE_CROSS_BINUTILS_CONFIG
