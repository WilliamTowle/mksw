# lx24source 2.4.34.1		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2010-06-04	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LX24SOURCE_CONFIG},y)
HAVE_LX24SOURCE_CONFIG:=y

DESCRLIST+= "'lx24' -- linux 2.4 kernel"

CTI_LX24SOURCE_VER:=2.4.34.1
CTI_LX24SOURCE_SRC:=${SRCDIR}/l/linux-${CTI_LX24SOURCE_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.0/linux-${PKGVER}.tar.bz2


include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/lx24-config/v2.4.34.1.mak


## ,-----
## |	package extract
## +-----

CTI_LX24SOURCE_TEMP=cti-lx24source-${CTI_LX24SOURCE_VER}

CTI_LX24SOURCE_EXTRACTED=${EXTTEMP}/${CTI_LX24SOURCE_TEMP}/Makefile

CTI_LX24SOURCE_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx24source-extracted
cti-lx24source-extracted: ${CTI_LX24SOURCE_EXTRACTED}

${CTI_LX24SOURCE_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX24SOURCE_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX24SOURCE_VER} ${EXTTEMP}/${CTI_LX24SOURCE_TEMP}
	( cd ${EXTTEMP}/${CTI_LX24SOURCE_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ARCH[ 	]*:*=/	s%\$$.*%'${CTI_CPU}'%' \
			| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
			> Makefile || exit 1 ;\
		[ -r arch/i386/boot/Makefile.OLD ] || mv arch/i386/boot/Makefile arch/i386/boot/Makefile.OLD || exit 1 ;\
		cat arch/i386/boot/Makefile.OLD \
			| sed '/^..86[ 	]=/	s%$$(CROSS_COMPILE)%'${CTI_ROOT}'/usr/bin/%' \
			> arch/i386/boot/Makefile || exit 1 \
	)

## ,-----
## |	package configure
## +-----

CTI_LX24SOURCE_CONFIGURED=${EXTTEMP}/${CTI_LX24SOURCE_TEMP}/.config

.PHONY: cti-lx24source-configured
cti-lx24source-configured: cti-lx24source-extracted ${CTI_LX24SOURCE_CONFIGURED}

${CTI_LX24SOURCE_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX24SOURCE_TEMP} || exit 1 ;\
		make ${CTI_LX24SOURCE_ARCH_OPTS} mrproper || exit 1 ;\
		cp ${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX24SOURCE_VER} .config || exit 1 ;\
		make ${CTI_LX24SOURCE_ARCH_OPTS} symlinks || exit 1 ;\
		yes '' | make ${CTI_LX24SOURCE_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	package build
## +-----

CTI_LX24SOURCE_BUILT=${EXTTEMP}/${CTI_LX24SOURCE_TEMP}/.depend

.PHONY: cti-lx24source-built
cti-lx24source-built: cti-lx24source-configured ${CTI_LX24SOURCE_BUILT}

${CTI_LX24SOURCE_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX24SOURCE_TEMP} || exit 1 ;\
		make ${CTI_LX24CONFIG_ARCH_OPTS} dep || exit 1 \
	)

## ,-----
## |	package install
## +-----

CTI_LX24SOURCE_INSTALLED= ${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/include/asm/.

.PHONY: cti-lx24source-installed
cti-lx24source-installed: cti-lx24source-built ${CTI_LX24SOURCE_INSTALLED}

${CTI_LX24SOURCE_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include'
	mkdir -p ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux-'${CTI_LX24SOURCE_VER}
	( cd ${EXTTEMP}/${CTI_LX24SOURCE_TEMP} || exit 1 ;\
		( cd include/ >/dev/null && tar cvf - asm asm-${CTI_CPU} asm-generic linux ) | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include' && tar xf - ) ;\
		( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src' && ln -sf 'linux-'${CTI_LX24SOURCE_VER} linux ) || exit 1 ;\
		tar cvf - ./ | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux' && tar xvf - ) \
	)

.PHONY: cti-lx24source
cti-lx24source: cti-lx24config cti-lx24source-installed

TARGETS+= cti-lx24source

endif	# HAVE_CTI_LX24SOURCE_CONFIG
