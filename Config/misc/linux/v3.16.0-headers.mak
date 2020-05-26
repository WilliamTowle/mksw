# linux v3.16.0			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2016-09-17	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_LXHDRS_CONFIG},y)
HAVE_LXHDRS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-lxheaders' -- linux"

ifeq (${LXHDRS_VERSION},)
# longterm: 3.2.x, 3.4.x, 3.10.x, 3.12.x
# stable: 3.14.x, 3.15.x
# previous: 2.6.32.27
#LXHDRS_VERSION=3.2.4
#LXHDRS_VERSION=3.4.94
#LXHDRS_VERSION=3.6.11
#LXHDRS_VERSION=3.9.11
#LXHDRS_VERSION=3.15.1
LXHDRS_VERSION=3.16.7-ckt25
#LXHDRS_VERSION=3.16.36
endif

#LXHDRS_SRC=${SOURCES}/l/linux-${LXHDRS_VERSION}.tar.bz2
#LXHDRS_SRC=${SOURCES}/l/linux-${LXHDRS_VERSION}.tar.gz
LXHDRS_SRC=${SOURCES}/l/linux_${LXHDRS_VERSION}.orig.tar.xz
#URLS+= https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LXHDRS_VERSION}.tar.bz2
#URLS+= https://www.kernel.org/pub/linux/kernel/v3.x/linux-${LXHDRS_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/linux/linux_${LXHDRS_VERSION}.orig.tar.xz

SYSTEM_HAS_BASH:=$(shell [ -r /bin/bash ] && echo y)

#include ${CFG_ROOT}/tui/bash/v4.3.mak
#include ${CFG_ROOT}/misc/bc/v1.06.mak
#include ${CFG_ROOT}/perl/perl/v5.18.4.mak

LXHDRS_MAKE_OPTS=
#ifneq (${SYSTEM_HAS_BASH},y)
#LXHDRS_MAKE_OPTS+=CONFIG_SHELL=${NTI_TC_ROOT}/bin/bash
#LXHDRS_MAKE_OPTS+=PERL=${NTI_TC_ROOT}/usr/bin/perl
#endif

NTI_LXHDRS_TEMP=nti-lxheaders-${LXHDRS_VERSION}

NTI_LXHDRS_EXTRACTED=${EXTTEMP}/${NTI_LXHDRS_TEMP}/README
NTI_LXHDRS_CONFIGURED=${EXTTEMP}/${NTI_LXHDRS_TEMP}/.config
NTI_LXHDRS_BUILT=${EXTTEMP}/${NTI_LXHDRS_TEMP}/arch/x86/boot/bzImage
#NTI_LXHDRS_BUILT=${EXTTEMP}/${NTI_LXHDRS_TEMP}/vmlinux
NTI_LXHDRS_INSTALLED=${NTI_TC_ROOT}/etc/vmlinux-${LXHDRS_VERSION}_nti
#NTI_LXHDRS_INSTALLED=${NTI_TC_ROOT}/etc/vmlinux_nti


## ,-----
## |	Extract
## +-----

${NTI_LXHDRS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linux-${LXHDRS_VERSION} ] || rm -rf ${EXTTEMP}/linux-${LXHDRS_VERSION}
	#bzcat ${LXHDRS_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${LXHDRS_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${LXHDRS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LXHDRS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LXHDRS_TEMP}
	mv ${EXTTEMP}/linux-${LXHDRS_VERSION} ${EXTTEMP}/${NTI_LXHDRS_TEMP}


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

## TODO: nasty version hack :( is it a) working b) betterable?
## TODO: see portlx - in which ${NTI_TC_ROOT}/etc is used

${NTI_LXHDRS_CONFIGURED}: ${NTI_LXHDRS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LXHDRS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^SUBLEVEL/	s/=.*/= 0/' \
			| sed '/^EXTRAVERSION/	s/=.*/= 4-686-pae/' \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
		> Makefile ;\
		${MAKE} mrproper ;\
		cp /boot/config-3.16.0-4-686-pae .config || exit 1 ;\
		if [ "${SYSTEM_HAS_BASH}" != 'y' ] ; then \
			[ -r scripts/config.OLD ] || mv scripts/config scripts/config.OLD || exit 1 ;\
			cat scripts/config.OLD | sed 's%^#!%#!'${NTI_TC_ROOT}'%' > scripts/config ;\
			chmod a+x scripts/config ;\
		fi \
	)
