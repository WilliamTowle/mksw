# syslinux 4.07			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2011-01-14	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_SYSLINUX_CONFIG},y)
HAVE_SYSLINUX_CONFIG:=y

#DESCRLIST+= "'nti-syslinux' -- syslinux"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SYSLINUX_VERSION},)
#SYSLINUX_VERSION=3.86
#SYSLINUX_VERSION=4.02
#SYSLINUX_VERSION=4.03
SYSLINUX_VERSION=4.07
endif

SYSLINUX_SRC=${SOURCES}/s/syslinux-${SYSLINUX_VERSION}.tar.bz2
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.bz2
URLS+=https://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-${SYSLINUX_VERSION}.tar.bz2

# uuid.h for isohybrid.o
include ${CFG_ROOT}/buildtools/nasm/v2.10.03.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.42.12.mak

NTI_SYSLINUX_TEMP=nti-syslinux-${SYSLINUX_VERSION}

NTI_SYSLINUX_EXTRACTED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/Makefile
NTI_SYSLINUX_CONFIGURED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/utils/Makefile.OLD
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

## NB. should be (but not yet doing) setting 'CC' consistently :(

${NTI_SYSLINUX_CONFIGURED}: ${NTI_SYSLINUX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
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

${NTI_SYSLINUX_BUILT}: ${NTI_SYSLINUX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SYSLINUX_INSTALLED}: ${NTI_SYSLINUX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make install INSTALLROOT=${NTI_TC_ROOT} \
	)

.PHONY: nti-syslinux
nti-syslinux: ${NTI_SYSLINUX_INSTALLED}

ALL_NTI_TARGETS+= nti-nasm \
	nti-e2fsprogs-libs \
	nti-syslinux

endif	# HAVE_SYSLINUX_CONFIG
