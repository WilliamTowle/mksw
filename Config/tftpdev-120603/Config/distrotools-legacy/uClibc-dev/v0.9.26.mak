# uClibc v0.9.28.3		[ since v.0.9.9, 2002-10-26 ]
# last mod WmT, 2011-05-15	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CTI_UCLIBC_DEV_CONFIG},y)
HAVE_CTI_UCLIBC_DEV_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/cross-kgcc/v2.95.3.mak
include ${CFG_ROOT}/distrotools-legacy/lx24-source/v2.4.34.1.mak

DESCRLIST+= "'cti-uClibc-dev' -- uClibc development"

CTI_UCLIBC_DEV_VER:=0.9.26
CTI_UCLIBC_DEV_SRC=${SRCDIR}/u/uClibc-${CTI_UCLIBC_DEV_VER}.tar.bz2
CTI_UCLIBC_DEV_PATCHES=

URLS+=http://www.uclibc.org/downloads/old-releases/uClibc-${CTI_UCLIBC_DEV_VER}.tar.bz2

# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

CTI_UCLIBC_DEV_TEMP=cti-uClibc-dev-${CTI_UCLIBC_DEV_VER}

CTI_UCLIBC_DEV_EXTRACTED=${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP}/Makefile

.PHONY: cti-uClibc-dev-extracted

cti-uClibc-dev-extracted: ${CTI_UCLIBC_DEV_EXTRACTED}

${CTI_UCLIBC_DEV_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP}
	${MAKE} -C ${TOPLEV} extract ARCHIVES=${CTI_UCLIBC_DEV_SRC}
#ifneq (${CTI_UCLIBC_DEV_PATCHES},)
#	( cd ${EXTTEMP} || exit 1 ;\
#		for PATCHSRC in ${CTI_UCLIBC_DEV_PATCHES} ; do \
#			${MAKE} -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
#		done ;\
#		for PF in uclibc-patches/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			patch --batch -d binutils-${CTI_UCLIBC_DEV_VER} -Np1 < $${PF} ;\
#			rm -f $${PF} ;\
#		done ;\
#		for PF in patch/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${CTI_UCLIBC_DEV_VER} -Np0 ;\
#			rm -f $${PF} ;\
#		done \
#	)
#endif
	mv ${EXTTEMP}/uClibc-${CTI_UCLIBC_DEV_VER} ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP}


# ,-----
# |	Configure
# +-----

CTI_UCLIBC_DEV_CONFIGURED=${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP}/.config

.PHONY: cti-uClibc-dev-configured

cti-uClibc-dev-configured: cti-uClibc-dev-extracted ${CTI_UCLIBC_DEV_CONFIGURED}

