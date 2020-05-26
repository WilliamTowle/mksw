# pxelinux (syslinux) 3.86	[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_PXELINUX_CONFIG},y)
HAVE_PXELINUX_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak

#DESCRLIST+= "'nti-pxelinux' -- syslinux pxelinux"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
#
#ifneq (${HAVE_NATIVE_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VERSION}.mak
#endif
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.08.01.mak
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak

ifeq (${PXELINUX_VERSION},)
#PXELINUX_VERSION=3.84
PXELINUX_VERSION=3.86
endif
PXELINUX_SRC=${SOURCES}/s/syslinux-${PXELINUX_VERSION}.tar.bz2

NTI_PXELINUX_TEMP=nti-pxelinux-${PXELINUX_VERSION}
NTI_PXELINUX_EXTRACTED=${EXTTEMP}/${NTI_PXELINUX_TEMP}/Makefile
NTI_PXELINUX_CONFIGURED=${EXTTEMP}/${NTI_PXELINUX_TEMP}/MCONFIG.OLD
NTI_PXELINUX_BUILT=${EXTTEMP}/${NTI_PXELINUX_TEMP}/core/pxelinux.0
NTI_PXELINUX_INSTALLED=${NTI_TC_ROOT}/etc/syslinux/pxelinux.0

#URLS+= http://www.kernel.org/pub/linux/utils/boot/syslinux/3.xx/syslinux-${PXELINUX_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/syslinux-3.86.tar.bz2


## ,-----
## |	Extract
## +-----

${NTI_PXELINUX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_PXELINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PXELINUX_TEMP}
	bzcat ${PXELINUX_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/syslinux-${PXELINUX_VERSION} ${EXTTEMP}/${NTI_PXELINUX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PXELINUX_CONFIGURED}: ${NTI_PXELINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
		cat MCONFIG.OLD \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
			> MCONFIG || exit 1 ;\
		rm -f core/pxelinux.0 core/pxelinux.bin \
	)


## ,-----
## |	Build
## +-----

${NTI_PXELINUX_BUILT}: ${NTI_PXELINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
		make -C core pxelinux.0 \
	)


## ,-----
## |	Install
## +-----

${NTI_PXELINUX_INSTALLED}: ${NTI_PXELINUX_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/etc/syslinux || exit 1 ;\
		cp core/pxelinux.0 ${NTI_TC_ROOT}/etc/syslinux/ ;\
	)

.PHONY: nti-pxelinux
nti-pxelinux: nti-nasm ${NTI_PXELINUX_INSTALLED}

ALL_NUI_TARGETS+= nti-pxelinux

endif	# HAVE_PXELINUX_CONFIG
