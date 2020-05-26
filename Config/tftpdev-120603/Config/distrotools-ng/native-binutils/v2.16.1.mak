# native-binutils v2.16.1		[ since v2.9.1, c.2002-10-14 ]
# last mod WmT, 2010-06-03	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_HOST_BINUTILS_CONFIG},y)
HAVE_HOST_BINUTILS_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak


DESCRLIST+= "'nti-native-binutils' -- native-binutils"

HOST_BINUTILS_VER:=2.16.1
HOST_BINUTILS_SRC=${SRCDIR}/b/binutils-${HOST_BINUTILS_VER}.tar.bz2
HOST_BINUTILS_PATCHES=

URLS+=http://ftp.kernel.org/pub/linux/devel/binutils/binutils-${HOST_BINUTILS_VER}.tar.bz2

HOST_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.16.1-patches-1.11.tar.bz2
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.16.1-patches-1.11.tar.bz2
HOST_BINUTILS_PATCHES+=${SRCDIR}/b/binutils-2.16.1-uclibc-patches-1.1.tar.bz2
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/binutils-2.16.1-uclibc-patches-1.1.tar.bz2

# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

NTI_NATIVE_BINUTILS_TEMP=nti-native-binutils-${HOST_BINUTILS_VER}

NTI_NATIVE_BINUTILS_EXTRACTED=${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}/configure

.PHONY: nti-native-binutils-extracted

nti-native-binutils-extracted: ${NTI_NATIVE_BINUTILS_EXTRACTED}

${NTI_NATIVE_BINUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${HOST_BINUTILS_SRC}
ifneq (${HOST_BINUTILS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${HOST_BINUTILS_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in uclibc-patches/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d binutils-${HOST_BINUTILS_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${HOST_BINUTILS_VER} -Np0 ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/binutils-${HOST_BINUTILS_VER} ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}


# ,-----
# |	Configure
# +-----

NTI_NATIVE_BINUTILS_CONFIGURED=${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP}/config.status

.PHONY: nti-native-binutils-configured

nti-native-binutils-configured: nti-native-binutils-extracted ${NTI_NATIVE_BINUTILS_CONFIGURED}

${NTI_NATIVE_BINUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NATIVE_BINUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
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

TARGETS+=nti-native-binutils

endif	# HAVE_HOST_BINUTILS_CONFIG
