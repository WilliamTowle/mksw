## memdisk (syslinux) 4.03	[ since v1.76, c.2002-10-31 ]
## last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2011 ]
#
#ifneq (${HAVE_MEMDISK_CONFIG},y)
#HAVE_MEMDISK_CONFIG:=y
#
#DESCRLIST+= "'nti-memdisk' -- memdisk"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak
#
##MEMDISK_VER=3.86
##MEMDISK_VER=4.02
#MEMDISK_VER=4.03
#MEMDISK_SRC=${SOURCES}/s/syslinux-${MEMDISK_VER}.tar.bz2
#
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${MEMDISK_VER}.tar.bz2
#
#
### ,-----
### |	Extract
### +-----
#
#NTI_MEMDISK_TEMP=nti-memdisk-${MEMDISK_VER}
#
#NTI_MEMDISK_EXTRACTED=${EXTTEMP}/${NTI_MEMDISK_TEMP}/Makefile
#
#.PHONY: nti-nti-snux-extracted
#
#nti-memdisk-extracted: ${NTI_MEMDISK_EXTRACTED}
#
#${NTI_MEMDISK_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_MEMDISK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMDISK_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${MEMDISK_SRC}
#	mv ${EXTTEMP}/syslinux-${MEMDISK_VER} ${EXTTEMP}/${NTI_MEMDISK_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#NTI_MEMDISK_CONFIGURED=${EXTTEMP}/${NTI_MEMDISK_TEMP}/MCONFIG.OLD
#
#.PHONY: nti-memdisk-configured
#
#nti-memdisk-configured: nti-memdisk-extracted ${NTI_MEMDISK_CONFIGURED}
#
#${NTI_MEMDISK_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
#		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
#		cat MCONFIG.OLD \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
#			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
#			> MCONFIG || exit 1 ;\
#		rm -f memdisk/memdisk 2>/dev/null \
#	)
#
#
### ,-----
### |	Build
### +-----
#
#NTI_MEMDISK_BUILT=${EXTTEMP}/${NTI_MEMDISK_TEMP}/memdisk/memdisk
#
#.PHONY: nti-memdisk-built
#nti-memdisk-built: nti-memdisk-configured ${NTI_MEMDISK_BUILT}
#
#${NTI_MEMDISK_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
#		make -C memdisk memdisk \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#NTI_MEMDISK_INSTALLED=${NTI_TC_ROOT}/usr/lib/memdisk/memdisk
#
#.PHONY: nti-memdisk-installed
#
#nti-memdisk-installed: nti-memdisk-built ${NTI_MEMDISK_INSTALLED}
#
#${NTI_MEMDISK_INSTALLED}:
#	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
#		mkdir -p ${NTI_TC_ROOT}/usr/lib/memdisk || exit 1 ;\
#		cp memdisk/memdisk ${NTI_TC_ROOT}/usr/lib/memdisk/ ;\
#	)
#
#.PHONY: nti-memdisk
#nti-memdisk: ${NATIVE_GCC_DEPS} nti-nasm nti-memdisk-installed
#
#NTARGETS+= nti-memdisk
#
#endif	# HAVE_MEMDISK_CONFIG

# memdisk 4.07			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_MEMDISK_CONFIG},y)
HAVE_MEMDISK_CONFIG:=y

#DESCRLIST+= "'nti-memdisk' -- memdisk"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MEMDISK_VERSION},)
#MEMDISK_VERSION=3.86
#MEMDISK_VERSION=4.02
#MEMDISK_VERSION=4.03
MEMDISK_VERSION=4.07
endif

MEMDISK_SRC=${SOURCES}/s/syslinux-${MEMDISK_VERSION}.tar.bz2
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${MEMDISK_VERSION}.tar.bz2
URLS+=https://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-${MEMDISK_VERSION}.tar.bz2

# uuid.h for isohybrid.o
include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.42.12.mak

NTI_MEMDISK_TEMP=nti-memdisk-${MEMDISK_VERSION}

NTI_MEMDISK_EXTRACTED=${EXTTEMP}/${NTI_MEMDISK_TEMP}/Makefile
NTI_MEMDISK_CONFIGURED=${EXTTEMP}/${NTI_MEMDISK_TEMP}/utils/Makefile.OLD
NTI_MEMDISK_BUILT=${EXTTEMP}/${NTI_MEMDISK_TEMP}/memdisk
NTI_MEMDISK_INSTALLED=${NTI_TC_ROOT}/usr/bin/memdisk


## ,-----
## |	Extract
## +-----

${NTI_MEMDISK_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/syslinux-${MEMDISK_VERSION} ] || rm -rf ${EXTTEMP}/syslinux-${MEMDISK_VERSION}
	bzcat ${MEMDISK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MEMDISK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMDISK_TEMP}
	mv ${EXTTEMP}/syslinux-${MEMDISK_VERSION} ${EXTTEMP}/${NTI_MEMDISK_TEMP}


## ,-----
## |	Configure
## +-----

## NB. should be (but not yet doing) setting 'CC' consistently :(

${NTI_MEMDISK_CONFIGURED}: ${NTI_MEMDISK_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		[ -r utils/Makefile.OLD ] || cp utils/Makefile utils/Makefile.OLD ;\
		cat utils/Makefile.OLD \
			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CFLAGS[ 	]*=/	s%$$% -I'${NTI_TC_ROOT}'/usr/include%' \
			| sed '/^LDFLAGS[ 	]*=/	s%$$% -L'${NTI_TC_ROOT}'/usr/lib%' \
			> utils/Makefile \
	)
#		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
#		cat MCONFIG.OLD \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
#			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
#			> MCONFIG || exit 1 ;\
#		if [ 'avoid' = 'temporarily' ] ; then rm -f mbr/mbr.bin ; else true ; fi \


## ,-----
## |	Build
## +-----

${NTI_MEMDISK_BUILT}: ${NTI_MEMDISK_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		make -C memdisk memdisk \
	)
#		make \


## ,-----
## |	Install
## +-----

${NTI_MEMDISK_INSTALLED}: ${NTI_MEMDISK_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMDISK_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/memdisk || exit 1 ;\
		cp memdisk/memdisk ${NTI_TC_ROOT}/usr/lib/memdisk/ ;\
	)
#		make install INSTALLROOT=${NTI_TC_ROOT} \

.PHONY: nti-memdisk
nti-memdisk: ${NTI_MEMDISK_INSTALLED}

ALL_NTI_TARGETS+= nti-nasm \
	nti-e2fsprogs-libs \
	nti-memdisk

endif	# HAVE_MEMDISK_CONFIG
