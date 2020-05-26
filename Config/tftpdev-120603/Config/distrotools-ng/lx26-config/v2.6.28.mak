# lx26config 2.6.28		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2011-01-10	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LX26CONFIG_CONFIG},y)
HAVE_LX26CONFIG_CONFIG:=y

DESCRLIST+= "'lx26' -- linux 2.6 kernel"

include ${CFG_ROOT}/Config/ENV/ifbuild.env
include ${CFG_ROOT}/Config/ENV/native.mak
include ${CFG_ROOT}/Config/ENV/target.mak

include ${CFG_ROOT}/distrotools-ng/cross-kgcc/v${CTI_CROSS_GCC_VER}.mak

CTI_LX26CONFIG_VER:=2.6.28
CTI_LX26CONFIG_SRC:=${SRCDIR}/l/linux-${CTI_LX26CONFIG_VER}.tar.bz2

URLS+= http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.6/linux-${CTI_LX26CONFIG_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LX26CONFIG_TEMP=cti-lx26config-${CTI_LX26CONFIG_VER}

CTI_LX26CONFIG_EXTRACTED=${EXTTEMP}/${CTI_LX26CONFIG_TEMP}/Makefile

CTI_LX26CONFIG_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx26config-extracted
cti-lx26config-extracted: ${CTI_LX26CONFIG_EXTRACTED}

${CTI_LX26CONFIG_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX26CONFIG_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX26CONFIG_VER} ${EXTTEMP}/${CTI_LX26CONFIG_TEMP}
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ARCH[ 	]*:*=/	s%\$$.*%'${CTI_CPU}'%' \
			| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Configure
## +-----

CTI_LX26CONFIG_CONFIGURED=${EXTTEMP}/${CTI_LX26CONFIG_TEMP}/.config

.PHONY: cti-lx26config-configured
cti-lx26config-configured: cti-lx26config-extracted ${CTI_LX26CONFIG_CONFIGURED}

## 1. 'arch' subdirectory contains 'x86' (some point after v2.6.20.1)
## - Possibility 'CONFIG_EMBEDDED' broken for QEmu 0.12.4?
## - Possibility 'CONFIG_EMBEDDED' works but needs 'CONFIG_QEMU'

${CTI_LX26CONFIG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX26CONFIG_ARCH_OPTS} mrproper || exit 1 ;\
		cat arch/x86/configs/i386_defconfig \
			| sed '/ CONFIG_EMBEDDED / { s/^# // ; s/ is not set/=y/ }' \
			| sed '/ CONFIG_EXT2_FS / { s/^# // ; s/ is not set/=y/ }' \
			> .config ;\
		yes '' | make ${CTI_LX26CONFIG_ARCH_OPTS} oldconfig || exit 1 \
	)

#		cp /dev/null .config ;\
#		( \
#			echo 'CONFIG_BLK_DEV_INITRD=y' ;\
#			echo 'CONFIG_EMBEDDED=y' ;\
#			echo 'CONFIG_QEMU=y' \
#		) >> .config ;\


## ,-----
## |	Build
## +-----

#CTI_LX26CONFIG_BUILT=${EXTTEMP}/${CTI_LX26CONFIG_TEMP}/arch/${CTI_CPU}/boot/bzImage
CTI_LX26CONFIG_BUILT=${EXTTEMP}/${CTI_LX26CONFIG_TEMP}/arch/x86/boot/bzImage

.PHONY: cti-lx26config-built
cti-lx26config-built: cti-lx26config-configured ${CTI_LX26CONFIG_BUILT}

${CTI_LX26CONFIG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX26CONFIG_ARCH_OPTS} prepare || exit 1 ;\
		make ${CTI_LX26CONFIG_ARCH_OPTS} bzImage || exit 1 \
	)


## ,-----
## |	Install
## +-----

CTI_LX26CONFIG_INSTALLED=${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX26CONFIG_VER}

.PHONY: cti-lx26config-installed
cti-lx26config-installed: cti-lx26config-built ${CTI_LX26CONFIG_INSTALLED}

${CTI_LX26CONFIG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p $(shell dirname ${CTI_LX26CONFIG_INSTALLED}) || exit 1
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		cp ${CTI_LX26CONFIG_BUILT} `dirname ${CTI_LX26CONFIG_INSTALLED}`/vmlinuz-${CTI_LX26CONFIG_VER} || exit 1 ;\
		cp .config ${CTI_LX26CONFIG_INSTALLED} || exit 1 \
	)

.PHONY: cti-lx26config
cti-lx26config: cti-cross-kgcc cti-lx26config-installed

NTARGETS+= cti-lx26config

endif	# HAVE_CTI_LX26CONFIG_CONFIG
