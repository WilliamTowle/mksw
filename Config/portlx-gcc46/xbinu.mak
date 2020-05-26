#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

URLS+= http://mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2

# dependencies: there are only 'nti' dependencies for this package

CTI_BINUTILS_SUBDIR=	cti-binutils-${BINUTILS_VERSION}
CTI_BINUTILS_ARCHIVE=	${SOURCES}/b/binutils-${BINUTILS_VERSION}.tar.bz2

CTI_BINUTILS_EXTRACTED=	${EXTTEMP}/${CTI_BINUTILS_SUBDIR}/Makefile.in
CTI_BINUTILS_CONFIGURED= ${EXTTEMP}/${CTI_BINUTILS_SUBDIR}/Makefile
CTI_BINUTILS_BUILT=	${EXTTEMP}/${CTI_BINUTILS_SUBDIR}/gas/as-new
CTI_BINUTILS_INSTALLED=	${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-as


## ,-----
## |	Extract
## +-----

${CTI_BINUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${CTI_BINUTILS_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/binutils-${BINUTILS_VERSION} ${EXTTEMP}/${CTI_BINUTILS_SUBDIR}


## ,-----
## |	Configure
## +-----

${CTI_BINUTILS_CONFIGURED}: ${CTI_BINUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_BINUTILS_SUBDIR} || exit 1 ;\
			./configure --prefix=${CTI_TC_ROOT}/usr/ --bindir=${CTI_TC_ROOT}/usr/bin \
			--host=${HOSTSPEC} --build=${HOSTSPEC} \
			--target=${TARGSPEC} \
			--disable-nls --disable-werror \
			--with-sysroot=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--enable-shared \
			--disable-multilib \
	)


## ,-----
## |	Build
## +-----

${CTI_BINUTILS_BUILT}: ${CTI_BINUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_BINUTILS_SUBDIR} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

# Ensure we have appropriate symlinks for the kernel compiler later
${CTI_BINUTILS_INSTALLED}: ${CTI_BINUTILS_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CTI_BINUTILS_SUBDIR} || exit 1 ;\
		make install ;\
		( cd ${CTI_TC_ROOT}/usr/bin ;\
			for F in ar as ld nm objcopy objdump size strip ; do [ -r ${TARGSPEC}-$${F} ] && ln -sf ${TARGSPEC}-$${F} ${TARGSPEC}-k$${F} ; done ;\
		) \
	)

.PHONY: cti-binutils
cti-binutils: ${CTI_BINUTILS_INSTALLED}
