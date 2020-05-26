# linux v2.6.34			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2013-04-01	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LINUX_CONFIG},y)
HAVE_LINUX_CONFIG:=y

#DESCRLIST+= "'nti-linux' -- linux"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${LINUX_VERSION},)
#LINUX_VERSION=2.6.32
LINUX_VERSION=2.6.34
#LINUX_VERSION=3.2.4
endif

LINUX_SRC=${SOURCES}/l/linux-${LINUX_VERSION}.tar.bz2
URLS+= https://www.kernel.org/pub/linux/kernel/v3.0/linux-${KERNEL_VERSION}.tar.bz2

include ${CFG_ROOT}/ENV/buildtype.mak

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
	[ ! -d ${EXTTEMP}/${NTI_LINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUX_TEMP}
	mv ${EXTTEMP}/linux-${LINUX_VERSION} ${EXTTEMP}/${NTI_LINUX_TEMP}

##

${CTI_LINUX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linux-${LINUX_VERSION} ] || rm -rf ${EXTTEMP}/linux-${LINUX_VERSION}
	bzcat ${LINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_LINUX_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LINUX_TEMP}
	mv ${EXTTEMP}/linux-${LINUX_VERSION} ${EXTTEMP}/${CTI_LINUX_TEMP}


## ,-----
## |	Configure
## +-----

# [2012-06-17] `make mrproper` here invoked cross compiler! (lx3.2.4)

${NTI_LINUX_CONFIGURED}: ${NTI_LINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^ARCH/		s/?=.*/:= '${TARGCPU}'/' \
		> Makefile ;\
		make mrproper ;\
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
		scripts/config --enable EXT2_FS --enable AFFS_FS ;\
		scripts/config --enable USB ;\
		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
		echo 'Sound options...' ;\
		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
		scripts/config --enable SND_HDA_POWER_SAVE ;\
		echo 'Graphics options...' ;\
		scripts/config --disable DRM_I915 --enable FB --enable FB_INTEL --enable FRAMEBUFFER_CONSOLE ;\
		echo 'Miscellaneous other options...' ;\
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
		make mrproper ;\
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
		scripts/config --enable EXT2_FS --enable AFFS_FS ;\
		scripts/config --enable USB ;\
		scripts/config --enable ATH_COMMON --enable ATL2 --enable ATL1E ;\
		echo 'Sound options...' ;\
		scripts/config --enable SND_HDA_INTEL --enable SND_HDA_CODEC_REALTEK ;\
		scripts/config --enable SND_HDA_POWER_SAVE ;\
		echo 'Graphics options...' ;\
		scripts/config --disable DRM_I915 --enable FB --enable FB_INTEL ;\
		echo 'Miscellaneous other options...' ;\
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
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig ;\
		make \
	)

##

${CTI_LINUX_BUILT}: ${CTI_LINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LINUX_TEMP} || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig ;\
		make \
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

ALL_NTI_TARGETS+= nti-linux

##

.PHONY: cti-linux
cti-linux: ${CTI_LINUX_INSTALLED}

ALL_CTI_TARGETS+= cti-linux

endif	# HAVE_LINUX_CONFIG
