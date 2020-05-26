# lx26headers 2.4.34.1		[ since v2.0.37pre10, c.2002-10-04 ]
# last mod WmT, 2011-05-21	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LX26HEADERS_CONFIG},y)
HAVE_LX26HEADERS_CONFIG:=y

DESCRLIST+= "'lx26' -- linux 2.4 kernel"

CTI_LX26HEADERS_VER:=2.6.28
CTI_LX26HEADERS_SRC:=${SRCDIR}/l/linux-${CTI_LX26HEADERS_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.kernel.org/pub/linux/kernel/v2.6/linux-${CTI_LX26HEADERS_VER}.tar.bz2


include ${CFG_ROOT}/Config/ENV/ifbuild.env
include ${CFG_ROOT}/Config/ENV/native.mak
include ${CFG_ROOT}/Config/ENV/target.mak

include ${CFG_ROOT}/distrotools-ng/lx26-config/v${CTI_LX26HEADERS_VER}.mak

## ,-----
## |	package extract
## +-----

CTI_LX26HEADERS_TEMP=cti-lx26headers-${CTI_LX26HEADERS_VER}

CTI_LX26HEADERS_EXTRACTED=${EXTTEMP}/${CTI_LX26HEADERS_TEMP}/Makefile

CTI_LX26HEADERS_ARCH_OPTS= CROSS_COMPILE=${CTI_MIN_SPEC}-

.PHONY: cti-lx26headers-extracted
cti-lx26headers-extracted: ${CTI_LX26HEADERS_EXTRACTED}

${CTI_LX26HEADERS_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${CTI_LX26HEADERS_SRC}
	mv ${EXTTEMP}/linux-${CTI_LX26HEADERS_VER} ${EXTTEMP}/${CTI_LX26HEADERS_TEMP}
	( cd ${EXTTEMP}/${CTI_LX26HEADERS_TEMP} || exit 1 ;\
		case ${CTI_LX26HEADERS_VER} in \
		2.4.*.*) \
				[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
				cat Makefile.OLD \
					| sed '/^ARCH[ 	]*:*=/	s%\$$.*%'${CTI_CPU}'%' \
					| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
					> Makefile || exit 1 ;\
				[ -r arch/i386/boot/Makefile.OLD ] || mv arch/i386/boot/Makefile arch/i386/boot/Makefile.OLD || exit 1 ;\
				cat arch/i386/boot/Makefile.OLD \
					| sed '/^..86[ 	]=/	s%$$(CROSS_COMPILE)%'${CTI_ROOT}'/usr/bin/%' \
					> arch/i386/boot/Makefile || exit 1 \
		;; \
		2.6.28) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^ARCH[ 	]*:*=/	s%\$$.*%'${CTI_CPU}'%' \
				| sed '/^HOSTCC[ 	]*:*=/	s%g*cc%'${NTI_GCC}'%' \
				> Makefile || exit 1 \
		;; \
		esac \
	)

## ,-----
## |	package configure
## +-----

CTI_LX26HEADERS_CONFIGURED=${EXTTEMP}/${CTI_LX26HEADERS_TEMP}/.config

.PHONY: cti-lx26headers-configured
cti-lx26headers-configured: cti-lx26headers-extracted ${CTI_LX26HEADERS_CONFIGURED}

${CTI_LX26HEADERS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LX26HEADERS_TEMP} || exit 1 ;\
		make ${CTI_LX26HEADERS_ARCH_OPTS} mrproper || exit 1 ;\
		case ${CTI_LX26HEADERS_VER} in \
		2.4.*.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux24-${CTI_LX26HEADERS_VER} .config || exit 1 ;\
			make ${CTI_LX26HEADERS_ARCH_OPTS} symlinks || exit 1 ;\
		;; \
		2.6.*) \
			cp ${CTI_TC_ROOT}/etc/config-linux26-${CTI_LX26HEADERS_VER} .config || exit 1 ;\
		;; \
		*) \
			echo "CONFIGURE: Unexpected CTI_LX26HEADERS_VER ${CTI_LX26HEADERS_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make ${CTI_LX26HEADERS_ARCH_OPTS} oldconfig || exit 1 \
	)

## ,-----
## |	package build
## +-----

CTI_LX26HEADERS_BUILT=${EXTTEMP}/${CTI_LX26HEADERS_TEMP}/include/asm/.

.PHONY: cti-lx26headers-built
cti-lx26headers-built: cti-lx26headers-configured ${CTI_LX26HEADERS_BUILT}

${CTI_LX26HEADERS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LX26HEADERS_TEMP} || exit 1 ;\
		case ${CTI_LX26HEADERS_VER} in \
		2.4.*.*) \
			make ${CTI_LX26CONFIG_ARCH_OPTS} dep || exit 1 \
		;; \
		2.6.*) \
			make ${CTI_LX26CONFIG_ARCH_OPTS} prepare || exit 1 \
		;; \
		*) \
			echo "BUILD: Unexpected CTI_LX26HEADERS_VER ${CTI_LX26HEADERS_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

## ,-----
## |	package install
## +-----

CTI_LX26HEADERS_INSTALLED= ${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/include/asm/.

.PHONY: cti-lx26headers-installed
cti-lx26headers-installed: cti-lx26headers-built ${CTI_LX26HEADERS_INSTALLED}

${CTI_LX26HEADERS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include'
	case ${CTI_LX26HEADERS_VER} in \
	2.4.*.*) \
		mkdir -p ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux-'${CTI_LX26HEADERS_VER} \
	;; \
	esac
	( cd ${EXTTEMP}/${CTI_LX26HEADERS_TEMP} || exit 1 ;\
		case ${CTI_LX26HEADERS_VER}-${CTI_CPU} in \
		2.4.*.*-*) \
			( cd include/ >/dev/null && tar cvf - asm asm-${CTI_CPU} asm-generic linux ) | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include' && tar xf - ) ;\
			( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src' && ln -sf 'linux-'${CTI_LX26HEADERS_VER} linux ) || exit 1 ;\
			tar cvf - ./ | ( cd ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/src/linux' && tar xvf - ) \
		;; \
		2.6.28-i386) \
			make headers_install INSTALL_HDR_PATH=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/ || exit 1 \
		;; \
		*) \
			echo "INSTALL: Unexpected CTI_LX26HEADERS_VER ${CTI_LX26HEADERS_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

.PHONY: cti-lx26headers
cti-lx26headers: cti-lx26config cti-lx26headers-installed

NTARGETS+= cti-lx26headers

endif	# HAVE_CTI_LX26HEADERS_CONFIG