${CTI_UCLIBC_DEV_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP} || exit 1 ;\
		[ -s .config ] \
		|| ( \
		case ${CTI_UCLIBC_DEV_VER} in \
		0.9.20) \
			echo 'KERNEL_SOURCE="'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux/"' ;\
			echo 'SHARED_LIB_LOADER_PATH="/lib"' ;\
			echo 'MALLOC=y' ;\
			echo 'MALLOC_STANDARD=y' \
		;; \
		0.9.26) \
			echo 'KERNEL_SOURCE="'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux/"' ;\
			echo 'SHARED_LIB_LOADER_PREFIX="/lib"' ;\
			echo 'RUNTIME_PREFIX="/"' ;\
			echo 'UCLIBC_HAS_SYS_SIGLIST=y' ;\
			echo 'MALLOC=y' ;\
			echo 'MALLOC_STANDARD=y' \
		;; \
		0.9.28*) \
			echo 'KERNEL_SOURCE="'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux/"' ;\
			echo 'SHARED_LIB_LOADER_PREFIX="/lib"' ;\
			echo 'RUNTIME_PREFIX="/"' ;\
			echo 'CROSS_COMPILER_PREFIX="'${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-"' ;\
			echo 'UCLIBC_HAS_SYS_SIGLIST=y' ;\
			echo '# UCLIBC_HAS_SHADOW is not set' ;\
			echo 'MALLOC=y' ;\
			echo 'MALLOC_STANDARD=y' \
		;; \
		0.9.29*) \
			echo 'KERNEL_HEADERS="'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include/"' ;\
			echo 'SHARED_LIB_LOADER_PREFIX="/lib"' ;\
			echo 'RUNTIME_PREFIX="/"' ;\
			echo 'CROSS_COMPILER_PREFIX="'${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-"' ;\
			echo 'UCLIBC_HAS_SYS_SIGLIST=y' ;\
			echo '# UCLIBC_HAS_SHADOW is not set' ;\
			echo 'UCLIBC_HAS_GNU_GLOB=y' ;\
			echo '# UCLIBC_BUILD_RELRO is not set' ;\
			echo '# UCLIBC_BUILD_NOEXECSTACK is not set' ;\
			echo 'MALLOC_STANDARD=y' \
		;; \
		*) \
			echo "$0: do_configure: Unexpected CTI_UCLIBC_DEV_VER ${CTI_UCLIBC_DEV_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		echo 'DEVEL_PREFIX="/usr/"' ;\
		case "${CTI_CPU}" in \
		i386) \
		      echo 'TARGET_ARCH="'${CTI_CPU}'"' ;\
		      echo 'TARGET_'${CTI_CPU}'=y' \
		;; \
		mips*)	\
		      echo 'TARGET_ARCH="mips"' ;\
		      echo 'TARGET_mips=y' ;\
		      [ ${CTI_CPU} = 'mips' ] && echo 'ARCH_SUPPORTS_BIG_ENDIAN=y' ;\
		      [ ${CTI_CPU} = 'mips' ] && echo 'ARCH_BIG_ENDIAN=y' ;\
		      [ ${CTI_CPU} = 'mipsel' ] && echo 'ARCH_LITTLE_ENDIAN=y' ;\
		      echo 'CONFIG_MIPS_ISA_MIPS32=y' \
		;; \
		*)	\
		      echo "Unexpected TARGET_CPU '${CTI_CPU}'" 1>&2 ;\
		      exit 1 \
		;; \
		esac ;\
		echo '# ASSUME_DEVPTS is not set' ;\
		echo 'DO_C99_MATH=y' ;\
		[ -r /lib/ld-linux.so.1 ] && echo '# DOPIC is not set' ;\
		[ -r /lib/ld-linux.so.1 ] && echo '# HAVE_SHARED is not set' ;\
		echo '# UCLIBC_HAS_IPV6 is not set' ;\
		echo '# UCLIBC_HAS_LFS is not set' ;\
		echo 'UCLIBC_HAS_RPC=y' ;\
		echo 'UCLIBC_HAS_FULL_RPC=y' ;\
		echo '# UCLIBC_HAS_CTYPE_UNSAFE is not set' ;\
		echo 'UCLIBC_HAS_CTYPE_CHECKED=y' ;\
		echo '# UNIX98PTY_ONLY is not set' \
		) > .config || exit 1 ;\
		for MF in libc/sysdeps/linux/*/Makefile ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed 's/-g,,/-g , ,/' \
				> $${MF} || exit 1 ;\
		done ;\
		case ${CTI_UCLIBC_DEV_VER} in \
		0.9.20) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD || exit 1 ;\
			cat Rules.mak.OLD \
				| sed	' /^CROSS/	s%=.*%= '${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-% ; /(CROSS)/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_GCC} | sed 's/gcc$$//'`'" ; fi)% ; /USE_CACHE/ s/#// ; /usr.bin.*awk/ s%/usr/bin/awk%'${AWK_EXE}'% ' > Rules.mak || exit 1 ;\
			[ -r ldso/util/Makefile.OLD ] || mv ldso/util/Makefile ldso/util/Makefile.OLD || exit 1 ;\
			cat ldso/util/Makefile.OLD \
				| sed 's%$$(HOSTCC)%'${NTI_GCC}'%' \
				> ldso/util/Makefile || exit 1 ;\
			[ -r ldso/util/bswap.h.OLD ] || mv ldso/util/bswap.h ldso/util/bswap.h.OLD || exit 1 ;\
			cat ldso/util/bswap.h.OLD \
				| sed 's%def __linux__%def __glibc_linux__ /* __linux__ */%' \
				| sed 's/<string.h>/"stdint.h"/' \
				> ldso/util/bswap.h || exit 1 \
		;; \
		0.9.26) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD || exit 1 ;\
			cat Rules.mak.OLD \
				| sed	' /^CROSS/	s%=.*%= '${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-% ; /(CROSS)/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_GCC} | sed 's/gcc$$//'`'" ; fi)% ; /USE_CACHE/ s/#// ; /usr.bin.*awk/ s%/usr/bin/awk%'${AWK_EXE}'% ' > Rules.mak || exit 1 \
		;; \
		0.9.2[89]*) ;; \
		*)	echo "$0: do_configure 'Makefile's: Unexpected CTI_UCLIBC_DEV_VER ${CTI_UCLIBC_DEV_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | ${MAKE} HOSTCC=${NTI_GCC} oldconfig \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

CTI_UCLIBC_DEV_BUILT=${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP}/libc/libc.a

.PHONY: cti-uClibc-dev-built
cti-uClibc-dev-built: cti-uClibc-dev-configured ${CTI_UCLIBC_DEV_BUILT}

${CTI_UCLIBC_DEV_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP} || exit 1 ;\
		${MAKE} || exit 1 ;\
		case ${CTI_UCLIBC_DEV_VER} in \
		0.9.20) \
			${MAKE} -C utils ldd.host || exit 1 \
		;; \
		0.9.26) \
			( cd utils && \
			${NTI_GCC} ldd.c -o ldd \
		                -DUCLIBC_RUNTIME_PREFIX='' \
		                -DUCLIBC_LDSO=ld-uClibc.so.0 \
			) \
		;; \
		esac \
	)


# ,-----
# |	Install
# +-----

CTI_UCLIBC_DEV_INSTALLED=${CTI_TC_ROOT}/etc/config-uClibc-${CTI_UCLIBC_DEV_VER}

.PHONY: cti-uClibc-dev-installed

cti-uClibc-dev-installed: cti-uClibc-dev-built ${CTI_UCLIBC_DEV_INSTALLED}

${CTI_UCLIBC_DEV_INSTALLED}:
	( cd ${EXTTEMP}/${CTI_UCLIBC_DEV_TEMP} || exit 1 ;\
		${MAKE} PREFIX=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/' install_dev || exit 1 ;\
		${MAKE} RUNTIME_PREFIX=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/' install_runtime || exit 1 ;\
		( cd ${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib || exit 1 ;\
			for SOBJ in *.so ; do [ -L $${SOBJ} ] && ln -sf $${SOBJ}.0 $${SOBJ} ; done \
		) || exit 1 ;\
		cp utils/ldd ${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-ldd || exit 1 ;\
		cp .config ${CTI_UCLIBC_DEV_INSTALLED} || exit 1 \
	) || exit 1


.PHONY: cti-uClibc-dev
cti-uClibc-dev: cti-cross-kgcc cti-lx24source cti-uClibc-dev-installed

TARGETS+= cti-uClibc-dev

endif	# HAVE_CTI_UCLIBC_DEV_CONFIG
