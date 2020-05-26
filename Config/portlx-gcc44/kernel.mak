#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

#URLS+= https://www.kernel.org/pub/linux/kernel/v3.0/linux-${KERNEL_VERSION}.tar.bz2
URLS+= https://www.kernel.org/pub/linux/kernel/v3.0/linux-${KERNEL_VERSION}.tar.gz

# dependencies: there are only 'nti' dependencies for headers
# TODO: the full kernel build requires the 'kgcc' compiler


CTI_LXHEADERS_SUBDIR	= cti-linux-${KERNEL_VERSION}
#CTI_LXHEADERS_ARCHIVE	= ${SOURCES}/l/linux-${KERNEL_VERSION}.tar.bz2
CTI_LXHEADERS_ARCHIVE	= ${SOURCES}/l/linux-${KERNEL_VERSION}.tar.gz
#CTI_LXHEADERS_PATCHES	= ${SOURCES}/l/linux-fixuClibc.patch

CTI_LXHEADERS_EXTRACTED	=  ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR}/README
CTI_LXHEADERS_CONFIGURED= ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR}/.config
CTI_LXHEADERS_BUILT	= ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR}/.config.old
#CTI_LXHEADERS_BUILT	= ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR}/include/generated/uapi/version.h
CTI_LXHEADERS_INSTALLED	= ${CTI_TC_ROOT}/etc/config-kernel-${KERNEL_VERSION}

CUI_KERNEL_SUBDIR	= cui-linux-${KERNEL_VERSION}
#CUI_KERNEL_ARCHIVE	= ${SOURCES}/l/linux-${KERNEL_VERSION}.tar.bz2
CUI_KERNEL_ARCHIVE	= ${SOURCES}/l/linux-${KERNEL_VERSION}.tar.gz
#CUI_LXHEADERS_PATCHES	= ${SOURCES}/l/linux-fixuClibc.patch

CUI_KERNEL_EXTRACTED	=  ${EXTTEMP}/${CUI_KERNEL_SUBDIR}/README
CUI_KERNEL_CONFIGURED	= ${EXTTEMP}/${CUI_KERNEL_SUBDIR}/.config
# /!\ 'x86' in later kernels, 'i386' earlier?
ifeq (${TARGCPU},i386)
CUI_KERNEL_BUILT	= ${EXTTEMP}/${CUI_KERNEL_SUBDIR}/arch/x86/boot/bzImage
CUI_KERNEL_INSTALLED	= ${CTI_TC_ROOT}/etc/vmlinuz-${KERNEL_VERSION}
else
CUI_KERNEL_BUILT	= ${EXTTEMP}/${CUI_KERNEL_SUBDIR}/arch/${TARGCPU}/boot/zImage
CUI_KERNEL_INSTALLED	= ${CTI_TC_ROOT}/etc/vmlinux-${KERNEL_VERSION}
endif


## ,-----
## |	Extract
## +-----

