# fakeroot-ng v0.16		[ EARLIEST v0.16, c.2011-09-02 ]
# last mod WmT, 2011-09-02	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_FAKEROOT_NG_CONFIG},y)
HAVE_FAKEROOT_NG_CONFIG:=y

DESCRLIST+= "'nti-fakeroot-ng' -- fakeroot-ng"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

FAKEROOT_NG_VER=0.16
FAKEROOT_NG_SRC=${SRCDIR}/f/fakeroot-ng_0.16.orig.tar.gz

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/f/fakeroot-ng/fakeroot-ng_0.16.orig.tar.gz


## ,-----
## |	package extract
## +-----

NTI_FAKEROOT_NG_TEMP=nti-fakeroot-ng-${FAKEROOT_NG_VER}

NTI_FAKEROOT_NG_EXTRACTED=${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP}/configure

.PHONY: nti-fakeroot-ng-extracted

nti-fakeroot-ng-extracted: ${NTI_FAKEROOT_NG_EXTRACTED}

${NTI_FAKEROOT_NG_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${FAKEROOT_NG_SRC}
	mv ${EXTTEMP}/fakeroot-ng-${FAKEROOT_NG_VER} ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP}


## ,-----
## |	package configure
## +-----

NTI_FAKEROOT_NG_CONFIGURED=${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP}/config.status

.PHONY: nti-fakeroot-ng-configured

nti-fakeroot-ng-configured: nti-fakeroot-ng-extracted ${NTI_FAKEROOT_NG_CONFIGURED}

${NTI_FAKEROOT_NG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	package build
## +-----

NTI_FAKEROOT_NG_BUILT=${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP}/faked

.PHONY: nti-fakeroot-ng-built
nti-fakeroot-ng-built: nti-fakeroot-ng-configured ${NTI_FAKEROOT_NG_BUILT}

${NTI_FAKEROOT_NG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	package install
## +-----

NTI_FAKEROOT_NG_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked

.PHONY: nti-fakeroot-ng-installed

nti-fakeroot-ng-installed: nti-fakeroot-ng-built ${NTI_FAKEROOT_NG_INSTALLED}

${NTI_FAKEROOT_NG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_NG_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-fakeroot-ng
nti-fakeroot-ng: nti-native-gcc nti-fakeroot-ng-installed

NTARGETS+= nti-fakeroot-ng

endif	# HAVE_FAKEROOT_NG_CONFIG
