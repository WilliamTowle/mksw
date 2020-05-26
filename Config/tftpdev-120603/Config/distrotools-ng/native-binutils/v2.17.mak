# native-binutils v2.17		[ since v2.9.1, c.2002-10-04 ]
# last mod WmT, 2011-09-12	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_NATIVE_BINUTILS_CONFIG},y)
HAVE_NATIVE_BINUTILS_CONFIG:=y

DESCRLIST+= "'nti-native-binutils' -- native-binutils"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

NATIVE_BINUTILS_VER:=2.17
NATIVE_BINUTILS_SRC=${SRCDIR}/b/binutils-${NATIVE_BINUTILS_VER}.tar.bz2
NATIVE_BINUTILS_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-${NATIVE_BINUTILS_VER}.tar.bz2

NATIVE_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-patches-1.3.tar.bz2
NATIVE_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.17-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.17-uclibc-patches-1.0.tar.bz2

# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

NTI_NATIVE_BINUTILS_TEMP=nti-native-binutils-${NATIVE_BINUTILS_VER}

NTI_NATIVE_BINUTILS_EXTRACTED=${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}/configure

.PHONY: nti-native-binutils-extracted

nti-native-binutils-extracted: ${NTI_NATIVE_BINUTILS_EXTRACTED}

${NTI_NATIVE_BINUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NATIVE_BINUTILS_SRC}
ifneq (${NATIVE_BINUTILS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${NATIVE_BINUTILS_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc-patches/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d binutils-${NATIVE_BINUTILS_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${NATIVE_BINUTILS_VER} -Np0 ;\
			rm -f $${PF} ;\
		done \
	)
endif
ifeq ($(shell which makeinfo 2>/dev/null),)
	( cd ${EXTTEMP}/binutils-${NATIVE_BINUTILS_VER} || exit 1 ;\
		mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed 's/$$(MAKEINFO)/true/' \
			> Makefile.in || exit 1 \
	)
endif
	mv ${EXTTEMP}/binutils-${NATIVE_BINUTILS_VER} ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}


# ,-----
# |	Configure
# +-----

NTI_NATIVE_BINUTILS_CONFIGURED=${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}/config.status

.PHONY: nti-native-binutils-configured

nti-native-binutils-configured: nti-native-binutils-extracted ${NTI_NATIVE_BINUTILS_CONFIGURED}

${NTI_NATIVE_BINUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} || exit 1 ;\
	  	CC=${NUI_CC_PREFIX}cc \
	  	AR=$(shell echo ${NUI_CC_PREFIX} | sed 's/g*$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${NTI_SPEC} \
			  --program-prefix=${NTI_SPEC}- \
			  --with-sysroot=/ \
			  --with-lib-path=/lib:/usr/lib \
			  --enable-shared \
			  --disable-largefile --disable-nls \
			  --disable-werror \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_NATIVE_BINUTILS_BUILT=${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}/binutils/ar

.PHONY: nti-native-binutils-built
nti-native-binutils-built: nti-native-binutils-configured ${NTI_NATIVE_BINUTILS_BUILT}

${NTI_NATIVE_BINUTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_NATIVE_BINUTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-ar

.PHONY: nti-native-binutils-installed

nti-native-binutils-installed: nti-native-binutils-built ${NTI_NATIVE_BINUTILS_INSTALLED}

${NTI_NATIVE_BINUTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-native-binutils
nti-native-binutils: nti-native-binutils-installed

NTARGETS+= nti-native-binutils

endif	# HAVE_NATIVE_BINUTILS_CONFIG
