# pxelinux 4.03			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2011-01-13	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_PXELINUX_CONFIG},y)
HAVE_PXELINUX_CONFIG:=y

#DESCRLIST+= "'nti-pxelinux' -- syslinux pxelinux"
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak

ifneq (${PXELINUX_VERSION},)
#PXELINUX_VERSION=3.84
#PXELINUX_VERSION=3.86
#PXELINUX_VERSION=4.02
PXELINUX_VERSION=4.03
endif
PXELINUX_SRC=${SRCDIR}/s/syslinux-${PXELINUX_VERSION}.tar.bz2

URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${PXELINUX_VERSION}.tar.bz2


### ,-----
### |	Extract
### +-----
#
#NTI_PXELINUX_TEMP=nti-pxelinux-${PXELINUX_VERSION}
#
#NTI_PXELINUX_EXTRACTED=${EXTTEMP}/${NTI_PXELINUX_TEMP}/Makefile
#
#.PHONY: nti-pxelinux-extracted
#
#nti-pxelinux-extracted: ${NTI_PXELINUX_EXTRACTED}
#
#${NTI_PXELINUX_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_PXELINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PXELINUX_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${PXELINUX_SRC}
#	mv ${EXTTEMP}/syslinux-${PXELINUX_VERSION} ${EXTTEMP}/${NTI_PXELINUX_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#NTI_PXELINUX_CONFIGURED=${EXTTEMP}/${NTI_PXELINUX_TEMP}/MCONFIG.OLD
#
#.PHONY: nti-pxelinux-configured
#
#nti-pxelinux-configured: nti-pxelinux-extracted ${NTI_PXELINUX_CONFIGURED}
#
#${NTI_PXELINUX_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
#		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
#		cat MCONFIG.OLD \
#			| sed '/^[A-Z]*DIR[ 	]*=/ s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^[A-Z]*DIR[ 	]*=/ s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
#			> MCONFIG || exit 1 ;\
#		if [ 'avoid' = 'temporarily' ] ; then rm -f core/pxelinux.0 core/pxelinux.bin ; else true ; fi \
#	)
#
#
### ,-----
### |	Build
### +-----
#
#NTI_PXELINUX_BUILT=${EXTTEMP}/${NTI_PXELINUX_TEMP}/core/pxelinux.0
#
#.PHONY: nti-pxelinux-built
#nti-pxelinux-built: nti-pxelinux-configured ${NTI_PXELINUX_BUILT}
#
#${NTI_PXELINUX_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
#		make -C core pxelinux.bin pxelinux.0 || exit 1 \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#NTI_PXELINUX_INSTALLED=${NTI_TC_ROOT}/etc/syslinux/pxelinux.0
#
#.PHONY: nti-pxelinux-installed
#
#nti-pxelinux-installed: nti-pxelinux-built ${NTI_PXELINUX_INSTALLED}
#
#${NTI_PXELINUX_INSTALLED}:
#	( cd ${EXTTEMP}/${NTI_PXELINUX_TEMP} || exit 1 ;\
#		mkdir -p ${NTI_TC_ROOT}/etc/syslinux || exit 1 ;\
#		cp core/pxelinux.0 ${NTI_TC_ROOT}/etc/syslinux/ ;\
#	)
#
#.PHONY: nti-pxelinux
#nti-pxelinux: ${NATIVE_GCC_DEPS} nti-nasm nti-pxelinux-installed
#
#NTARGETS+= nti-pxelinux

endif	# HAVE_PXELINUX_CONFIG
