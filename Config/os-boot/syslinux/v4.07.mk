# syslinux build rules		[ since v1.76, c.2002-10-31 ]
# WmT, last mod. 2023-10-18	[ (c) and GPLv2 2023 ]


ifneq (${HAVE_SYSLINUX_CONFIG},y)
HAVE_SYSLINUX_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

include ${MF_CONFIGDIR}/build-tools/nasm/v2.16.mk


ifeq (${SYSLINUX_VERSION},)
# [WmT, 2023-09-29] cdn.kernel.org carries v4.07, v5.10, v6.03
#SYSLINUX_VERSION=3.86
#SYSLINUX_VERSION=4.02
SYSLINUX_VERSION=4.07
#SYSLINUX_VERSION=5.10
#SYSLINUX_VERSION=6.03
endif

SYSLINUX_SRC=${DIR_DOWNLOADS}/s/syslinux-${SYSLINUX_VERSION}.tar.gz
#URLS+=http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz
#URLS+=https://www.kernel.org/pub/linux/utils/boot/syslinux/6.xx/syslinux-${SYSLINUX_VERSION}.tar.gz
SYSLINUX_URL=https://cdn.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz


NTI_SYSLINUX_TEMP=${DIR_EXTTEMP}/nti-syslinux-${SYSLINUX_VERSION}

NTI_SYSLINUX_EXTRACTED=${NTI_SYSLINUX_TEMP}/version.mk
NTI_SYSLINUX_CONFIGURED=${NTI_SYSLINUX_TEMP}/mk/.mksw-configured
NTI_SYSLINUX_BUILT=${NTI_SYSLINUX_TEMP}/linux/syslinux
NTI_SYSLINUX_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/syslinux



##

show-nti-syslinux-uriurl:
	@echo "${SYSLINUX_SRC} ${SYSLINUX_URL}"

show-all-uriurl:: show-nti-syslinux-uriurl


${NTI_SYSLINUX_EXTRACTED}: | nti-sanity ${SYSLINUX_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_SYSLINUX_TEMP} ARCHIVES=${SYSLINUX_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_SYSLINUX_CONFIGURED}: ${NTI_SYSLINUX_EXTRACTED}
	( cd ${NTI_SYSLINUX_TEMP} ;\
		[ -r mk/syslinux.mk.OLD ] || mv mk/syslinux.mk mk/syslinux.mk.OLD ;\
		cat mk/syslinux.mk.OLD \
			| sed '/^[A-Z]*DIR/	s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^SBINDIR/	s%/sbin%'${DIR_NTI_TOOLCHAIN}'/sbin%' \
			| sed '/^CC/	s% g*cc % '${NTI_GCC}' %' \
			| sed '/^CC/	s%$$% -I$$(INCDIR)%' \
			| sed '/^CC/	s%$$% -L$$(LIBDIR)%' \
			| sed '/^NASM/	s%nasm%'${DIR_NTI_TOOLCHAIN}'/usr/bin/nasm%' \
			> mk/syslinux.mk \
	)
	touch ${NTI_SYSLINUX_CONFIGURED}


## v4: need bootsect_bin.o
## v6: make rules are 'bios', and 'installer'

${NTI_SYSLINUX_BUILT}: ${NTI_SYSLINUX_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	#( cd ${NTI_SYSLINUX_TEMP} && make -C linux )
	( cd ${NTI_SYSLINUX_TEMP} && make -C libinstaller && make -C linux )


${NTI_SYSLINUX_INSTALLED}: ${NTI_SYSLINUX_BUILT}
	echo "*** $@ (INSTALL) ***"
	mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/bin || exit 1 ;\
	mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/lib/syslinux || exit 1 ;\
	( cd ${NTI_SYSLINUX_TEMP} && cp com32/chain/chain.c32 com32/menu/menu.c32 ${DIR_NTI_TOOLCHAIN}/usr/lib/syslinux/ )
	( cd ${NTI_SYSLINUX_TEMP} && cp mbr/*.bin ${DIR_NTI_TOOLCHAIN}/usr/lib/syslinux/ )
	( cd ${NTI_SYSLINUX_TEMP} && cp linux/syslinux linux/syslinux-nomtools ${DIR_NTI_TOOLCHAIN}/usr/bin/ )


##

USAGE_TEXT+= "'nti-syslinux' - build syslinux for NTI toolchain"

.PHONY: nti-syslinux
nti-syslinux: ${NTI_SYSLINUX_INSTALLED}


all-nti-targets:: nti-syslinux

endif
