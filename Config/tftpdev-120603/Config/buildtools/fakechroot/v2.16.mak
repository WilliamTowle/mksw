# fakechroot v2.16		[ since v2.10, c.2010-08-31 ]
# last mod WmT, 2012-01-07	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_FAKECHROOT_CONFIG},y)
HAVE_FAKECHROOT_CONFIG:=y

DESCRLIST+= "'nti-fakechroot' -- fakechroot"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/native-gcc/v4.1.2.mak
endif


#FAKECHROOT_VER=2.10
FAKECHROOT_VER=2.16
FAKECHROOT_SRC=${SRCDIR}/f/fakechroot_${FAKECHROOT_VER}.orig.tar.gz

#URLS+= http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_${FAKECHROOT_VER}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/f/fakechroot/fakechroot_${FAKECHROOT_VER}.orig.tar.gz


## ,-----
## |	Extract
## +-----

NTI_FAKECHROOT_TEMP=nti-fakechroot-${FAKECHROOT_VER}

NTI_FAKECHROOT_EXTRACTED=${EXTTEMP}/${NTI_FAKECHROOT_TEMP}/configure

.PHONY: nti-fakechroot-extracted

nti-fakechroot-extracted: ${NTI_FAKECHROOT_EXTRACTED}

${NTI_FAKECHROOT_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FAKECHROOT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${FAKECHROOT_SRC}
	mv ${EXTTEMP}/fakechroot-${FAKECHROOT_VER} ${EXTTEMP}/${NTI_FAKECHROOT_TEMP}


## ,-----
## |	Configure
## +-----

NTI_FAKECHROOT_CONFIGURED=${EXTTEMP}/${NTI_FAKECHROOT_TEMP}/config.status

.PHONY: nti-fakechroot-configured

nti-fakechroot-configured: nti-fakechroot-extracted ${NTI_FAKECHROOT_CONFIGURED}

${NTI_FAKECHROOT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_FAKECHROOT_BUILT=${EXTTEMP}/${NTI_FAKECHROOT_TEMP}/src/libfakechroot.la

.PHONY: nti-fakechroot-built
nti-fakechroot-built: nti-fakechroot-configured ${NTI_FAKECHROOT_BUILT}

${NTI_FAKECHROOT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_FAKECHROOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/fakechroot

.PHONY: nti-fakechroot-installed

nti-fakechroot-installed: nti-fakechroot-built ${NTI_FAKECHROOT_INSTALLED}

${NTI_FAKECHROOT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-fakechroot
nti-fakechroot: nti-fakechroot-installed

NTARGETS+= nti-fakechroot

endif	# HAVE_FAKECHROOT_CONFIG
