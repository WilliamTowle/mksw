# lx26config 2.6.20.1		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2011-05-15	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LX26CONFIG_CONFIG},y)
HAVE_LX26CONFIG_CONFIG:=y

DESCRLIST+= "'lx26' -- linux 2.6 kernel"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/cross-kgcc/v4.1.2.mak


CTI_LX26CONFIG_VER:=2.6.20.1
#CTI_LX26CONFIG_VER:=2.6.28
CTI_LX26CONFIG_SRC:=${SRCDIR}/l/linux-${CTI_LX26CONFIG_VER}.tar.bz2

URLS+= http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.6/linux-${CTI_LX26CONFIG_VER}.tar.bz2


## ,-----
## |	package extract
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
		case ${CTI_CPU} in \
		mips*) \
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
## |	package configure
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
		case ${CTI_CPU} in \
		i386) \
		    cat arch/${CTI_CPU}/defconfig \
			    | sed '/CONFIG_M686[ =]/ { s/^/# / ; s/=y/ is not set/ }' \
			    | sed '/CONFIG_MPENTIUMM[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    | sed '/CONFIG_EMBEDDED[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    | sed '/CONFIG_APM[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    | sed '/CONFIG_ATL2[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    | sed '/CONFIG_ATL1C[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    | sed '/CONFIG_ACPI[ =]/ { s/^/# / ; s/=y/ is not set/ }' \
			    | sed '/CONFIG_BLK_DEV_FD[ =]/ { s/^# // ; s/ is not set/=y/ }' \
			    > .config.1 ;\
			( echo "CONFIG_APM_IGNORE_USER_SUSPEND=y" ;\
			  echo "CONFIG_APM_DO_ENABLE=y" ;\
			  echo "CONFIG_APM_CPU_IDLE=y" ;\
			  echo "CONFIG_APM_DISPLAY_BLANK=y" ;\
			  echo "# CONFIG_APM_RTC_IS_GMT is not set" ;\
			  echo "CONFIG_APM_ALLOW_INTS=y" \
			) >> .config.1 \
		;; \
		arm*) \
			cat arch/arm/configs/versatile_defconfig \
				| sed '/CONFIG_EMBEDDED[ =]/ { s/^# // ; s/ is not set/=y/ }' \
				> .config.1 \
		;; \
		mips*) \
			cat arch/mips/configs/ip22_defconfig \
				| sed '/CONFIG_QEMU[ =]/ { s/^# // ; s/ is not set/=y/ }' \
				> .config.1 \
		;; \
		*) \
			echo "Unexpected CTI_CPU ${CTI_CPU}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		cat .config.1 \
			| sed '/CONFIG_BLK_DEV_LOOP[ =]/ { s/^# // ; s/ is not set/=y/ ; s/=m/=y/ }' \
			| sed '/CONFIG_BLK_DEV_INITRD[ =]/ { s/^# // ; s/ is not set/=y/ ; s/=m/=y/ }' \
			| sed '/CONFIG_IDE[ =]/ { s/^# // ; s/ is not set/=y/ ; s/=m/=y/ }' \
			| sed '/CONFIG_EXT2_FS[ =]/ { s/^# // ; s/ is not set/=y/ ; s/=m/=y/ }' \
			> .config || exit 1 ;\
		yes '' | make ${CTI_LX26CONFIG_ARCH_OPTS} oldconfig || exit 1 \
	)


## ,-----
## |	package build
## +-----

CTI_LX26CONFIG_BUILT=${EXTTEMP}/${CTI_LX26CONFIG_TEMP}/include/asm/.

.PHONY: cti-lx26config-built
cti-lx26config-built: cti-lx26config-configured ${CTI_LX26CONFIG_BUILT}

${CTI_LX26CONFIG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		make ${CTI_LX26CONFIG_ARCH_OPTS} prepare || exit 1 ;\
		case ${CTI_CPU} in \
		arm*|mips*) \
			make ${CTI_LX26CONFIG_ARCH_OPTS} vmlinux || exit 1 \
		;; \
		*)	make ${CTI_LX26CONFIG_ARCH_OPTS} bzImage || exit 1 \
		;; \
		esac \
	)

## ,-----
## |	package install
## +-----

CTI_LX26CONFIG_INSTALLED=${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX26CONFIG_VER}

.PHONY: cti-lx26config-installed
cti-lx26config-installed: cti-lx26config-built ${CTI_LX26CONFIG_INSTALLED}

${CTI_LX26CONFIG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p $(shell dirname ${CTI_LX26CONFIG_INSTALLED}) || exit 1
	( cd ${EXTTEMP}/${CTI_LX26CONFIG_TEMP} || exit 1 ;\
		case ${CTI_CPU} in \
		arm*|mips*)	;; \
		*)	cp arch/i386/boot/bzImage `dirname ${CTI_LX26CONFIG_INSTALLED}`/vmlinuz-${CTI_LX26CONFIG_VER} || exit 1 \
		;; \
		esac ;\
		cp .config ${CTI_LX26CONFIG_INSTALLED} || exit 1 \
	)

.PHONY: cti-lx26config
cti-lx26config: cti-cross-kgcc cti-lx26config-installed

TARGETS+= cti-lx26config

endif	# HAVE_CTI_LX26CONFIG_CONFIG
