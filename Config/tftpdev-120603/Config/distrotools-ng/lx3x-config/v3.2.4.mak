# lx3xconfig 3.2.4		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_LX3XCONFIG_CONFIG},y)
HAVE_LX3XCONFIG_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'lx3x' -- linux 3.x kernel"

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-kgcc/v${HAVE_CROSS_GCC_VER}.mak
endif

#CTI_LX3XCONFIG_VER:=3.0.4
CTI_LX3XCONFIG_VER:=3.2.4
CTI_LX3XCONFIG_SRC:=${SRCDIR}/l/linux-${CTI_LX3XCONFIG_VER}.tar.bz2

URLS+= http://www.kernel.org/pub/linux/kernel/v3.0/linux-${CTI_LX3XCONFIG_VER}.tar.bz2



## ,-----
## |	Extract
## +-----

CTI_LX3XCONFIG_TEMP=cti-lx3xconfig-${CTI_LX3XCONFIG_VER}

CTI_LX3XCONFIG_EXTRACTED=${EXTTEMP}/${CTI_LX3XCONFIG_TEMP}/Makefile

CTI_LX3XCONFIG_ARCH_OPTS=CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx3xconfig-extracted
cti-lx3xconfig-extracted: ${CTI_LX3XCONFIG_EXTRACTED}

${CTI_LX3XCONFIG_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX3XCONFIG_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX3XCONFIG_VER} ${EXTTEMP}/${CTI_LX3XCONFIG_TEMP}
	( cd ${EXTTEMP}/${CTI_LX3XCONFIG_TEMP} || exit 1 ;\
		case ${CTI_CPU} in \
		arm) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^ARCH[ 	]*[:?]*=/	s%\$$.*%arm%' \
				| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
				> Makefile || exit 1 \
		;; \
		mipsel) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^ARCH[ 	]*[:?]*=/	s%\$$.*%mips%' \
				| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
				> Makefile || exit 1 \
		;; \
		*) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^ARCH[ 	]*[:?]*=/	s%\$$.*%'${CTI_CPU}'%' \
				| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
				> Makefile || exit 1 \
		;; \
		esac \
	)

## ,-----
## |	Configure
## +-----

CTI_LX3XCONFIG_CONFIGURED=${EXTTEMP}/${CTI_LX3XCONFIG_TEMP}/.config

.PHONY: cti-lx3xconfig-configured
cti-lx3xconfig-configured: cti-lx3xconfig-extracted ${CTI_LX3XCONFIG_CONFIGURED}

## 1. 'arch' subdirectory contains 'x86' (some point after v2.6.20.1)
## - Possibility 'CONFIG_EMBEDDED' broken for QEmu 0.12.4?
## - Possibility 'CONFIG_EMBEDDED' works but needs 'CONFIG_QEMU'
## - Possibility 'CONFIG_PCCARD' (PCMCIA/CardBus) required for Willow

## 2. For EeePC-friendly sound:
## - need ALSA for PCI devices; adding:
## - SND_HDA_INTEL
## - SND_HDA_CODEC_REALTEK
## - SND_HDA_POWER_SAVE
## - SND_HDA_POWER_SAVE_DEFAULT 10


${CTI_LX3XCONFIG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX3XCONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX3XCONFIG_ARCH_OPTS} mrproper || exit 1 ;\
		case ${CTI_CPU} in \
		i386) \
			cp arch/x86/configs/i386_defconfig .config ;\
			( echo '# CONFIG_M686 is not set' ;\
			  echo 'CONFIG_MPENTIUMM=y' ;\
			  echo 'CONFIG_EMBEDDED=y' ;\
			  echo 'CONFIG_EXT2_FS=y' ;\
			  echo 'CONFIG_APM=y' ;\
			  echo 'CONFIG_ATL2=y' ;\
			  echo 'CONFIG_ATL1E=y' ;\
			  echo 'CONFIG_ATH_COMMON=y' ;\
			  echo '# CONFIG_ACPI is not set' ;\
			  echo 'CONFIG_BLK_DEV_HD=y' ;\
			  echo 'CONFIG_APM_IGNORE_USER_SUSPEND=y' ;\
			  echo 'CONFIG_APM_DO_ENABLE=y' ;\
			  echo 'CONFIG_APM_CPU_IDLE=y' ;\
			  echo 'CONFIG_APM_DISPLAY_BLANK=y' ;\
			  echo '# CONFIG_APM_RTC_IS_GMT is not set' ;\
			  echo 'CONFIG_APM_ALLOW_INTS=y' ;\
			  echo 'CONFIG_SND_HDA_INTEL=y' ;\
			  echo 'CONFIG_SND_HDA_CODEC_REALTEK=y' ;\
			  echo 'CONFIG_SND_HDA_POWER_SAVE=y' ;\
			  echo 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10' ;\
			  echo 'CONFIG_AFFS_FS=y' \
			) >> .config \
		;; \
		arm|mips*) \
			( echo 'CONFIG_EMBEDDED=y' ;\
			  echo 'CONFIG_EXT2_FS=y' ;\
			  echo 'CONFIG_APM=y' \
			) > .config \
		;; \
		*) \
			echo "Unexpected CTI_CPU ${CTI_CPU}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make ${CTI_LX3XCONFIG_ARCH_OPTS} oldconfig || exit 1 \
	)


## ,-----
## |	Build
## +-----

CTI_LX3XCONFIG_BUILT=${EXTTEMP}/${CTI_LX3XCONFIG_TEMP}/.missing-syscalls.d

.PHONY: cti-lx3xconfig-built
cti-lx3xconfig-built: cti-lx3xconfig-configured ${CTI_LX3XCONFIG_BUILT}

${CTI_LX3XCONFIG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX3XCONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX3XCONFIG_ARCH_OPTS} prepare || exit 1 \
	)
#		case ${CTI_CPU} in \
#		arm|mipsel)	make ${CTI_LX3XCONFIG_ARCH_OPTS} vmlinux || exit 1 \
#		;; \
#		*)	make ${CTI_LX3XCONFIG_ARCH_OPTS} bzImage || exit 1 \
#		;; \
#		esac \

## ,-----
## |	Install
## +-----

CTI_LX3XCONFIG_INSTALLED=${CTI_TC_ROOT}/etc/config-linux30-${CTI_LX3XCONFIG_VER}

.PHONY: cti-lx3xconfig-installed
cti-lx3xconfig-installed: cti-lx3xconfig-built ${CTI_LX3XCONFIG_INSTALLED}

${CTI_LX3XCONFIG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p $(shell dirname ${CTI_LX3XCONFIG_INSTALLED}) || exit 1
	( cd ${EXTTEMP}/${CTI_LX3XCONFIG_TEMP} || exit 1 ;\
		cp .config ${CTI_LX3XCONFIG_INSTALLED} || exit 1 \
	)

.PHONY: cti-lx3xconfig
cti-lx3xconfig: cti-cross-kgcc cti-lx3xconfig-installed

NTARGETS+= cti-lx3xconfig

endif	# HAVE_CTI_LX3XCONFIG_CONFIG
