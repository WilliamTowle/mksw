# lx20 2.0.40			[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2010-06-03	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LX20CONFIG_CONFIG},y)
HAVE_LX20CONFIG_CONFIG:=y

DESCRLIST+= "'lx20' -- linux 2.0 kernel"


include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

#include ${CFG_ROOT}/gcc2723/v2.7.2.3.mak
#include ${CFG_ROOT}/xtc-min-binutils/v2.16.1.mak


LX20_VER:=2.0.40
LX20_SRC:=${SRCDIR}/l/linux-${LX20_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.0/linux-${PKGVER}.tar.bz2

LX20_GCC=${HTC_ROOT}/usr/bin/${CTI_MIN_SPEC}-gcc
LX20_GCCINCDIR=$(shell ${LX20_GCC} -v 2>&1 | grep specs | sed 's/.* // ; s/specs/include/')


## ,-----
## |	package extract
## +-----

CTI_LX20CONFIG_TEMP=lx20config-${LX20_VER}

CTI_LX20CONFIG_EXTRACTED=${EXTTEMP}/${CTI_LX20CONFIG_TEMP}/Makefile

.PHONY: cti-lx20config-extracted
cti-lx20config-extracted: ${CTI_LX20CONFIG_EXTRACTED}

## 1. Fix $ARCH to suit build target
## 2. Configure.auto allows piping 'yes' to 'make oldconfig' in lx2.0
${CTI_LX20CONFIG_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${LX20_SRC}
	mv ${EXTTEMP}/linux-${LX20_VER} ${EXTTEMP}/${CTI_LX20CONFIG_TEMP}
	( cd ${EXTTEMP}/${CTI_LX20CONFIG_TEMP} || exit 1 ;\
		mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ARCH/ { s/^/#/ ; s/$$/\nARCH:= '${CTI_CPU}'/ }' \
			| sed '/^CROSS_COMPILE/ s%$$%'${CTI_MIN_SPEC}'-%' \
			| sed '/^CC/ s%$$.*%'${LX20_GCC}'%' \
			| sed '/^	/ s%scripts/Configure%scripts/Configure.auto% ' \
			> Makefile ;\
		sed 's%dev/tty%dev/stdin%' scripts/Configure > scripts/Configure.auto || exit 1 \
	)

## ,-----
## |	package configure
## +-----

CTI_LX20CONFIG_CONFIGURED=${EXTTEMP}/${CTI_LX20CONFIG_TEMP}/.config

.PHONY: cti-lx20config-configured
cti-lx20config-configured: cti-lx20config-extracted ${CTI_LX20CONFIG_CONFIGURED}

## *. Fix 2.9x configure: copying 'no' tree shouldn't grab the source
## *. --with-headers, --with-lib: target new (htc-local) C library
${CTI_LX20CONFIG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX20CONFIG_TEMP} || exit 1 ;\
		make mrproper || exit 1 ;\
		make include/linux/version.h ;\
		make symlinks ;\
		( cat arch/${CTI_CPU}/defconfig \
			| sed 's%#* *CONFIG_PARIDE_PCD[= ].*%##CONFIG_PARIDE_PCD: %' \
			| sed 's%#* *CONFIG_PARIDE_PT[= ].*%##CONFIG_PARIDE_PT: %' \
			| sed 's%#* *CONFIG_AFFS_FS[= ].*%##CONFIG_AFFS_FS: %' ;\
		  echo "CONFIG_PARIDE_PCD=y" ;\
		  echo "CONFIG_PARIDE_PT=y" ;\
		  echo "CONFIG_AFFS_FS=y" \
		) > .config || exit 1 ;\
		yes '' | make oldconfig || exit 1 ;\
	)

## ,-----
## |	package build
## +-----

CTI_LX20CONFIG_BUILT=${EXTTEMP}/arch/${CTI_CPU}/boot/bzImage

.PHONY: cti-lx20config-built
cti-lx20config-built: cti-lx20config-configured ${CTI_LX20CONFIG_BUILT}

## 1. Ensure native CC builds native code
## 2. Ensure legacy CC builds kernel
## 3. Overridden ${CC} must specify includes or assembly builds fail
${CTI_LX20CONFIG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX20CONFIG_TEMP} || exit 1 ;\
	echo "..." ; exit 1 ;\
		rm scripts/mkdep >/dev/null 2>&1 ;\
		make HOSTCC=${NATIVE_CC} dep || exit 1 ;\
		make bzImage CC="${LX20_GCC} -D__KERNEL__ -nostdinc -I${EXTTEMP}/${CTI_LX20CONFIG_TEMP}/include -I${LX20_GCCINCDIR}" CFLAGS="-O2 -fomit-frame-pointer" || exit 1 \
	)

## ,-----
## |	package install
## +-----

CTI_LX20CONFIG_INSTALLED=${CTI_TC_ROOT}/etc/config-linux20config-${LX20CONFIG_VER}

.PHONY: cti-lx20config-installed
cti-lx20config-installed: cti-lx20config-built ${LX20_INSTALLED}

${LX20_INSTALLED}: ${HTC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LX20CONFIG_TEMP} || exit 1 ;\
		cp .config ${CTI_LX20CONFIG_INSTALLED} || exit 1 ;\
	)

.PHONY: cti-lx20config
#cti-lx20config: gcc2723 xtc-min-binutils-installed cti-lx20config-installed
cti-lx20config: cti-lx20config-installed

TARGETS+= cti-lx20config

endif	# HAVE_LX20CONFIG_CONFIG
