# syslinux 4.03			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SYSLINUX_CONFIG},y)
HAVE_SYSLINUX_CONFIG:=y

#DESCRLIST+= "'nti-syslinux' -- syslinux"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak

ifeq (${SYSLINUX_VERSION},)
#SYSLINUX_VERSION=3.86
#SYSLINUX_VERSION=4.02
SYSLINUX_VERSION=4.03
endif

SYSLINUX_SRC=${SOURCES}/s/syslinux-${SYSLINUX_VERSION}.tar.bz2
URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-${SYSLINUX_VERSION}.tar.bz2
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.bz2

# TODO: dependencies include 'nasm'

NTI_SYSLINUX_TEMP=nti-make-${SYSLINUX_VERSION}

NTI_SYSLINUX_EXTRACTED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/Makefile
NTI_SYSLINUX_CONFIGURED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/config.log
NTI_SYSLINUX_BUILT=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/syslinux
NTI_SYSLINUX_INSTALLED=${NTI_TC_ROOT}/usr/bin/syslinux


## ,-----
## |	Extract
## +-----

${NTI_SYSLINUX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/syslinux-${SYSLINUX_VERSION} ] || rm -rf ${EXTTEMP}/syslinux-${SYSLINUX_VERSION}
	bzcat ${SYSLINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SYSLINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SYSLINUX_TEMP}
	mv ${EXTTEMP}/syslinux-${SYSLINUX_VERSION} ${EXTTEMP}/${NTI_SYSLINUX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SYSLINUX_CONFIGURED}: ${NTI_SYSLINUX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"

#NTI_SYSLINUX_CONFIGURED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/MCONFIG.OLD
#
#.PHONY: nti-syslinux-configured
#
#nti-syslinux-configured: nti-syslinux-extracted ${NTI_SYSLINUX_CONFIGURED}
#
#${NTI_SYSLINUX_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
#		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
#		cat MCONFIG.OLD \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
#			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \
#			> MCONFIG || exit 1 ;\
#		if [ 'avoid' = 'temporarily' ] ; then rm -f mbr/mbr.bin ; else true ; fi \
#	)


## ,-----
## |	Build
## +-----

${NTI_SYSLINUX_BUILT}: ${NTI_SYSLINUX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"

#NTI_SYSLINUX_BUILT=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/core/syslinux.bin
#
#.PHONY: nti-syslinux-built
#nti-syslinux-built: nti-syslinux-configured ${NTI_SYSLINUX_BUILT}
#
#${NTI_SYSLINUX_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
#		make installer || exit 1 \
#	)


## ,-----
## |	Install
## +-----

${NTI_SYSLINUX_INSTALLED}: ${NTI_SYSLINUX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"

#NTI_SYSLINUX_INSTALLED=${NTI_TC_ROOT}/etc/syslinux/syslinux.bin
#
#.PHONY: nti-syslinux-installed
#
#nti-syslinux-installed: nti-syslinux-built ${NTI_SYSLINUX_INSTALLED}
#
#${NTI_SYSLINUX_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
#		make install INSTALLROOT=${NTI_TC_ROOT} \
#	)
#
#.PHONY: nti-syslinux
#nti-syslinux: ${NATIVE_GCC_DEPS} nti-nasm nti-syslinux-installed
#
#NTARGETS+= nti-syslinux

.PHONY: nti-syslinux
nti-syslinux: ${NTI_SYSLINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-syslinux


endif	# HAVE_SYSLINUX_CONFIG
