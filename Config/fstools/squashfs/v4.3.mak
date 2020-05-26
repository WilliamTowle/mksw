# squashfs v4.3			[ since v4.0, 2010-01-21 ]
# last mod WmT, 2015-06-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_SQUASHFS_CONFIG},y)
HAVE_SQUASHFS_CONFIG:=y

# DESCRLIST+= "'nti-squashfs' -- squashfs"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SQUASHFS_VERSION},)
#SQUASHFS_VERSION=4.0
#SQUASHFS_VERSION=4.2
SQUASHFS_VERSION=4.3
endif
SQUASHFS_SRC=${SOURCES}/s/squashfs${SQUASHFS_VERSION}.tar.gz

URLS+= http://downloads.sourceforge.net/project/squashfs/squashfs/squashfs${SQUASHFS_VERSION}/squashfs${SQUASHFS_VERSION}.tar.gz?use_mirror=ignum

include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_SQUASHFS_TEMP=nti-squashfs-${SQUASHFS_VERSION}

NTI_SQUASHFS_EXTRACTED=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/COPYING
NTI_SQUASHFS_CONFIGURED=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools/Makefile.OLD
NTI_SQUASHFS_BUILT=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools/unsquashfs
NTI_SQUASHFS_INSTALLED=${NTI_TC_ROOT}/usr/bin/unsquashfs

## ,-----
## |	Extract
## +-----

${NTI_SQUASHFS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/squashfs${SQUASHFS_VERSION} ] || rm -rf ${EXTTEMP}/squashfs${SQUASHFS_VERSION}
	zcat ${SQUASHFS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SQUASHFS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SQUASHFS_TEMP}
	mv ${EXTTEMP}/squashfs${SQUASHFS_VERSION} ${EXTTEMP}/${NTI_SQUASHFS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SQUASHFS_CONFIGURED}: ${NTI_SQUASHFS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INCLUDEDIR/	s%^%CC= gcc\n%' \
			| sed '/^CC/	s%$$%\nEXTRA_CFLAGS ?= -I'${NTI_TC_ROOT}'/usr/include\n%' \
			| sed '/^EXTRA_CFLAGS/	s%$$%\nEXTRA_LDFLAGS ?= -L'${NTI_TC_ROOT}'/usr/lib\n%' \
			| sed '/^INSTALL_DIR/	{ s%local/%% ; s%/usr%'${NTI_TC_ROOT}'/usr% } ' \
			> Makefile || exit 1 \
	)
#			| sed '/^CFLAGS/	s%^%CC= '${NUI_CC_PREFIX}'cc\n%'


## ,-----
## |	Build
## +-----

${NTI_SQUASHFS_BUILT}: ${NTI_SQUASHFS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SQUASHFS_INSTALLED}: ${NTI_SQUASHFS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		make install \
	)

.PHONY: nti-squashfs
nti-squashfs: nti-zlib ${NTI_SQUASHFS_INSTALLED}

ALL_NTI_TARGETS+= nti-squashfs

endif	# HAVE_SQUASHFS_CONFIG
