# nfs-utils v1.2.3		[ since v1.2.2, c.2010-06-29 ]
# last mod WmT, 2011-05-27	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_NFSUTILS_CONFIG},y)
HAVE_NFSUTILS_CONFIG:=y

DESCRLIST+= "'nti-nfs-utils' -- nfs-utils"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

#ifneq (${HAVE_NATIVE_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
#endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/network/libtirpc/v0.2.1.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.41.14.mak


#NFSUTILS_VER=1.2.0
#NFSUTILS_VER=1.2.1
#NFSUTILS_VER=1.2.2
NFSUTILS_VER=1.2.3
#NFSUTILS_SRC=${SRCDIR}/n/nfs-utils_1.2.2.orig.tar.bz2
NFSUTILS_SRC=${SRCDIR}/n/nfs-utils-${NFSUTILS_VER}.tar.bz2

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/n/nfs-utils/nfs-utils_1.2.2.orig.tar.bz2
URLS+= http://sourceforge.net/projects/nfs/files/nfs-utils/${NFSUTILS_VER}/nfs-utils-${NFSUTILS_VER}.tar.bz2/download


## ,-----
## |	Extract
## +-----

NTI_NFSUTILS_TEMP=nti-nfsutils-${NFSUTILS_VER}

NTI_NFSUTILS_EXTRACTED=${EXTTEMP}/${NTI_NFSUTILS_TEMP}/configure.in

.PHONY: nti-nfsutils-extracted
nti-nfsutils-extracted: ${NTI_NFSUTILS_EXTRACTED}

${NTI_NFSUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NFSUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NFSUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NFSUTILS_SRC}
	mv ${EXTTEMP}/nfs-utils-${NFSUTILS_VER} ${EXTTEMP}/${NTI_NFSUTILS_TEMP}


## ,-----
## |	Configure
## +-----

NTI_NFSUTILS_CONFIGURED=${EXTTEMP}/${NTI_NFSUTILS_TEMP}/config.status

.PHONY: nti-nfsutils-configured
nti-nfsutils-configured: nti-nfsutils-extracted ${NTI_NFSUTILS_CONFIGURED}

${NTI_NFSUTILS_CONFIGURED}: ${NTI_NFSUTILS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NFSUTILS_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		  CC=${NUI_CC_PREFIX}'cc' \
		  LDFLAGS="-L${NTI_TC_ROOT}/usr/lib" \
		    ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--sysconfdir=${NTI_TC_ROOT}/etc \
			--disable-ipv6 \
			--disable-mount \
			--disable-nfsv4 \
			--disable-nfsv41 \
			--disable-gss \
			--disable-largefile \
			--with-tirpcinclude=${NTI_TC_ROOT}/usr/include/tirpc/ \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_NFSUTILS_BUILT=${EXTTEMP}/${NTI_NFSUTILS_TEMP}/nfsutilstp

.PHONY: nti-nfsutils-built
nti-nfsutils-built: nti-nfsutils-configured ${NTI_NFSUTILS_BUILT}

${NTI_NFSUTILS_BUILT}: ${NTI_NFSUTILS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NFSUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_NFSUTILS_INSTALLED=${NTI_TC_ROOT}/sbin/in.nfsutils

.PHONY: nti-nfsutils-installed
nti-nfsutils-installed: nti-nfsutils-built ${NTI_NFSUTILS_INSTALLED}

${NTI_NFSUTILS_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NFSUTILS_TEMP} || exit 1 ;\
		make install datarootdir=${NTI_TC_ROOT} \
	)

.PHONY: nti-nfsutils
#nti-nfsutils: nti-native-gcc nti-pkg-config nti-libtirpc nti-e2fsprogs-libs-installed nti-nfsutils-installed
nti-nfsutils: nti-pkg-config nti-libtirpc nti-e2fsprogs-libs-installed nti-nfsutils-installed

NTARGETS+= nti-nfsutils

endif	# HAVE_NFSUTILS_CONFIG
