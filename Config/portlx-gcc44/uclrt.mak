#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

URLS+= http://www.uclibc.org/downloads/uClibc-${UCLIBC_VERSION}.tar.bz2

# TODO: deps: 'ucldev' configuration file; kernel compiler; libgcc

CTI_UCLRT_SUBDIR=	cti-uclrt-${UCLIBC_VERSION}
CTI_UCLRT_ARCHIVE=	${SOURCES}/u/uClibc-${UCLIBC_VERSION}.tar.bz2

CTI_UCLRT_EXTRACTED=	${EXTTEMP}/${CTI_UCLRT_SUBDIR}/README
CTI_UCLRT_CONFIGURED=	${EXTTEMP}/${CTI_UCLRT_SUBDIR}/.config
CTI_UCLRT_BUILT=	${EXTTEMP}/${CTI_UCLRT_SUBDIR}/lib/libc.so
CTI_UCLRT_INSTALLED=	${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/libc.so

##

CUI_UCLRT_SUBDIR=	cui-uclrt-${UCLIBC_VERSION}
CUI_UCLRT_ARCHIVE=	${SOURCES}/u/uClibc-${UCLIBC_VERSION}.tar.bz2

CUI_UCLRT_EXTRACTED=	${EXTTEMP}/${CUI_UCLRT_SUBDIR}/README
CUI_UCLRT_CONFIGURED=	${EXTTEMP}/${CUI_UCLRT_SUBDIR}/.config
CUI_UCLRT_BUILT=	${EXTTEMP}/${CUI_UCLRT_SUBDIR}/lib/libc.so
CUI_UCLRT_INSTALLED=	${INSTTEMP}/lib/libc.so.0


## ,-----
## |	Extract
## +-----

${CTI_UCLRT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${CTI_UCLRT_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/uClibc-${UCLIBC_VERSION} ${EXTTEMP}/${CTI_UCLRT_SUBDIR}

##

${CUI_UCLRT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${CUI_UCLRT_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/uClibc-${UCLIBC_VERSION} ${EXTTEMP}/${CUI_UCLRT_SUBDIR}



## ,-----
## |	Configure
## +-----

UCLRT_VERBOSE=V=2

# set CROSS_COMPILER_PREFIX to suit the kernel-only compiler
${CTI_UCLRT_CONFIGURED}: ${CTI_UCLRT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLRT_SUBDIR} || exit 1 ;\
		cp ${CTI_TC_ROOT}/etc/config-uClibc-${UCLIBC_VERSION} .config || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig \
	)

##

# set CROSS_COMPILER_PREFIX to suit the kernel-only compiler
${CUI_UCLRT_CONFIGURED}: ${CUI_UCLRT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_UCLRT_SUBDIR} || exit 1 ;\
		cp ${CTI_TC_ROOT}/etc/config-uClibc-${UCLIBC_VERSION} .config || exit 1 ;\
	 	yes '' | make HOSTCC=/usr/bin/gcc oldconfig \
	)


## ,-----
## |	Build
## +-----

${CTI_UCLRT_BUILT}: ${CTI_UCLRT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLRT_SUBDIR} || exit 1 ;\
		make ${UCLRT_VERBOSE} \
	)

##

${CUI_UCLRT_BUILT}: ${CUI_UCLRT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CUI_UCLRT_SUBDIR} || exit 1 ;\
		make ${UCLRT_VERBOSE} \
	)


## ,-----
## |	Install
## +-----

# set PREFIX= and DEVEL_PREFIX= in order to inject /usr/${TARGSPEC} 

${CTI_UCLRT_INSTALLED}: ${CTI_UCLRT_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CTI_UCLRT_SUBDIR} || exit 1 ;\
		make PREFIX=${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/' DEVEL_PREFIX='/usr/' install ${UCLRT_VERBOSE} \
	)

.PHONY: cti-uclrt
cti-uclrt: ${CTI_UCLRT_INSTALLED}

##

# NB: PATH gets ${DEVEL_PREFIX} added as per setting in .config
# 'tcng' build also does 'install_utils' (for ld, ldconfig) here
${CUI_UCLRT_INSTALLED}: ${CUI_UCLRT_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${CUI_UCLRT_SUBDIR} || exit 1 ;\
		make PREFIX=${INSTTEMP} install_runtime \
	)

.PHONY: cui-uclrt
cui-uclrt: ${CUI_UCLRT_INSTALLED}
