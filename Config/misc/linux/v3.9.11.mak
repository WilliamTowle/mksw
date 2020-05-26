# linux v3.9.11			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2014-11-14	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LINUX_CONFIG},y)
HAVE_LINUX_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-linux' -- linux"

ifeq (${LINUX_VERSION},)
# longterm: 3.2.x, 3.4.x, 3.10.x, 3.12.x
# stable: 3.14.x, 3.15.x
# previous: 2.6.32.27
#LINUX_VERSION=3.2.4
#LINUX_VERSION=3.4.94
#LINUX_VERSION=3.6.11
LINUX_VERSION=3.9.11
#LINUX_VERSION=3.15.1
endif

LINUX_SRC=${SOURCES}/l/linux-${LINUX_VERSION}.tar.bz2
#LINUX_SRC=${SOURCES}/l/linux-${LINUX_VERSION}.tar.gz
URLS+= https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LINUX_VERSION}.tar.bz2
#URLS+= https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LINUX_VERSION}.tar.gz

SYSTEM_HAS_BASH:=$(shell [ -r /bin/bash ] && echo y)

include ${CFG_ROOT}/tui/bash/v4.3.mak
include ${CFG_ROOT}/misc/bc/v1.06.mak
#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak

ifneq (${SYSTEM_HAS_BASH},y)
LINUX_MAKE_OPTS=CONFIG_SHELL=${NTI_TC_ROOT}/bin/bash PERL=${NTI_TC_ROOT}/usr/bin/perl
endif

NTI_LINUX_TEMP=nti-linux-${LINUX_VERSION}
CTI_LINUX_TEMP=cti-linux-${LINUX_VERSION}

NTI_LINUX_EXTRACTED=${EXTTEMP}/${NTI_LINUX_TEMP}/README
NTI_LINUX_CONFIGURED=${EXTTEMP}/${NTI_LINUX_TEMP}/.config
NTI_LINUX_BUILT=${EXTTEMP}/${NTI_LINUX_TEMP}/arch/x86/boot/bzImage
#NTI_LINUX_BUILT=${EXTTEMP}/${NTI_LINUX_TEMP}/vmlinux
NTI_LINUX_INSTALLED=${NTI_TC_ROOT}/etc/vmlinux-${LINUX_VERSION}_nti
#NTI_LINUX_INSTALLED=${NTI_TC_ROOT}/etc/vmlinux_nti

CTI_LINUX_EXTRACTED=${EXTTEMP}/${CTI_LINUX_TEMP}/README
CTI_LINUX_CONFIGURED=${EXTTEMP}/${CTI_LINUX_TEMP}/.config
CTI_LINUX_BUILT=${EXTTEMP}/${CTI_LINUX_TEMP}/arch/x86/boot/bzImage
CTI_LINUX_INSTALLED=${CTI_TC_ROOT}/etc/vmlinux-${LINUX_VERSION}_cti


## ,-----
## |	Extract
## +-----

