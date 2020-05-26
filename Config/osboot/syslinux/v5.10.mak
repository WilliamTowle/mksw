# syslinux 5.10			[ since v1.76, c.2002-10-31 ]
# last mod WmT, 2015-01-08	[ (c) and GPLv2 1999-2015* ]

## NB. 64-bit build hosts need libc-dev-i386 (bits/predefs.h)

ifneq (${HAVE_SYSLINUX_CONFIG},y)
HAVE_SYSLINUX_CONFIG:=y

#DESCRLIST+= "'nti-syslinux' -- syslinux"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SYSLINUX_VERSION},)
#SYSLINUX_VERSION=3.86
#SYSLINUX_VERSION=4.07
SYSLINUX_VERSION=5.10
endif

SYSLINUX_SRC=${SOURCES}/s/syslinux-${SYSLINUX_VERSION}.tar.bz2
#SYSLINUX_SRC=${SOURCES}/s/syslinux-${SYSLINUX_VERSION}.tar.gz
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.bz2
URLS+=https://www.kernel.org/pub/linux/utils/boot/syslinux/5.xx/syslinux-${SYSLINUX_VERSION}.tar.bz2
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/nasm/v2.11.08.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.42.12.mak

NTI_SYSLINUX_TEMP=nti-syslinux-${SYSLINUX_VERSION}

NTI_SYSLINUX_EXTRACTED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/README
NTI_SYSLINUX_CONFIGURED=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/mk/syslinux.mk.OLD
NTI_SYSLINUX_BUILT=${EXTTEMP}/${NTI_SYSLINUX_TEMP}/src/syslinux
NTI_SYSLINUX_INSTALLED=${NTI_TC_ROOT}/usr/bin/syslinux

## ,-----
## |	Extract
## +-----

${NTI_SYSLINUX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/syslinux-${SYSLINUX_VERSION} ] || rm -rf ${EXTTEMP}/syslinux-${SYSLINUX_VERSION}
	bzcat ${SYSLINUX_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${SYSLINUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SYSLINUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SYSLINUX_TEMP}
	mv ${EXTTEMP}/syslinux-${SYSLINUX_VERSION} ${EXTTEMP}/${NTI_SYSLINUX_TEMP}


## ,-----
## |	Configure
## +-----

## INCDIR and LIBDIR in the toolchain (uuid.h etc)
## /usr/include and /usr/lib handling because of 64- to 32- bit

${NTI_SYSLINUX_CONFIGURED}: ${NTI_SYSLINUX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		[ -r mk/syslinux.mk.OLD ] || mv mk/syslinux.mk mk/syslinux.mk.OLD ;\
		cat mk/syslinux.mk.OLD \
			| sed '/^[A-Z]*DIR/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^SBINDIR/	s%/sbin%'${NTI_TC_ROOT}'/sbin%' \
			| sed '/^CC/	s%$$% -I$$(INCDIR)%' \
			| sed '/^CC/	s%$$% -L$$(LIBDIR)%' \
			| sed '/^NASM/	s%nasm%'${NTI_TC_ROOT}'/usr/bin/nasm%' \
			> mk/syslinux.mk \
	)

## ,-----
## |	Build
## +-----

${NTI_SYSLINUX_BUILT}: ${NTI_SYSLINUX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make \
	)
#		make installer \


## ,-----
## |	Install
## +-----

${NTI_SYSLINUX_INSTALLED}: ${NTI_SYSLINUX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SYSLINUX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-syslinux
nti-syslinux: nti-nasm \
	nti-e2fsprogs-libs \
	${NTI_SYSLINUX_INSTALLED}
#nti-syslinux: ${NATIVE_GCC_DEPS} nti-nasm nti-syslinux-installed

ALL_NTI_TARGETS+= nti-syslinux

endif	# HAVE_SYSLINUX_CONFIG
