# lx3x-binary 3.2.4		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_LX3XBINARY_CONFIG},y)
HAVE_LX3XBINARY_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'lx3x' -- linux 3.x kernel binary"

include ${CFG_ROOT}/distrotools-ng/lx3x-config/v${HAVE_TARGET_KERNEL_VER}.mak

#CTI_LX3XBINARY_VER:=3.0.4
CTI_LX3XBINARY_VER:=3.2.4
CTI_LX3XBINARY_SRC:=${SRCDIR}/l/linux-${CTI_LX3XBINARY_VER}.tar.bz2

URLS+= http://www.kernel.org/pub/linux/kernel/v3.0/linux-${CTI_LX3XBINARY_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LX3XBINARY_TEMP=cti-lx3xbinary-${CTI_LX3XBINARY_VER}

CTI_LX3XBINARY_EXTRACTED=${EXTTEMP}/${CTI_LX3XBINARY_TEMP}/Makefile

CTI_LX3XBINARY_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx3xbinary-extracted
cti-lx3xbinary-extracted: ${CTI_LX3XBINARY_EXTRACTED}

${CTI_LX3XBINARY_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX3XBINARY_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX3XBINARY_VER} ${EXTTEMP}/${CTI_LX3XBINARY_TEMP}
	( cd ${EXTTEMP}/${CTI_LX3XBINARY_TEMP} || exit 1 ;\
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

CTI_LX3XBINARY_CONFIGURED=${EXTTEMP}/${CTI_LX3XBINARY_TEMP}/.config

.PHONY: cti-lx3xbinary-configured
cti-lx3xbinary-configured: cti-lx3xbinary-extracted ${CTI_LX3XBINARY_CONFIGURED}

${CTI_LX3XBINARY_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX3XBINARY_TEMP} || exit 1 ;\
		make ${CTI_LX3XBINARY_ARCH_OPTS} mrproper || exit 1 ;\
		case ${CTI_LX3XBINARY_VER} in \
		2.4.*.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX3XBINARY_VER} .config || exit 1 ;\
			make ${CTI_LX3XBINARY_ARCH_OPTS} symlinks || exit 1 ;\
		;; \
		2.6.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX3XBINARY_VER} .config || exit 1 ;\
		;; \
		3.0.*|3.2.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux30-${CTI_LX3XBINARY_VER} .config || exit 1 ;\
		;; \
		*) \
			echo "CONFIGURE: Unexpected CTI_LX3XBINARY_VER ${CTI_LX3XBINARY_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make ${CTI_LX3XBINARY_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	Build
## +-----

CTI_LX3XBINARY_BUILT=${EXTTEMP}/${CTI_LX3XBINARY_TEMP}/arch/i386/boot/bzImage

.PHONY: cti-lx3xbinary-built
cti-lx3xbinary-built: cti-lx3xbinary-configured ${CTI_LX3XBINARY_BUILT}

${CTI_LX3XBINARY_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX3XBINARY_TEMP} || exit 1 ;\
		case ${CTI_LX3XBINARY_VER} in \
		2.6.*|3.0.*|3.2.*) \
			make ${CTI_LX3XCONFIG_ARCH_OPTS} prepare bzImage || exit 1 \
		;; \
		*) \
			echo "BUILD: Unexpected CTI_LX3XBINARY_VER ${CTI_LX3XBINARY_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

## ,-----
## |	Install
## +-----

CTI_LX3XBINARY_INSTALLED= ${CTI_TC_ROOT}/etc/vmlinuz-${CTI_LX3XBINARY_VER}

.PHONY: cti-lx3xbinary-installed
cti-lx3xbinary-installed: cti-lx3xbinary-built ${CTI_LX3XBINARY_INSTALLED}

${CTI_LX3XBINARY_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LX3XBINARY_temp} || exit 1 ;\
		cp ${CTI_LX3XBINARY_BUILT} ${CTI_LX3XBINARY_INSTALLED} \
	)

.PHONY: cti-lx3xbinary
cti-lx3xbinary: cti-lx3xconfig cti-lx3xbinary-installed

NTARGETS+= cti-lx3xbinary

endif	# HAVE_CTI_LX3XBINARY_CONFIG