${NTI_LINUX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linux-${LINUX_VERSION} ] || rm -rf ${EXTTEMP}/linux-${LINUX_VERSION}
	bzcat ${LINUX_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${LINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUX_TEMP}
	mv ${EXTTEMP}/linux-${LINUX_VERSION} ${EXTTEMP}/${NTI_LINUX_TEMP}

##

${CTI_LINUX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linux-${LINUX_VERSION} ] || rm -rf ${EXTTEMP}/linux-${LINUX_VERSION}
	#bzcat ${LINUX_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${LINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_LINUX_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LINUX_TEMP}
	mv ${EXTTEMP}/linux-${LINUX_VERSION} ${EXTTEMP}/${CTI_LINUX_TEMP}


## ,-----
## |	Configure
## +-----

# [2012-06-17] `make mrproper` here invoked cross compiler! (lx3.2.4)
# [2013-03-31] Problem with 'trap' (busybox ash compatibility?)
##		[ -r scripts/link-vmlinux.sh.OLD ] || cp scripts/link-vmlinux.sh scripts/link-vmlinux.sh.OLD || exit 1 ;\
##		sed '/^trap/	s/ *ERR */ /' scripts/link-vmlinux.sh.OLD > scripts/link-vmlinux.sh ;\
# [2014-03-08] 'scripts/config' needs /bin/bash
# [2014-11-14] ThinkPad: IWLWIFI, ITCO_WDT
# [2014-11-14] ThinkPad: MMC_{SDHCI|SDHCI_PCI}, MMC_{RICOH_MMC,VIA_SDMMC}?

${NTI_LINUX_CONFIGURED}: ${NTI_LINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
		> Makefile ;\
		${MAKE} mrproper ;\
		if [ "${USE_IKCONFIG}" = 'true' ] ; then \
			zcat /proc/config.gz > .config ;\
		else \
			cp arch/x86/configs/i386_defconfig .config || exit 1 ;\
		fi ;\
		if [ "${SYSTEM_HAS_BASH}" != 'y' ] ; then \
			[ -r scripts/config.OLD ] || mv scripts/config scripts/config.OLD || exit 1 ;\
			cat scripts/config.OLD | sed 's%^#!%#!'${NTI_TC_ROOT}'%' > scripts/config ;\
			chmod a+x scripts/config ;\
		fi ;\
		echo 'Standard options...' ;\
		scripts/config --enable X86 --enable X86_32 --disable X86_64 --disable 64BIT ;\
		scripts/config --enable MPENTIUMM ;\
		scripts/config --enable EMBEDDED ;\
		scripts/config --enable IKCONFIG --enable IKCONFIG_PROC ;\
		scripts/config --enable ATA --enable ATA_PIIX --enable SATA_AHCI ;\
		scripts/config --enable PCI --enable HOTPLUG_PCI --enable HOTPLUG_PCI_PCIE --enable ITCO_WDT ;\
		scripts/config --enable MMC --enable MMC_SDHCI --enable MMC_SDHCI_PCI --enable MMC_RICOH_MMC --enable MMC_VIA_SDMMC;\
		scripts/config --enable BLK_DEV_HD --enable BLK_DEV_SD ;\
		scripts/config --enable USB --enable USB_STORAGE_REALTEK ;\
		echo 'Filesystem options...' ;\
		scripts/config --enable SHMEM --enable TMPFS ;\
		scripts/config --enable DEVTMPFS --disable DEVTMPFS_MOUNT ;\
		scripts/config --enable EXT2_FS ;\
		scripts/config --enable AFFS_FS ;\
		echo 'Sound options...' ;\
		scripts/config --enable SND ;\
		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
		scripts/config --enable SND_HDA_POWER_SAVE ;\
		echo 'Graphics options...' ;\
		scripts/config --enable FB --enable FB_INTEL --enable FRAMEBUFFER_CONSOLE ;\
		scripts/config --enable DRM_KMS_HELPER --enable DRM_I915 --enable DRM_I915_KMS ;\
		echo 'Miscellaneous other options...' ;\
		scripts/config --enable INPUT_MOUSEDEV_PSAUX ;\
		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
		scripts/config --enable NET_VENDOR_VIA --enable VIA_RHINE ;\
		scripts/config --enable WLAN --enable CFG80211 --enable MAC80211 --enable STAGING --enable R8187SE --enable IWLWIFI ;\
		scripts/config --disable ACPI ;\
		scripts/config --enable APM --enable APM_IGNORE_USER_SUSPEND --enable APM_DO_ENABLE --enable APM_CPU_IDLE --enable APM_DISPLAY_BLANK --enable APM_REAL_MODE_POWER_OFF --disable APM_RTC_IS_GMT --enable APM_ALLOW_INTS ;\
		( \
		 	echo 'CONFIG_SND_HDA_INTEL=y' ;\
		 	echo 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10' \
	 	) >> ${NTI_LINUX_CONFIGURED} \
	)

##

${CTI_LINUX_CONFIGURED}: ${CTI_LINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LINUX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
			| sed '/^CROSS_COMPILE/	s/?=.*/:= '${TARGSPEC}'-k/' \
		> Makefile ;\
		${MAKE} mrproper ;\
		if [ "${USE_IKCONFIG}" = 'true' ] ; then \
			zcat /proc/config.gz > .config ;\
		else \
			cp arch/x86/configs/i386_defconfig .config || exit 1 ;\
		fi ;\
		echo 'Standard options...' ;\
		scripts/config --enable X86 --enable X86_32 --disable X86_64 --disable 64BIT ;\
		scripts/config --enable MPENTIUMM ;\
		scripts/config --enable EMBEDDED ;\
		scripts/config --enable IKCONFIG --enable IKCONFIG_PROC ;\
		scripts/config --enable ATA --enable ATA_PIIX --enable SATA_AHCI ;\
		scripts/config --enable HOTPLUG_PCI --enable HOTPLUG_PCI_PCIE ;\
		scripts/config --enable BLK_DEV_HD --enable BLK_DEV_SD ;\
		scripts/config --enable USB ;\
		echo 'Filesystem options...' ;\
		scripts/config --enable SHMEM --enable TMPFS ;\
		scripts/config --enable EXT2_FS ;\
		scripts/config --enable AFFS_FS ;\
		echo 'Sound options...' ;\
		scripts/config --enable SND ;\
		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
		scripts/config --enable SND_HDA_POWER_SAVE ;\
		echo 'Video options...' ;\
		scripts/config --disable DRM_I915 --enable FB --enable FB_INTEL --enable FRAMEBUFFER_CONSOLE ;\
		echo 'Miscellaneous hardware options...' ;\
		scripts/config --enable INPUT_MOUSEDEV_PSAUX ;\
		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
		scripts/config --disable ACPI ;\
		scripts/config --enable APM --enable APM_IGNORE_USER_SUSPEND --enable APM_DO_ENABLE --enable APM_CPU_IDLE --enable APM_DISPLAY_BLANK --enable APM_REAL_MODE_POWER_OFF --disable APM_RTC_IS_GMT --enable APM_ALLOW_INTS ;\
		( \
		 	echo 'CONFIG_SND_HDA_INTEL=y' ;\
		 	echo 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10' \
	 	) >> ${CTI_LINUX_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_LINUX_BUILT}: ${NTI_LINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_TEMP} || exit 1 ;\
	 	yes '' | ${MAKE} HOSTCC=${NTI_GCC} ${LINUX_MAKE_OPTS} oldconfig ;\
		${MAKE} ${LINUX_MAKE_OPTS} \
	)

##

${CTI_LINUX_BUILT}: ${CTI_LINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LINUX_TEMP} || exit 1 ;\
	 	yes '' | ${MAKE} HOSTCC=${NTI_GCC} oldconfig ;\
		${MAKE} \
	)


## ,-----
## |	Install
## +-----

${NTI_LINUX_INSTALLED}: ${NTI_LINUX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_TEMP} || exit 1 ;\
		mkdir -p `dirname ${NTI_LINUX_INSTALLED}` ;\
		cp ${NTI_LINUX_BUILT} ${NTI_LINUX_INSTALLED} \
	)

##

${CTI_LINUX_INSTALLED}: ${CTI_LINUX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LINUX_TEMP} || exit 1 ;\
		mkdir -p `dirname ${CTI_LINUX_INSTALLED}` ;\
		cp ${CTI_LINUX_BUILT} ${CTI_LINUX_INSTALLED} \
	)

##

.PHONY: nti-linux
nti-linux: ${NTI_LINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-bash nti-bc nti-perl nti-linux

##

.PHONY: cti-linux
cti-linux: ${CTI_LINUX_INSTALLED}

ALL_CTI_TARGETS+= cti-linux

endif	# HAVE_LINUX_CONFIG
