# lx20 2.0.40			[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2010-06-03	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LX20_CONFIG},y)
HAVE_LX20_CONFIG:=y

DESCRLIST+= "'lx20' -- linux 2.0 kernel"


include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/gcc2723/v2.7.2.3.mak
include ${CFG_ROOT}/xtc-min-binutils/v2.16.1.mak



LX20_VER:=2.0.40
LX20_SRC:=${SRCDIR}/l/linux-${LX20_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.0/linux-${PKGVER}.tar.bz2


LX20_GCC=${HTC_ROOT}/usr/bin/${CTI_MIN_TRIPLET}-gcc
LX20_GCCINCDIR=$(shell ${LX20_GCC} -v 2>&1 | grep specs | sed 's/.* // ; s/specs/include/')


## ,-----
## |	package extract
## +-----

LX20_TEMP=lx20-${LX20_VER}

LX20_EXTRACTED=${EXTTEMP}/${LX20_TEMP}/Makefile

.PHONY: lx20-extracted
lx20-extracted: ${LX20_EXTRACTED}

## 1. Fix $ARCH to suit build target
## 2. Configure.auto allows piping 'yes' to 'make oldconfig' in lx2.0
${LX20_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${LX20_SRC}
	mv ${EXTTEMP}/linux-${LX20_VER} ${EXTTEMP}/${LX20_TEMP}
	( cd ${EXTTEMP}/${LX20_TEMP} || exit 1 ;\
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

LX20_CONFIGURED=${EXTTEMP}/${LX20_TEMP}/.config

.PHONY: lx20-configured
lx20-configured: lx20-extracted ${LX20_CONFIGURED}

## *. Fix 2.9x configure: copying 'no' tree shouldn't grab the source
## *. --with-headers, --with-lib: target new (htc-local) C library
${LX20_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${LX20_TEMP} || exit 1 ;\
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

LX20_BUILT=${EXTTEMP}/arch/${CTI_CPU}/boot/bzImage

.PHONY: lx20-built
lx20-built: lx20-configured ${LX20_BUILT}

## 1. Ensure native CC builds native code
## 2. Ensure legacy CC builds kernel
## 3. Overridden ${CC} must specify includes or assembly builds fail
${LX20_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${LX20_TEMP} || exit 1 ;\
		rm scripts/mkdep >/dev/null 2>&1 ;\
		make HOSTCC=${NATIVE_CC} dep || exit 1 ;\
		make bzImage CC="${LX20_GCC} -D__KERNEL__ -nostdinc -I${EXTTEMP}/${LX20_TEMP}/include -I${LX20_GCCINCDIR}" CFLAGS="-O2 -fomit-frame-pointer" || exit 1 \
	)

## ,-----
## |	package install
## +-----

LX20_INSTALLED=${HTC_ROOT}/usr/bin/${HOSTTC_SPEC}-gcc

.PHONY: lx20-installed
lx20-installed: lx20-built ${LX20_INSTALLED}

${LX20_INSTALLED}: ${HTC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${LX20_TEMP} || exit 1 ;\
		echo "?" 1>&2 ; exit 1 \
	)

.PHONY: lx20
lx20: gcc2723 xtc-min-binutils-installed lx20-installed

TARGETS+= lx20

endif	# HAVE_LX20_CONFIG
