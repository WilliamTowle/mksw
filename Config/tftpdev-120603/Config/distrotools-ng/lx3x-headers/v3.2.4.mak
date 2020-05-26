# lx3xheaders 3.2.4		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_LX3XHEADERS_CONFIG},y)
HAVE_LX3XHEADERS_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'lx3x' -- linux 3.x kernel"

include ${CFG_ROOT}/distrotools-ng/lx3x-config/v${HAVE_TARGET_KERNEL_VER}.mak

#CTI_LX3XHEADERS_VER:=3.0.4
CTI_LX3XHEADERS_VER:=3.2.4
CTI_LX3XHEADERS_SRC:=${SRCDIR}/l/linux-${CTI_LX3XHEADERS_VER}.tar.bz2

URLS+= http://www.kernel.org/pub/linux/kernel/v3.0/linux-${CTI_LX3XHEADERS_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LX3XHEADERS_TEMP=cti-lx3xheaders-${CTI_LX3XHEADERS_VER}

CTI_LX3XHEADERS_EXTRACTED=${EXTTEMP}/${CTI_LX3XHEADERS_TEMP}/Makefile

CTI_LX3XHEADERS_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx3xheaders-extracted
cti-lx3xheaders-extracted: ${CTI_LX3XHEADERS_EXTRACTED}

${CTI_LX3XHEADERS_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX3XHEADERS_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX3XHEADERS_VER} ${EXTTEMP}/${CTI_LX3XHEADERS_TEMP}
	( cd ${EXTTEMP}/${CTI_LX3XHEADERS_TEMP} || exit 1 ;\
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

CTI_LX3XHEADERS_CONFIGURED=${EXTTEMP}/${CTI_LX3XHEADERS_TEMP}/.config

.PHONY: cti-lx3xheaders-configured
cti-lx3xheaders-configured: cti-lx3xheaders-extracted ${CTI_LX3XHEADERS_CONFIGURED}

${CTI_LX3XHEADERS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX3XHEADERS_TEMP} || exit 1 ;\
		make ${CTI_LX3XHEADERS_ARCH_OPTS} mrproper || exit 1 ;\
		case ${CTI_LX3XHEADERS_VER} in \
		2.4.*.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX3XHEADERS_VER} .config || exit 1 ;\
			make ${CTI_LX3XHEADERS_ARCH_OPTS} symlinks || exit 1 ;\
		;; \
		2.6.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX3XHEADERS_VER} .config || exit 1 ;\
		;; \
		3.0.*|3.2.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux30-${CTI_LX3XHEADERS_VER} .config || exit 1 ;\
		;; \
		*) \
			echo "CONFIGURE: Unexpected CTI_LX3XHEADERS_VER ${CTI_LX3XHEADERS_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make ${CTI_LX3XHEADERS_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	Build
## +-----

#CTI_LX3XHEADERS_BUILT=${EXTTEMP}/${CTI_LX3XHEADERS_TEMP}/include/asm/.
CTI_LX3XHEADERS_BUILT=${EXTTEMP}/${CTI_LX3XHEADERS_TEMP}/.missing-syscalls.d

.PHONY: cti-lx3xheaders-built
cti-lx3xheaders-built: cti-lx3xheaders-configured ${CTI_LX3XHEADERS_BUILT}

${CTI_LX3XHEADERS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX3XHEADERS_TEMP} || exit 1 ;\
		case ${CTI_LX3XHEADERS_VER} in \
		2.4.*.*) \
			make ${CTI_LX3XCONFIG_ARCH_OPTS} dep || exit 1 \
		;; \
		2.6.*|3.0.*|3.2.*) \
			make ${CTI_LX3XCONFIG_ARCH_OPTS} prepare || exit 1 \
		;; \
		*) \
			echo "BUILD: Unexpected CTI_LX3XHEADERS_VER ${CTI_LX3XHEADERS_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

## ,-----
## |	Install
## +-----

CTI_LX3XHEADERS_INSTALLED= ${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/include/asm/.

.PHONY: cti-lx3xheaders-installed
cti-lx3xheaders-installed: cti-lx3xheaders-built ${CTI_LX3XHEADERS_INSTALLED}

${CTI_LX3XHEADERS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LX3XHEADERS_TEMP} || exit 1 ;\
		case ${CTI_LX3XHEADERS_VER}-${CTI_CPU} in \
		2.4.*.*-*) \
			( cd include/ >/dev/null && tar cvf - asm asm-${CTI_CPU} asm-generic linux ) | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include' && tar xf - ) ;\
			( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src' && ln -sf 'linux-'${CTI_LX3XHEADERS_VER} linux ) || exit 1 ;\
			tar cvf - ./ | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux' && tar xvf - ) \
		;; \
		2.6.[23]*-*|3.0.*|3.2.*) \
			make headers_install INSTALL_HDR_PATH=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/' || exit 1 \
		;; \
		*) \
			echo "INSTALL: Unexpected CTI_LX3XHEADERS_VER/CTI_CPU ${CTI_LX3XHEADERS_VER}/${CTI_CPU}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

.PHONY: cti-lx3xheaders
cti-lx3xheaders: cti-lx3xconfig cti-lx3xheaders-installed

NTARGETS+= cti-lx3xheaders

endif	# HAVE_CTI_LX3XHEADERS_CONFIG
