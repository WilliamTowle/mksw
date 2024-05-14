# squashfs build rules		[ since v4.0, 2010-01-21 ]
# WmT, last mod. 2023-10-19	[ (c) and GPLv2 1999-2023 ]

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifneq (${HAVE_SQUASHFS_CONFIG},y)
HAVE_SQUASHFS_CONFIG:=y

ifeq (${SQUASHFS_VERSION},)
#SQUASHFS_VERSION=4.0
#SQUASHFS_VERSION=4.2
#SQUASHFS_VERSION=4.3
SQUASHFS_VERSION=4.6.1
endif

# Dependencies
include ${MF_CONFIGDIR}/misc/zlib/v1.3.1.mk


SQUASHFS_SRC=${DIR_DOWNLOADS}/s/squashfs${SQUASHFS_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/squashfs/squashfs/squashfs${SQUASHFS_VERSION}/squashfs${SQUASHFS_VERSION}.tar.gz?use_mirror=ignum
SQUASHFS_URL=http://downloads.sourceforge.net/project/squashfs/squashfs/squashfs${SQUASHFS_VERSION}/squashfs${SQUASHFS_VERSION}.tar.gz?use_mirror=ignum


NTI_SQUASHFS_TEMP=${DIR_EXTTEMP}/nti-squashfs-${SQUASHFS_VERSION}

NTI_SQUASHFS_EXTRACTED=${NTI_SQUASHFS_TEMP}/README-${SQUASHFS_VERSION}
NTI_SQUASHFS_CONFIGURED=${NTI_SQUASHFS_TEMP}/squashfs-tools/Makefile.OLD
NTI_SQUASHFS_BUILT=${NTI_SQUASHFS_TEMP}/squashfs-tools/mksquashfs
NTI_SQUASHFS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/mksquashfs


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-squashfs-uriurl:
	@echo "${SQUASHFS_SRC} ${SQUASHFS_URL}"

show-all-uriurl:: show-nti-squashfs-uriurl


${NTI_SQUASHFS_EXTRACTED}: | nti-sanity ${SQUASHFS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_SQUASHFS_TEMP} ARCHIVES=${SQUASHFS_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_SQUASHFS_CONFIGURED}: ${NTI_SQUASHFS_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INCLUDEDIR/	s%^%CC= gcc\n%' \
			| sed '/^CC/	s%$$%\nEXTRA_CFLAGS ?= -I'${DIR_NTI_TOOLCHAIN}'/usr/include\n%' \
			| sed '/^EXTRA_CFLAGS/	s%$$%\nEXTRA_LDFLAGS ?= -L'${DIR_NTI_TOOLCHAIN}'/usr/lib\n%' \
			| sed '/^INSTALL_PREFIX/	{ s%/local%% ; s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr% } ' \
			> Makefile \
		)


${NTI_SQUASHFS_BUILT}: ${NTI_SQUASHFS_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_SQUASHFS_TEMP}/squashfs-tools && make )


${NTI_SQUASHFS_INSTALLED}: ${NTI_SQUASHFS_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_SQUASHFS_TEMP}/squashfs-tools && make install )


#

USAGE_TEXT+= "'nti-squashfs' - build squashfs for NTI toolchain"

.PHONY: nti-squashfs
nti-squashfs: ${NTI_SQUASHFS_INSTALLED}

all-nti-targets:: nti-squashfs


endif	## HAVE_SQUASHFS_CONFIG
