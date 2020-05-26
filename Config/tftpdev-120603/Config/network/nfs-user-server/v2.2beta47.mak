# nfs-user-server v2.2beta47	[ since v2.2beta47, c.2011-05-31 ]
# last mod WmT, 2011-05-31	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_NFS_USER_SERVER_CONFIG},y)
HAVE_NFS_USER_SERVER_CONFIG:=y

DESCRLIST+= "'nti-nfs-utils' -- nfs-utils"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif

NFS_USER_SERVER_VER=2.2beta47
NFS_USER_SERVER_SRC=${SRCDIR}/n/nfs-user-server_2.2beta47.orig.tar.gz

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/n/nfs-user-server/nfs-user-server_2.2beta47.orig.tar.gz


## ,-----
## |	Extract
## +-----

NTI_NFS_USER_SERVER_TEMP=nti-nfs-user-server-${NFS_USER_SERVER_VER}

NTI_NFS_USER_SERVER_EXTRACTED=${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP}/configure.in

.PHONY: nti-nfs-user-server-extracted
nti-nfs-user-server-extracted: ${NTI_NFS_USER_SERVER_EXTRACTED}

${NTI_NFS_USER_SERVER_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NFS_USER_SERVER_SRC}
	mv ${EXTTEMP}/nfs-server-${NFS_USER_SERVER_VER} ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP}


## ,-----
## |	Configure
## +-----

NTI_NFS_USER_SERVER_CONFIGURED=${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP}/config.status

.PHONY: nti-nfs-user-server-configured
nti-nfs-user-server-configured: nti-nfs-user-server-extracted ${NTI_NFS_USER_SERVER_CONFIGURED}

${NTI_NFS_USER_SERVER_CONFIGURED}: ${NTI_NFS_USER_SERVER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		    ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_NFS_USER_SERVER_BUILT=${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP}/nfs-user-servertp

.PHONY: nti-nfs-user-server-built
nti-nfs-user-server-built: nti-nfs-user-server-configured ${NTI_NFS_USER_SERVER_BUILT}

${NTI_NFS_USER_SERVER_BUILT}: ${NTI_NFS_USER_SERVER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_NFS_USER_SERVER_INSTALLED=${NTI_TC_ROOT}/sbin/in.nfs-user-server

.PHONY: nti-nfs-user-server-installed
nti-nfs-user-server-installed: nti-nfs-user-server-built ${NTI_NFS_USER_SERVER_INSTALLED}

${NTI_NFS_USER_SERVER_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NFS_USER_SERVER_TEMP} || exit 1 ;\
		make install datarootdir=${NTI_TC_ROOT} \
	)

.PHONY: nti-nfs-user-server
nti-nfs-user-server: nti-native-gcc nti-nfs-user-server-installed

NTARGETS+= nti-nfs-user-server

endif	# HAVE_NFS_USER_SERVER_CONFIG
