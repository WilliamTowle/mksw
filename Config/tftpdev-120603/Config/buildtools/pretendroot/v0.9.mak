# pretendroot v0.9		[ since v1.10.1, c.2009-12-10 ]
# last mod WmT, 2012-01-07	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_PRETENDROOT_CONFIG},y)
HAVE_PRETENDROOT_CONFIG:=y

DESCRLIST+= "'nti-pretendroot' -- pretendroot"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/native-gcc/v4.1.2.mak
endif


PRETENDROOT_VER=0.9
PRETENDROOT_SRC=${SRCDIR}/p/pretendroot-0.9.tar.gz

URLS+= ftp://ftp.uhulinux.hu/pub/sources/pretendroot/pretendroot-0.9.tar.gz


## ,-----
## |	Extract
## +-----

NTI_PRETENDROOT_TEMP=nti-pretendroot-${PRETENDROOT_VER}

NTI_PRETENDROOT_EXTRACTED=${EXTTEMP}/${NTI_PRETENDROOT_TEMP}/Makefile

.PHONY: nti-pretendroot-extracted

nti-pretendroot-extracted: ${NTI_PRETENDROOT_EXTRACTED}

${NTI_PRETENDROOT_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_PRETENDROOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PRETENDROOT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${PRETENDROOT_SRC}
	mv ${EXTTEMP}/pretendroot-${PRETENDROOT_VER} ${EXTTEMP}/${NTI_PRETENDROOT_TEMP}


## ,-----
## |	Configure
## +-----

NTI_PRETENDROOT_CONFIGURED=${EXTTEMP}/${NTI_PRETENDROOT_TEMP}/Makefile.OLD

.PHONY: nti-pretendroot-configured

nti-pretendroot-configured: nti-pretendroot-extracted ${NTI_PRETENDROOT_CONFIGURED}

${NTI_PRETENDROOT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PRETENDROOT_TEMP} || exit 1 ;\
		mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^lib/		s/^/CC=gcc\n\n/' \
			| sed '/^	/	s/gcc/$${CC}/' \
			> Makefile ;\
		mv libpretendroot.c libpretendroot.c.OLD || exit 1 ;\
		cat libpretendroot.c.OLD \
			| sed '/next_fchownat/	{ s%^%//% } ' \
			| sed '/int fchownat/,/}/	{ s%^%//% } ' \
			| sed '/next_renameat/	{ s%^%//% } ' \
			| sed '/int renameat/,/}/	{ s%^%//% } ' \
			| sed '/next_unlinkat/	{ s%^%//% } ' \
			| sed '/int unlinkat/,/}/	{ s%^%//% } ' \
			> libpretendroot.c \
	)


## ,-----
## |	Build
## +-----

NTI_PRETENDROOT_BUILT=${EXTTEMP}/${NTI_PRETENDROOT_TEMP}/libpretendroot.so

.PHONY: nti-pretendroot-built
nti-pretendroot-built: nti-pretendroot-configured ${NTI_PRETENDROOT_BUILT}

${NTI_PRETENDROOT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PRETENDROOT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_PRETENDROOT_INSTALLED=${NTI_TC_ROOT}/usr/lib/libpretendroot.so

.PHONY: nti-pretendroot-installed

nti-pretendroot-installed: nti-pretendroot-built ${NTI_PRETENDROOT_INSTALLED}

${NTI_PRETENDROOT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PRETENDROOT_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib || exit 1 ;\
		cp libpretendroot.so ${NTI_TC_ROOT}/usr/lib \
	)

.PHONY: nti-pretendroot
nti-pretendroot: nti-pretendroot-installed

NTARGETS+= nti-pretendroot

endif	# HAVE_PRETENDROOT_CONFIG