#		if [ "${USE_IKCONFIG}" = 'true' ] ; then \
#			zcat /proc/config.gz > .config ;\
#		else \
#			cp arch/x86/configs/i386_defconfig .config || exit 1 ;\
#		fi ;\
#		if [ "${SYSTEM_HAS_BASH}" != 'y' ] ; then \
#			[ -r scripts/config.OLD ] || mv scripts/config scripts/config.OLD || exit 1 ;\
#			cat scripts/config.OLD | sed 's%^#!%#!'${NTI_TC_ROOT}'%' > scripts/config ;\
#			chmod a+x scripts/config ;\
#		fi ;\
#		echo 'Standard options...' ;\
#		scripts/config --enable X86 --enable X86_32 --disable X86_64 --disable 64BIT ;\
#		scripts/config --enable M686 --disable MPENTIUMM --enable HIGHMEM64G --enable X86_PAE ;\
#		scripts/config --enable EMBEDDED ;\
#		scripts/config --enable MODULES --enable MODVERSIONS ;\
#		scripts/config --enable IKCONFIG --enable IKCONFIG_PROC ;\
#		scripts/config --enable ATA --enable ATA_PIIX --enable SATA_AHCI ;\
#		scripts/config --enable PCI --enable HOTPLUG_PCI --enable HOTPLUG_PCI_PCIE --enable ITCO_WDT ;\
#		scripts/config --enable MMC --enable MMC_SDHCI --enable MMC_SDHCI_PCI --enable MMC_RICOH_MMC --enable MMC_VIA_SDMMC;\
#		scripts/config --enable BLK_DEV_HD --enable BLK_DEV_SD ;\
#		scripts/config --enable USB --enable USB_STORAGE_REALTEK ;\
#		echo 'Filesystem options...' ;\
#		scripts/config --enable SHMEM --enable TMPFS ;\
#		scripts/config --enable DEVTMPFS --disable DEVTMPFS_MOUNT ;\
#		scripts/config --enable EXT2_FS ;\
#		scripts/config --enable AFFS_FS ;\
#		echo 'Sound options...' ;\
#		scripts/config --enable SND ;\
#		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
#		scripts/config --enable SND_HDA_POWER_SAVE ;\
#		echo 'Graphics options...' ;\
#		scripts/config --enable FB --enable FB_INTEL --enable FRAMEBUFFER_CONSOLE ;\
#		scripts/config --enable DRM_KMS_HELPER --enable DRM_I915 --enable DRM_I915_KMS ;\
#		echo 'Miscellaneous other options...' ;\
#		scripts/config --enable INPUT_MOUSEDEV_PSAUX ;\
#		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
#		scripts/config --enable NET_VENDOR_VIA --enable VIA_RHINE ;\
#		scripts/config --enable WLAN --enable CFG80211 --enable MAC80211 --enable STAGING --enable R8187SE --enable IWLWIFI ;\
#		scripts/config --disable ACPI ;\
#		scripts/config --enable APM --enable APM_IGNORE_USER_SUSPEND --enable APM_DO_ENABLE --enable APM_CPU_IDLE --enable APM_DISPLAY_BLANK --enable APM_REAL_MODE_POWER_OFF --disable APM_RTC_IS_GMT --enable APM_ALLOW_INTS ;\
#		( \
#		 	echo 'CONFIG_SND_HDA_INTEL=y' ;\
#		 	echo 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10' \
#	 	) >> ${NTI_LXHDRS_CONFIGURED} \
#	)


## ,-----
## |	Build
## +-----

${NTI_LXHDRS_BUILT}: ${NTI_LXHDRS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LXHDRS_TEMP} || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig ;\
		make prepare modules_prepare ;\
		touch ${NTI_LXHDRS_BUILT} \
	)


## ,-----
## |	Install
## +-----

${NTI_LXHDRS_INSTALLED}: ${NTI_LXHDRS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LXHDRS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/src/linux-${LXHDRS_VERSION} || exit 1 ;\
		( cd ${NTI_TC_ROOT}/usr/src && ln -sf linux-${LXHDRS_VERSION} linux ) || exit 1 ;\
		( tar cvf - .config * ) | ( cd ${NTI_TC_ROOT}/usr/src/linux-${LXHDRS_VERSION} && tar xvf - ) ;\
		touch ${NTI_LXHDRS_INSTALLED} \
	)

##

.PHONY: nti-lxheaders
nti-lxheaders: ${NTI_LXHDRS_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-lxheaders
#ALL_NTI_TARGETS+= nti-bash nti-bc nti-perl nti-lxheaders

endif	# HAVE_LXHDRS_CONFIG
