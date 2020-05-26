#!usr/bin/make
# isolinux (syslinux) 3.86	[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2012-08-11	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_ISOLINUX_CONFIG},y)
HAVE_ISOLINUX_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak
include ${CFG_ROOT}/buildtools/nasm/v2.12.mak

ifeq (${ISOLINUX_VERSION},)
#ISOLINUX_VERSION=3.72
ISOLINUX_VERSION=3.86
endif
ISOLINUX_SRC= ${SOURCES}/s/syslinux-${ISOLINUX_VERSION}.tar.bz2

#URLS+= http://www.kernel.org/pub/linux/utils/boot/syslinux/3.xx/syslinux-${ISOLINUX_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/syslinux-3.86.tar.bz2

NTI_ISOLINUX_TEMP=		nti-isolinux-${ISOLINUX_VERSION}

NTI_ISOLINUX_EXTRACTED=		${EXTTEMP}/${NTI_ISOLINUX_TEMP}/Makefile
NTI_ISOLINUX_CONFIGURED=	${EXTTEMP}/${NTI_ISOLINUX_TEMP}/MCONFIG.OLD
NTI_ISOLINUX_BUILT=		${EXTTEMP}/${NTI_ISOLINUX_TEMP}/core/isolinux.bin
NTI_ISOLINUX_INSTALLED=		${NTI_TC_ROOT}/etc/syslinux/isolinux.bin


## ,-----
## |	Extract
## +-----

${NTI_ISOLINUX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/syslinux-${ISOLINUX_VERSION} ] || rm -rf ${EXTTEMP}/syslinux-${ISOLINUX_VERSION}
	bzcat ${ISOLINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ISOLINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ISOLINUX_TEMP}
	mv ${EXTTEMP}/syslinux-${ISOLINUX_VERSION} ${EXTTEMP}/${NTI_ISOLINUX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ISOLINUX_CONFIGURED}: ${NTI_ISOLINUX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
		cat MCONFIG.OLD \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
			> MCONFIG || exit 1 ;\
		rm -f memdisk/memdisk 2>/dev/null \
		rm -f core/isolinux.bin 2>/dev/null \
	)
#		| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \


## ,-----
## |	Build
## +-----

${NTI_ISOLINUX_BUILT}: ${NTI_ISOLINUX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
		make -C core isolinux.bin || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_ISOLINUX_INSTALLED}: ${NTI_ISOLINUX_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/etc/syslinux || exit 1 ;\
		cp core/isolinux.bin ${NTI_TC_ROOT}/etc/syslinux/ \
	)

##

.PHONY: nti-isolinux
nti-isolinux: nti-nasm ${NTI_ISOLINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-isolinux

endif	# HAVE_ISOLINUX_CONFIG
