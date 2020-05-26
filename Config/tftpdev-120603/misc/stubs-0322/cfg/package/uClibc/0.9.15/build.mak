#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-toolroot build-cross prelim

## UNIX98PTY_ONLY should be false for old kernels (tried: 2.0.39)
## DEVEL_PREFIX gives us /usr/include and friends
## SYSTEM_DEVEL_PREFIX gives i386-* binaries
prelim:
#	[ ! -d ${TOOLROOT}/usr/${CROSS_PREFIX} ] || rm -rf ${TOOLROOT}/usr/${CROSS_PREFIX}/*
	if [ -L Config ] ; then rm ./Config ; else true ; fi
	cp ./extra/Configs/Config.${TARGET_MACH} Config.OLD
	( cd extra/gcc-uClibc && ( \
		cp Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed 's/	gcc /	$${XPREFIX}gcc /' \
			> Makefile ;\
	) || exit 1 ) || exit 1

build-cross: build-toolroot
	[ -d "${INSTTMP}" ]
	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER}-rt ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}-rt
	make distclean
	cat Config.OLD \
		| sed "s%^DEVEL_PREFIX *=.*%%" \
		| sed "s%^SYSTEM_DEVEL_PREFIX *=.*%%" \
		| sed "s%^KERNEL_SOURCE *=.*%KERNEL_SOURCE=${TOOLROOT}/usr/src/linux%" \
		| sed "s%^SHARED_LIB_LOADER_PATH *=.*%SHARED_LIB_LOADER_PATH=/lib%" \
		| sed "s%^UNIX98PTY_ONLY *=.*%UNIX98PTY_ONLY=false%" \
		> ./Config
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make \
		CC=${CROSS_PREFIX}-gcc LD=${CROSS_PREFIX}-ld AR=${CROSS_PREFIX}-ar STRIPTOOL=${CROSS_PREFIX}-strip NATIVE_CC=${CROSS_PREFIX}-gcc XPREFIX=${CROSS_PREFIX}- \
		DEVEL_PREFIX=/usr/${CROSS_PREFIX}
	- PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make \
		CC=${CROSS_PREFIX}-gcc LD=${CROSS_PREFIX}-ld AR=${CROSS_PREFIX}-ar STRIPTOOL=${CROSS_PREFIX}-strip NATIVE_CC=${CROSS_PREFIX}-gcc XPREFIX=${CROSS_PREFIX}- \
		DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
		SYSTEM_DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
		PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER}/ install
	- PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make \
		CC=${CROSS_PREFIX}-gcc LD=${CROSS_PREFIX}-ld AR=${CROSS_PREFIX}-ar STRIPTOOL=${CROSS_PREFIX}-strip NATIVE_CC=${CROSS_PREFIX}-gcc XPREFIX=${CROSS_PREFIX}- \
		DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
		SYSTEM_DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
		PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER}-rt/ install_target
	( echo "#!/bin/sh" ; \
		echo `which ld` '$$@' "-L${DEVEL_PREFIX}/usr/lib -L${DEVEL_PREFIX}/lib crt0.o libc.so.0" ) \
		>${INSTTMP}/${PKGNAME}-${PKGVER}/usr/${CROSS_PREFIX}/bin/${CROSS_PREFIX}-ld
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr && ( \
		mkdir -p include ;\
		( cd include && ln -s ../${CROSS_PREFIX}/include/* ./ ) ;\
	) || exit 1 ) || exit 1

build-toolroot: prelim
#build: prelim
	[ "${CROSS_PREFIX}" ]
	cat Config.OLD \
		| sed "s%^DEVEL_PREFIX *=.*%%" \
		| sed "s%^SYSTEM_DEVEL_PREFIX *=.*%%" \
		| sed "s%^SHARED_LIB_LOADER_PATH *=.*%SHARED_LIB_LOADER_PATH=/lib%" \
		| sed "s%^UNIX98PTY_ONLY *=.*%UNIX98PTY_ONLY=false%" \
		> ./Config
	[ ! -r ${TOOLROOT}/usr/${CROSS_PREFIX} ] || rm -rf ${TOOLROOT}/usr/${CROSS_PREFIX}
	make DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX}
	- make DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} SYSTEM_DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} install
	- make PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} install_target