${CTI_LXHEADERS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#bzcat ${CTI_LXHEADERS_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	zcat ${CTI_LXHEADERS_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/linux-${KERNEL_VERSION} ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR}
#ifneq (${CTI_LXHEADERS_PATCHES},)
#	cd ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR} && patch -Np1 -i ${CTI_LXHEADERS_PATCHES}
#endif

${CUI_KERNEL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#bzcat ${CUI_KERNEL_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	zcat ${CUI_KERNEL_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/linux-${KERNEL_VERSION} ${EXTTEMP}/${CUI_KERNEL_SUBDIR}
#ifneq (${CUI_LXHEADERS_PATCHES},)
#	cd ${EXTTEMP}/${CUI_LXHEADERS_SUBDIR} && patch -Np1 -i ${CUI_LXHEADERS_PATCHES}
#endif


## ,-----
## |	Configure
## +-----

ifeq (${PREBUILT_XGCC},true)
LXHEADERS_COMPILER_PREFIX:= ${TARGSPEC}'-'
else
LXHEADERS_COMPILER_PREFIX:= ${TARGSPEC}'-k'
endif

# PCI, SCSI, SCSI_SYM53C8XX_2 useful for versatilepb HDD emulation?

# [2012-06-17] `make mrproper` here invoked cross compiler! (lx3.2.4)

${CTI_LXHEADERS_CONFIGURED}: ${CTI_LXHEADERS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
			| sed '/^CROSS_COMPILE/	s/?=.*/:= '${LXHEADERS_COMPILER_PREFIX}'/' \
		> Makefile ;\
		make mrproper ;\
		case ${TARGCPU} in \
		i386) \
                cp arch/x86/configs/i386_defconfig .config || exit 1 ;\
		scripts/config --enable X86 --enable X86_32 --disable X86_64 --disable 64BIT ;\
			scripts/config --enable MPENTIUMM \
		;; \
		arm) \
			cp arch/arm/configs/versatile_defconfig .config || exit 1 \
		;; \
		*) \
			echo "Unexpected TARGCPU value '${TARGCPU}'" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		scripts/config --enable EMBEDDED ;\
		scripts/config --enable IKCONFIG --enable IKCONFIG_PROC ;\
		scripts/config --enable IP_PNP_DHCP --enable DEVTMPFS --enable DEVTMPFS_MOUNT ;\
		scripts/config --enable ATA --enable ATA_PIIX --enable SATA_AHCI ;\
		scripts/config --enable PCI --enable SCSI --enable SCSI_SYM53C8XX_2 \
		scripts/config --enable HOTPLUG_PCI --enable HOTPLUG_PCI_PCIE ;\
		scripts/config --enable BLK_DEV_HD --enable BLK_DEV_SD ;\
		scripts/config --enable EXT2_FS --enable TMPFS --enable SQUASHFS --enable AFFS_FS ;\
		scripts/config --enable USB --enable USB_STORAGE ;\
		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
		scripts/config --enable SND_HDA_POWER_SAVE ;\
		scripts/config --disable ACPI ;\
		scripts/config --enable APM --enable APM_IGNORE_USER_SUSPEND --enable APM_DO_ENABLE --enable APM_CPU_IDLE --enable APM_DISPLAY_BLANK --enable APM_REAL_MODE_POWER_OFF --disable APM_RTC_IS_GMT --enable APM_ALLOW_INTS ;\
		mv .config ${CTI_LXHEADERS_CONFIGURED} ;\
		( \
		 	echo 'CONFIG_SND_HDA_INTEL=y' ;\
		 	echo 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10' ;\
		 	echo '# CONFIG_ACPI is not set' \
	 	) >> ${CTI_LXHEADERS_CONFIGURED} \
	)

${CUI_KERNEL_CONFIGURED}: ${CUI_KERNEL_EXTRACTED}
	echo "*** $@ ***"
	( cd ${EXTTEMP}/${CUI_KERNEL_SUBDIR} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
			| sed '/^CROSS_COMPILE/	s/?=.*/:= '${LXHEADERS_COMPILER_PREFIX}'/' \
		> Makefile ;\
		make mrproper ;\
		cp ${CTI_LXHEADERS_INSTALLED} .config || exit 1 \
	)


## ,-----
## |	Build
## +-----

CTI_LXHEADERS_VERBOSE=KBUILD_VERBOSE=1

${CTI_LXHEADERS_BUILT}: ${CTI_LXHEADERS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR} || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig \
	)

#CUI_LXHEADERS_VERBOSE=KBUILD_VERBOSE=1

${CUI_KERNEL_BUILT}: ${CUI_KERNEL_CONFIGURED}
	echo "*** $@ ***"
	( cd ${EXTTEMP}/${CUI_KERNEL_SUBDIR} || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig ;\
		make prepare || exit 1;\
		make \
	)


## ,-----
## |	Install
## +-----

## FIXME: better to use '.../linux-$VERSION' and make a 'linux' symlink?

${CTI_LXHEADERS_INSTALLED}: ${CTI_LXHEADERS_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LXHEADERS_SUBDIR} || exit 1 ;\
		make ${CTI_LXHEADERS_VERBOSE} headers_install INSTALL_HDR_PATH=${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/usr/' ;\
		mkdir -p ${CTI_TC_ROOT}/etc ;\
		cp .config ${CTI_LXHEADERS_INSTALLED} \
	)

.PHONY: cti-lxheaders
cti-lxheaders: ${CTI_LXHEADERS_INSTALLED}

##

${CUI_KERNEL_INSTALLED}: ${CUI_KERNEL_BUILT}
	echo "*** $@ ***"
	( cd ${EXTTEMP}/${CUI_KERNEL_SUBDIR} || exit 1 ;\
		cp ${CUI_KERNEL_BUILT} ${CUI_KERNEL_INSTALLED} \
	)


.PHONY: cui-kernel
cui-kernel: ${CUI_KERNEL_INSTALLED}
