# syslinux 3.86			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2012-02-04	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_SYSLINUX_CONFIG},y)
HAVE_SYSLINUX_CONFIG:=y

#DESCRLIST+= "'nti-syslinux' -- syslinux"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
#
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.08.01.mak
##include ${CFG_ROOT}/distrotools-legacy/nasm/v2.09.04.mak
##include ${CFG_ROOT}/distrotools-ng/nasm/v2.09.10.mak
#include ${CFG_ROOT}/distrotools-ng/nasm/v2.10rc8.mak

ifeq (${SYSLINUX_VER},)
#SYSLINUX_VER=3.84
SYSLINUX_VER=3.86
endif
SYSLINUX_SRC=${SOURCES}/s/syslinux-${SYSLINUX_VER}.tar.bz2

NTI_SYSLINUX_TEMP=nti-syslinux-${SYSLINUX_VER}
NTI_SYSLINUX_EXTRACTED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/Makefile
NTI_SYSLINUX_CONFIGURED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/MCONFIG.OLD
NTI_SYSLINUX_BUILT=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/linux/syslinux
NTI_SYSLINUX_INSTALLED=${NTI_TC_ROOT}/usr/bin/syslinux

#URLS+= http://www.kernel.org/pub/linux/utils/boot/syslinux/3.xx/syslinux-${SYSLINUX_VER}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/syslinux-3.86.tar.bz2


## ,-----
## |	Extract
## +-----

${NTI_SYSLINUX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_SYSLINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SYSLINUX_TEMP}
	bzcat ${SYSLINUX_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/syslinux-${SYSLINUX_VER} ${EXTTEMP}/${NTI_SYSLINUX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SYSLINUX_CONFIGURED}: ${NTI_SYSLINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		[ -r MCONFIG.OLD ] || mv MCONFIG MCONFIG.OLD || exit 1 ;\
		cat MCONFIG.OLD \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^[A-Z]*DIR[ 	]*=/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
			> MCONFIG || exit 1 ;\
		for F in com32/lib com32/gpllib ; do \
			[ -r $${F}/Makefile.OLD ] || mv $${F}/Makefile $${F}/Makefile.OLD ;\
			cat $${F}/Makefile.OLD \
				| sed '/^[A-Z][^ ]*DIR/	s/^/#/' \
				> $${F}/Makefile ;\
		done \
	)
#			| sed '/^CC[ 	]*=/		s%g*cc%'${NTI_GCC}'%' \


## ,-----
## |	Build
## +-----

${NTI_SYSLINUX_BUILT}: ${NTI_SYSLINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make installer || exit 1 \
	)


## ,-----
## |	Install
## +-----


${NTI_SYSLINUX_INSTALLED}: ${NTI_SYSLINUX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-syslinux
nti-syslinux: ${NTI_SYSLINUX_INSTALLED}
#nti-syslinux: nti-nasm ${NTI_SYSLINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-syslinux

endif	# HAVE_SYSLINUX_CONFIG
