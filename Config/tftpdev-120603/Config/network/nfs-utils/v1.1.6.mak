# nfs-utils v1.1.6		[ since v1.2.2, c.2010-06-29 ]
# last mod WmT, 2011-05-31	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_NFSUTILS_CONFIG},y)
HAVE_NFSUTILS_CONFIG:=y

DESCRLIST+= "'nti-nfs-utils' -- nfs-utils"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/fstools/e2fsprogs-libs/v1.41.14.mak


#NFSUTILS_VER=1.1.0
#NFSUTILS_VER=1.1.1
#NFSUTILS_VER=1.1.2
#NFSUTILS_VER=1.1.3
#NFSUTILS_VER=1.1.4
NFSUTILS_VER=1.1.6
NFSUTILS_SRC=${SRCDIR}/n/nfs-utils-${NFSUTILS_VER}.tar.bz2
#NFSUTILS_SRC=${SRCDIR}/n/nfs-utils-${NFSUTILS_VER}.tar.gz

URLS+= http://sourceforge.net/projects/nfs/files/nfs-utils/${NFSUTILS_VER}/nfs-utils-${NFSUTILS_VER}.tar.bz2/download
#URLS+= http://sourceforge.net/projects/nfs/files/nfs-utils/${NFSUTILS_VER}/nfs-utils-${NFSUTILS_VER}.tar.gz/download


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
		  CC=${NTI_GCC} \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-nfsv4 \
			--disable-gss \
			--disable-uuid \
			--with-tcp-wrappers=no \
			|| exit 1 ;\
		mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^statedir/	s%/var%$${exec_prefix}/var%' \
			> Makefile || exit 1 ;\
		mv utils/mount/Makefile utils/mount/Makefile.OLD || exit 1 ;\
		cat utils/mount/Makefile.OLD \
			| sed '/^sbindir/	s%/sbin%$${exec_prefix}/sbin%' \
			> utils/mount/Makefile || exit 1 \
	)
#		mv support/misc/tcpwrapper.c support/misc/tcpwrapper.c.OLD || exit 1 ;\
#		cat support/misc/tcpwrapper.c.OLD \
#			| sed '/xlog.h/ s%$$%\n#include "utils/idmapd/queue.h"%' \
#			> support/misc/tcpwrapper.c || exit 1 \


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
nti-nfsutils: nti-native-gcc nti-pkg-config nti-e2fsprogs-libs-installed nti-nfsutils-installed

NTARGETS+= nti-nfsutils

endif	# HAVE_NFSUTILS_CONFIG
