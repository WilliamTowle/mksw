#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

URLS+= http://www.uclibc.org/downloads/uClibc-${UCLIBC_VERSION}.tar.bz2

# TODO: deps: kernel compiler

CTI_UCLDEV_SUBDIR=	cti-ucldev-${UCLIBC_VERSION}
CTI_UCLDEV_ARCHIVE= ${SOURCES}/u/uClibc-${UCLIBC_VERSION}.tar.bz2

CTI_UCLDEV_EXTRACTED=  ${EXTTEMP}/${CTI_UCLDEV_SUBDIR}/README
CTI_UCLDEV_CONFIGURED= ${EXTTEMP}/${CTI_UCLDEV_SUBDIR}/.config.in
CTI_UCLDEV_BUILT= ${EXTTEMP}/${CTI_UCLDEV_SUBDIR}/lib/crtn.o
CTI_UCLDEV_INSTALLED= ${CTI_TC_ROOT}/etc/config-uClibc-${UCLIBC_VERSION}


## ,-----
## |	Extract
## +-----

${CTI_UCLDEV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${CTI_UCLDEV_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/uClibc-${UCLIBC_VERSION} ${EXTTEMP}/${CTI_UCLDEV_SUBDIR}


## ,-----
## |	Configure
## +-----

ifeq (${PREBUILT_XGCC},true)
UCLDEV_COMPILER_PREFIX:= ${TARGSPEC}'-'
else
UCLDEV_COMPILER_PREFIX:= ${TARGSPEC}'-k'
endif

ifeq (${LEGACY},true)
# UCLIBC_SUSV3_LEGACY is for usleep() support (eg. busybox networking and login)
# UCLIBC_SUSV4_LEGACY is for tempnam() support (eg. busybox mktemp)

${CTI_UCLDEV_CONFIGURED}: ${CTI_UCLDEV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLDEV_SUBDIR} || exit 1 ;\
		( \
	 	 echo 'TARGET_ARCH="'${TARGCPU}'"' ;\
	 	 echo 'TARGET_'${TARGCPU}'=y' ;\
		 \
		 echo 'KERNEL_SOURCE="'${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/usr/"' ;\
		 echo 'SHARED_LIB_LOADER_PREFIX="/lib"' ;\
	 	 echo 'DEVEL_PREFIX="/"' ;\
		 echo 'RUNTIME_PREFIX="/"' ;\
		 \
		 echo 'UCLIBC_SUSV3_LEGACY=y' ;\
		 echo 'UCLIBC_SUSV4_LEGACY=y' \
	 	) > ${CTI_UCLDEV_CONFIGURED} \
	)
else
# UCLIBC_SUSV3_LEGACY provides usleep() (eg. busybox networking/login)
# UCLIBC_SUSV4_LEGACY provides tempnam() (eg. busybox mktemp)

ifeq (${TARGCPU},mipsel)
CTI_UCLDEV_ARCH=mips
else	# 'mips' and all non-MIPS
CTI_UCLDEV_ARCH=${TARGCPU}
endif

## [2017-01-20] ARCH_SUPPORTS_BIG_ENDIAN -> ARCH_ANY_ENDIAN?
## [2017-01-20] CONFIG_MIPS_O32_ABI=y, CONFIG_MIPS_ISA_MIPS32=y: for ip22?

${CTI_UCLDEV_CONFIGURED}: ${CTI_UCLDEV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLDEV_SUBDIR} || exit 1 ;\
		( \
	 	 echo 'TARGET_ARCH="'${CTI_UCLDEV_ARCH}'"' ;\
	 	 echo 'TARGET_'${CTI_UCLDEV_ARCH}'=y' ;\
		 [ "${LEGACY}" != true ] && echo 'CROSS_COMPILER_PREFIX="'${UCLDEV_COMPILER_PREFIX}'"' ;\
		 \
		 echo 'KERNEL_HEADERS="'${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/usr/include/"' ;\
		 echo 'SHARED_LIB_LOADER_PREFIX="/lib/"' ;\
	 	 echo 'DEVEL_PREFIX="/usr/"' ;\
		 echo 'RUNTIME_PREFIX="/"' ;\
		 \
		 echo 'UCLIBC_SUSV3_LEGACY=y' ;\
		 echo 'UCLIBC_SUSV4_LEGACY=y' \
	 	) > ${CTI_UCLDEV_CONFIGURED} ;\
		case ${TARGCPU} in \
		arm) \
			echo '# ARCH_ANY_ENDIAN is not set' ;\
			echo 'ARCH_WANTS_LITTLE_ENDIAN=y' \
		;; \
		mips|mipsel) \
			echo '# ARCH_ANY_ENDIAN is not set' ;\
			echo 'CONFIG_MIPS_O32_ABI=y' ;\
			echo 'CONFIG_MIPS_ISA_MIPS32=y' ;\
			[ "${TARGCPU}" = 'mips' ] && echo 'ARCH_WANTS_BIG_ENDIAN=y' ;\
			[ "${TARGCPU}" = 'mips' ] && echo 'ARCH_BIG_ENDIAN=y' ;\
			[ "${TARGCPU}" = 'mipsel' ] && echo 'ARCH_WANTS_LITTLE_ENDIAN=y' ;\
			[ "${TARGCPU}" = 'mipsel' ] && echo '# ARCH_BIG_ENDIAN is not set' \
		;; \
		esac >> ${CTI_UCLDEV_CONFIGURED} \
	)
endif


## ,-----
## |	Build
## +-----

UCLDEV_VERBOSE=V=2

${CTI_UCLDEV_BUILT}: ${CTI_UCLDEV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLDEV_SUBDIR} || exit 1 ;\
		cp .config.in .config ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig ;\
		make headers startfiles \
	)


## ,-----
## |	Install
## +-----

# 1. CDPATH='' for install_headers due to `(cd ...) | ...` use
# 2. install_dev triggers install_runtime and install_{headers|startfiles}
#? use full compiler for runtime components build? or is libgcc special?

${CTI_UCLDEV_INSTALLED}: ${CTI_UCLDEV_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLDEV_SUBDIR} || exit 1 ;\
		CDPATH='' make PREFIX=${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/' DEVEL_PREFIX='/usr/' install_headers install_startfiles ${UCLDEV_VERBOSE} || exit 1 ;\
		mkdir -p ${CTI_TC_ROOT}/etc/ ;\
		cp .config ${CTI_UCLDEV_INSTALLED} \
	)

.PHONY: cti-ucldev
cti-ucldev: ${CTI_UCLDEV_INSTALLED}
