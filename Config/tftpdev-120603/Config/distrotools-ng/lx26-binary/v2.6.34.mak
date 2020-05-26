# lx26binary 2.6.34		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2011-05-21	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LX26BINARY_CONFIG},y)
HAVE_LX26BINARY_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'lx26' -- linux 2.6 kernel binary"

include ${CFG_ROOT}/distrotools-ng/lx26-config/v${HAVE_TARGET_KERNEL_VER}.mak

CTI_LX26BINARY_VER:=${HAVE_TARGET_KERNEL_VER}
CTI_LX26BINARY_SRC:=${SRCDIR}/l/linux-${CTI_LX26BINARY_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.6/linux-${CTI_LX26BINARY_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LX26BINARY_TEMP=cti-lx26binary-${CTI_LX26BINARY_VER}

CTI_LX26BINARY_EXTRACTED=${EXTTEMP}/${CTI_LX26BINARY_TEMP}/Makefile

CTI_LX26BINARY_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx26binary-extracted
cti-lx26binary-extracted: ${CTI_LX26BINARY_EXTRACTED}

${CTI_LX26BINARY_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX26BINARY_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX26BINARY_VER} ${EXTTEMP}/${CTI_LX26BINARY_TEMP}
	( cd ${EXTTEMP}/${CTI_LX26BINARY_TEMP} || exit 1 ;\
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

CTI_LX26BINARY_CONFIGURED=${EXTTEMP}/${CTI_LX26BINARY_TEMP}/.config

.PHONY: cti-lx26binary-configured
cti-lx26binary-configured: cti-lx26binary-extracted ${CTI_LX26BINARY_CONFIGURED}

${CTI_LX26BINARY_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX26BINARY_TEMP} || exit 1 ;\
		make ${CTI_LX26BINARY_ARCH_OPTS} mrproper || exit 1 ;\
		case ${CTI_LX26BINARY_VER} in \
		2.4.*.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX26BINARY_VER} .config || exit 1 ;\
			make ${CTI_LX26BINARY_ARCH_OPTS} symlinks || exit 1 ;\
		;; \
		2.6.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX26BINARY_VER} .config || exit 1 ;\
		;; \
		*) \
			echo "CONFIGURE: Unexpected CTI_LX26BINARY_VER ${CTI_LX26BINARY_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make ${CTI_LX26BINARY_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	Build
## +-----

CTI_LX26BINARY_BUILT=${EXTTEMP}/${CTI_LX26BINARY_TEMP}/arch/i386/boot/bzImage

.PHONY: cti-lx26binary-built
cti-lx26binary-built: cti-lx26binary-configured ${CTI_LX26BINARY_BUILT}

${CTI_LX26BINARY_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX26BINARY_TEMP} || exit 1 ;\
		case ${CTI_LX26BINARY_VER} in \
		2.6.*) \
			make ${CTI_LX26CONFIG_ARCH_OPTS} prepare bzImage || exit 1 \
		;; \
		*) \
			echo "BUILD: Unexpected CTI_LX26BINARY_VER ${CTI_LX26BINARY_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

## ,-----
## |	Install
## +-----

CTI_LX26BINARY_INSTALLED= ${CTI_TC_ROOT}/etc/vmlinuz-${CTI_LX26BINARY_VER}

.PHONY: cti-lx26binary-installed
cti-lx26binary-installed: cti-lx26binary-built ${CTI_LX26BINARY_INSTALLED}

${CTI_LX26BINARY_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LX26BINARY_temp} || exit 1 ;\
		cp ${CTI_LX26BINARY_BUILT} ${CTI_LX26BINARY_INSTALLED} \
	)

.PHONY: cti-lx26binary
cti-lx26binary: cti-lx26config cti-lx26binary-installed

NTARGETS+= cti-lx26binary

endif	# HAVE_CTI_LX26BINARY_CONFIG
