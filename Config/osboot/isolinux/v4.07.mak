## isolinux 4.03			[ since v1.76, c.2002-10-31 ]
## last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2011 ]
#
#ifneq (${HAVE_ISOLINUX_CONFIG},y)
#HAVE_ISOLINUX_CONFIG:=y
#
#DESCRLIST+= "'nti-isolinux' -- syslinux isolinux"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak
#
##ISOLINUX_VER=3.84
##ISOLINUX_VER=3.86
##ISOLINUX_VER=4.02
#ISOLINUX_VER=4.03
#ISOLINUX_SRC=${SOURCES}/s/syslinux-${ISOLINUX_VER}.tar.bz2
#
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${ISOLINUX_VER}.tar.bz2
#
#
### ,-----
### |	Extract
### +-----
#
#NTI_ISOLINUX_TEMP=nti-isolinux-${ISOLINUX_VER}
#
#NTI_ISOLINUX_EXTRACTED=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/Makefile
#
#.PHONY: nti-isolinux-extracted
#
#nti-isolinux-extracted: ${NTI_ISOLINUX_EXTRACTED}
#
#${NTI_ISOLINUX_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_ISOLINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ISOLINUX_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${ISOLINUX_SRC}
#	mv ${EXTTEMP}/syslinux-${ISOLINUX_VER} ${EXTTEMP}/${NTI_ISOLINUX_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#NTI_ISOLINUX_CONFIGURED=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/MCONFIG.OLD
#
#.PHONY: nti-isolinux-configured
#
#nti-isolinux-configured: nti-isolinux-extracted ${NTI_ISOLINUX_CONFIGURED}
#
#${NTI_ISOLINUX_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
#		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
#		cat MCONFIG.OLD \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
#			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
#			> MCONFIG || exit 1 ;\
#		if [ 'avoid' = 'temporarily' ] ; then rm -f core/isolinux.bin ; else true ; fi \
#	)
#
#
## ,-----
## |	Build
## +-----
#
#NTI_ISOLINUX_BUILT=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/core/isolinux.bin
#
#.PHONY: nti-isolinux-built
#nti-isolinux-built: nti-isolinux-configured ${NTI_ISOLINUX_BUILT}
#
#${NTI_ISOLINUX_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
#		make core/isolinux.bin || exit 1 \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#NTI_ISOLINUX_INSTALLED=${NTI_TC_ROOT}/etc/syslinux/isolinux.bin
#
#.PHONY: nti-isolinux-installed
#
#nti-isolinux-installed: nti-isolinux-built ${NTI_ISOLINUX_INSTALLED}
#
#${NTI_ISOLINUX_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
#		mkdir -p ${NTI_TC_ROOT}/etc/syslinux || exit 1 ;\
#		cp core/isolinux.bin ${NTI_TC_ROOT}/etc/syslinux/ \
#	)
#
#.PHONY: nti-isolinux
#nti-isolinux: ${NATIVE_GCC_DEPS} nti-nasm nti-isolinux-installed
#
#NTARGETS+= nti-isolinux
#
#endif	# HAVE_ISOLINUX_CONFIG

# isolinux 4.07			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_ISOLINUX_CONFIG},y)
HAVE_ISOLINUX_CONFIG:=y

#DESCRLIST+= "'nti-isolinux' -- isolinux"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ISOLINUX_VERSION},)
#ISOLINUX_VERSION=3.86
#ISOLINUX_VERSION=4.02
#ISOLINUX_VERSION=4.03
ISOLINUX_VERSION=4.07
endif

ISOLINUX_SRC=${SOURCES}/s/syslinux-${ISOLINUX_VERSION}.tar.bz2
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${ISOLINUX_VERSION}.tar.bz2
URLS+=https://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-${ISOLINUX_VERSION}.tar.bz2

# uuid.h for isohybrid.o
include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.42.12.mak

NTI_ISOLINUX_TEMP=nti-isolinux-${ISOLINUX_VERSION}

NTI_ISOLINUX_EXTRACTED=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/Makefile
NTI_ISOLINUX_CONFIGURED=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/utils/Makefile.OLD
NTI_ISOLINUX_BUILT=${EXTTEMP}/${NTI_ISOLINUX_TEMP}/isolinux
NTI_ISOLINUX_INSTALLED=${NTI_TC_ROOT}/usr/bin/isolinux


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

## NB. should be (but not yet doing) setting 'CC' consistently :(

${NTI_ISOLINUX_CONFIGURED}: ${NTI_ISOLINUX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
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

${NTI_ISOLINUX_BUILT}: ${NTI_ISOLINUX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
		make core/isolinux.bin || exit 1 \
	)
#		make \


## ,-----
## |	Install
## +-----

${NTI_ISOLINUX_INSTALLED}: ${NTI_ISOLINUX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ISOLINUX_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/etc/syslinux || exit 1 ;\
		cp core/isolinux.bin ${NTI_TC_ROOT}/etc/syslinux/ \
	)
#		make install INSTALLROOT=${NTI_TC_ROOT} \

.PHONY: nti-isolinux
nti-isolinux: ${NTI_ISOLINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-nasm \
	nti-e2fsprogs-libs \
	nti-isolinux

endif	# HAVE_ISOLINUX_CONFIG
