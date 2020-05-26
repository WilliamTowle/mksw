# native-gcc 4.2.4		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2011-10-16	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_NATIVE_GCC_CONFIG},y)
HAVE_NATIVE_GCC_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-binutils/v${HAVE_NATIVE_BINUTILS_VER}.mak
else
endif

DESCRLIST+= "'nti-native-gcc' -- native-gcc"

#NTI_NATIVE_GCC_VER:=4.1.2
NTI_NATIVE_GCC_VER:=4.2.4
NTI_NATIVE_GCC_SRC=${SRCDIR}/g/gcc-core-${NTI_NATIVE_GCC_VER}.tar.bz2
NTI_NATIVE_GCC_PATCHES=

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${NTI_NATIVE_GCC_VER}/gcc-core-${NTI_NATIVE_GCC_VER}.tar.bz2

ifeq (${NTI_NATIVE_GCC_VER},4.1.2)
NTI_NATIVE_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-patches-1.3.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-patches-1.3.tar.bz2
NTI_NATIVE_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
endif

ifeq (${NTI_NATIVE_GCC_VER},4.2.4)
NTI_NATIVE_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-patches-1.1.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-patches-1.1.tar.bz2
NTI_NATIVE_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
endif



# ,-----
# |	Extract
# +-----

NTI_NATIVE_GCC_TEMP=nti-native-gcc-${NTI_NATIVE_GCC_VER}

NTI_NATIVE_GCC_EXTRACTED=${EXTTEMP}/${NTI_NATIVE_GCC_TEMP}/configure

.PHONY: nti-native-gcc-extracted

nti-native-gcc-extracted: ${NTI_NATIVE_GCC_EXTRACTED}

${NTI_NATIVE_GCC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NTI_NATIVE_GCC_SRC}
ifneq (${NTI_NATIVE_GCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${NTI_NATIVE_GCC_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${NTI_NATIVE_GCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/gcc-${NTI_NATIVE_GCC_VER} ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP}


# ,-----
# |	Configure
# +-----

NTI_NATIVE_GCC_CONFIGURED=${EXTTEMP}/${NTI_NATIVE_GCC_TEMP}/config.status

.PHONY: nti-native-gcc-configured

nti-native-gcc-configured: nti-native-gcc-extracted ${NTI_NATIVE_GCC_CONFIGURED}

${NTI_NATIVE_GCC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP} || exit 1 ;\
	  	CC=${NUI_CC_PREFIX}cc \
	  	AR=$(shell echo ${NUI_CC_PREFIX} | sed 's/g*$$/ar/') \
	    	  CFLAGS=-O2 \
			./configure -v \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${NTI_SPEC} \
			  --with-local-prefix=${NTI_TC_ROOT}/usr \
			  --disable-libmudflap \
			  --disable-libssp \
			  --enable-languages=c \
			  --disable-nls \
			  --enable-shared \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_NATIVE_GCC_BUILT=${EXTTEMP}/${NTI_NATIVE_GCC_TEMP}/host-${NTI_SPEC}/gcc/libgcc/libgcc.map

.PHONY: nti-native-gcc-built
nti-native-gcc-built: nti-native-gcc-configured ${NTI_NATIVE_GCC_BUILT}

${NTI_NATIVE_GCC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_NATIVE_GCC_INSTALLED=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-gcc

.PHONY: nti-native-gcc-installed

nti-native-gcc-installed: nti-native-gcc-built ${NTI_NATIVE_GCC_INSTALLED}

${NTI_NATIVE_GCC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_GCC_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-native-gcc
nti-native-gcc: nti-native-binutils nti-native-gcc-installed

NTARGETS+= nti-native-gcc

endif	# HAVE_NATIVE_GCC_CONFIG
