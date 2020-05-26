# lx24config 2.4.34.1		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2010-06-04	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LX24CONFIG_CONFIG},y)
HAVE_LX24CONFIG_CONFIG:=y

DESCRLIST+= "'lx24' -- linux 2.4 kernel"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/cross-kgcc/v2.95.3.mak


CTI_LX24CONFIG_VER:=2.4.34.1
CTI_LX24CONFIG_SRC:=${SRCDIR}/l/linux-${CTI_LX24CONFIG_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.0/linux-${PKGVER}.tar.bz2


## ,-----
## |	package extract
## +-----

CTI_LX24CONFIG_TEMP=cti-lx24config-${CTI_LX24CONFIG_VER}

CTI_LX24CONFIG_EXTRACTED=${EXTTEMP}/${CTI_LX24CONFIG_TEMP}/Makefile

CTI_LX24CONFIG_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx24config-extracted
cti-lx24config-extracted: ${CTI_LX24CONFIG_EXTRACTED}

${CTI_LX24CONFIG_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX24CONFIG_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX24CONFIG_VER} ${EXTTEMP}/${CTI_LX24CONFIG_TEMP}
	( cd ${EXTTEMP}/${CTI_LX24CONFIG_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ARCH[ 	]*:*=/	s%\$$.*%'${CTI_CPU}'%' \
			| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
			> Makefile || exit 1 ;\
		[ -r arch/i386/boot/Makefile.OLD ] || mv arch/i386/boot/Makefile arch/i386/boot/Makefile.OLD || exit 1 ;\
		cat arch/i386/boot/Makefile.OLD \
			| sed '/^..86[ 	]=/	s%$$(CROSS_COMPILE)%'${CTI_ROOT}'/usr/bin/%' \
			> arch/i386/boot/Makefile || exit 1 \
	)

## ,-----
## |	package configure
## +-----

CTI_LX24CONFIG_CONFIGURED=${EXTTEMP}/${CTI_LX24CONFIG_TEMP}/.config

.PHONY: cti-lx24config-configured
cti-lx24config-configured: cti-lx24config-extracted ${CTI_LX24CONFIG_CONFIGURED}

## *. Fix 2.9x configure: copying 'no' tree shouldn't grab the source
## *. --with-headers, --with-lib: target new (nti-local) C library
${CTI_LX24CONFIG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX24CONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX24CONFIG_ARCH_OPTS} mrproper || exit 1 ;\
		cat arch/${CTI_CPU}/defconfig \
			| sed	'/CONFIG_MPENT/		s/^/# /' \
			| sed	'/CONFIG_M386/		s/^# //' \
			| sed	'/CONFIG_BLK_DEV_LOOP/ s/^# //' \
			| sed	'/CONFIG_BLK_DEV_RAM/	s/^# //' \
			| sed	'/CONFIG_BLK_DEV_INITRD/ s/^# //' \
			| sed	'/CONFIG_MINIX_FS/ s/^# //' \
			| sed	'/^CONFIG.*not set/	s/ is not set/=y/ ; /^#.*=y/		s/=y/ is not set/ ' \
			> .config ;\
		make ${CTI_LX24CONFIG_ARCH_OPTS} symlinks || exit 1 ;\
		yes '' | make ${CTI_LX24CONFIG_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	package build
## +-----

HAVE_KERNEL_BUILD?=y
ifeq (${HAVE_KERNEL_BUILD},n)
CTI_LX24CONFIG_BUILT=${EXTTEMP}/${CTI_LX24CONFIG_TEMP}/arch/${CTI_CPU}/boot/bzImage
else
CTI_LX24CONFIG_BUILT=${EXTTEMP}/${CTI_LX24CONFIG_TEMP}/arch/${CTI_CPU}/boot/bzImage
endif

.PHONY: cti-lx24config-built
cti-lx24config-built: cti-lx24config-configured ${CTI_LX24CONFIG_BUILT}

${CTI_LX24CONFIG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX24CONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX24CONFIG_ARCH_OPTS} dep || exit 1 ;\
		case ${HAVE_KERNEL_BUILD} in \
		y)	make ${CTI_LX24CONFIG_ARCH_OPTS} bzImage || exit 1 \
		;; n) exit 1 \
		;; \
		esac \
	)

## ,-----
## |	package install
## +-----

CTI_LX24CONFIG_INSTALLED=${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX24CONFIG_VER}

.PHONY: cti-lx24config-installed
cti-lx24config-installed: cti-lx24config-built ${CTI_LX24CONFIG_INSTALLED}

${CTI_LX24CONFIG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p $(shell dirname ${CTI_LX24CONFIG_INSTALLED}) || exit 1
	( cd ${EXTTEMP}/${CTI_LX24CONFIG_TEMP} || exit 1 ;\
		cp .config ${CTI_LX24CONFIG_INSTALLED} || exit 1 ;\
		cp ${CTI_LX24CONFIG_BUILT} `dirname ${CTI_LX24CONFIG_INSTALLED}`/vmlinuz-${CTI_LX24CONFIG_VER} || exit 1 \
	)

.PHONY: cti-lx24config
cti-lx24config: cti-cross-kgcc cti-lx24config-installed

TARGETS+= cti-lx24config

endif	# HAVE_CTI_LX24CONFIG_CONFIG
