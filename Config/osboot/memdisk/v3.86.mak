#!usr/bin/make
# memdisk (syslinux) 3.86	[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2012-08-11	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_MEMDISK_CONFIG},y)
HAVE_MEMDISK_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.11.06.mak
include ${CFG_ROOT}/buildtools/nasm/v2.12.mak

ifeq (${MEMDISK_VERSION},)
#MEMDISK_VERSION=3.72
MEMDISK_VERSION=3.86
endif
MEMDISK_SRC= ${SOURCES}/s/syslinux-${MEMDISK_VERSION}.tar.bz2

#URLS+= http://www.kernel.org/pub/linux/utils/boot/syslinux/3.xx/syslinux-${MEMDISK_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/syslinux-3.86.tar.bz2

NTI_MEMDISK_TEMP=	nti-memdisk-${MEMDISK_VERSION}

NTI_MEMDISK_EXTRACTED=	${EXTTEMP}/${NTI_MEMDISK_TEMP}/Makefile
NTI_MEMDISK_CONFIGURED=	${EXTTEMP}/${NTI_MEMDISK_TEMP}/MCONFIG.OLD
NTI_MEMDISK_BUILT=	${EXTTEMP}/${NTI_MEMDISK_TEMP}/memdisk/memdisk
NTI_MEMDISK_INSTALLED=	${NTI_TC_ROOT}/usr/lib/memdisk


## ,-----
## |	Extract
## +-----

${NTI_MEMDISK_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${MEMDISK_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/syslinux-${MEMDISK_VERSION} ${EXTTEMP}/${NTI_MEMDISK_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MEMDISK_CONFIGURED}: ${NTI_MEMDISK_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
		cat MCONFIG.OLD \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
			> MCONFIG || exit 1 ;\
		rm -f memdisk/memdisk 2>/dev/null \
	)
#		| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \


## ,-----
## |	Build
## +-----

${NTI_MEMDISK_BUILT}: ${NTI_MEMDISK_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		make -C memdisk memdisk \
	)


## ,-----
## |	Install
## +-----

# TODO: install to $INSTTEMP...
${NTI_MEMDISK_INSTALLED}: ${NTI_MEMDISK_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/memdisk || exit 1 ;\
		cp memdisk/memdisk ${NTI_TC_ROOT}/usr/lib/memdisk/ ;\
	)

##

.PHONY: nti-memdisk
nti-memdisk: ${NTI_MEMDISK_INSTALLED}

ALL_NTI_TARGETS+= nti-nasm nti-memdisk

endif	# HAVE_MEMDISK_CONFIG
