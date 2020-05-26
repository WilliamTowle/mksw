# squashfs v4.0			[ since v4.0, 2010-01-21 ]
# last mod WmT, 2010-01-21	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_SQUASHFS_CONFIG},y)
HAVE_SQUASHFS_CONFIG:=y

DESCRLIST+= "'nti-squashfs' -- squashfs"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

SQUASHFS_VER=4.0
SQUASHFS_SRC=${SRCDIR}/s/squashfs4.0.tar.gz

URLS+= http://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.0/squashfs4.0.tar.gz?use_mirror=sunet


# ,-----
# |	Extract
# +-----

NTI_SQUASHFS_TEMP=nti-squashfs-${SQUASHFS_VER}

NTI_SQUASHFS_EXTRACTED=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools/Makefile

.PHONY: nti-squashfs-extracted

nti-squashfs-extracted: ${NTI_SQUASHFS_EXTRACTED}

${NTI_SQUASHFS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_SQUASHFS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SQUASHFS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SQUASHFS_SRC}
	mv ${EXTTEMP}/squashfs${SQUASHFS_VER} ${EXTTEMP}/${NTI_SQUASHFS_TEMP}


# ,-----
# |	Configure
# +-----

NTI_SQUASHFS_CONFIGURED=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools/Makefile.OLD

.PHONY: nti-squashfs-configured

nti-squashfs-configured: nti-squashfs-extracted ${NTI_SQUASHFS_CONFIGURED}

${NTI_SQUASHFS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INSTALL_DIR/	{ s%local/%% ; s%/usr%'${NTI_TC_ROOT}'/usr% } ' \
			| sed '/^CFLAGS/	s%^%CC= '${NUI_CC_PREFIX}'cc\n%' \
			> Makefile || exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_SQUASHFS_BUILT=${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools/unsquashfs

.PHONY: nti-squashfs-built
nti-squashfs-built: nti-squashfs-configured ${NTI_SQUASHFS_BUILT}

${NTI_SQUASHFS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_SQUASHFS_INSTALLED=${NTI_TC_ROOT}/usr/bin/unsquashfs

.PHONY: nti-squashfs-installed

nti-squashfs-installed: nti-squashfs-built ${NTI_SQUASHFS_INSTALLED}

${NTI_SQUASHFS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SQUASHFS_TEMP}/squashfs-tools || exit 1 ;\
		make install \
	)

.PHONY: nti-squashfs
nti-squashfs: nti-squashfs-installed

NTARGETS+=nti-squashfs

endif	# HAVE_SQUASHFS_CONFIG
