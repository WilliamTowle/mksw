# fakeroot v1.10.1		[ EARLIEST v1.0.6, c.2005-08-12 ]
# last mod WmT, 2010-08-31	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_FAKEROOT_CONFIG},y)
HAVE_FAKEROOT_CONFIG:=y

DESCRLIST+= "'nti-fakeroot' -- fakeroot"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak

FAKEROOT_VER=1.10.1

FAKEROOT_SRC=${SRCDIR}/f/fakeroot_1.10.1.tar.gz
URLS+= http://fakeroot.sourcearchive.com/downloads/${FAKEROOT_VER}/fakeroot_${FAKEROOT_SRC}.tar.gz


## ,-----
## |	package extract
## +-----

NTI_FAKEROOT_TEMP=nti-fakeroot-${FAKEROOT_VER}

NTI_FAKEROOT_EXTRACTED=${EXTTEMP}/${NTI_FAKEROOT_TEMP}/configure

.PHONY: nti-fakeroot-extracted

nti-fakeroot-extracted: ${NTI_FAKEROOT_EXTRACTED}

${NTI_FAKEROOT_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_FAKEROOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FAKEROOT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${FAKEROOT_SRC}
	mv ${EXTTEMP}/fakeroot-${FAKEROOT_VER} ${EXTTEMP}/${NTI_FAKEROOT_TEMP}


## ,-----
## |	package configure
## +-----

NTI_FAKEROOT_CONFIGURED=${EXTTEMP}/${NTI_FAKEROOT_TEMP}/config.status

.PHONY: nti-fakeroot-configured

nti-fakeroot-configured: nti-fakeroot-extracted ${NTI_FAKEROOT_CONFIGURED}

${NTI_FAKEROOT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	package build
## +-----

NTI_FAKEROOT_BUILT=${EXTTEMP}/${NTI_FAKEROOT_TEMP}/faked

.PHONY: nti-fakeroot-built
nti-fakeroot-built: nti-fakeroot-configured ${NTI_FAKEROOT_BUILT}

${NTI_FAKEROOT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	package install
## +-----

NTI_FAKEROOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked

.PHONY: nti-fakeroot-installed

nti-fakeroot-installed: nti-fakeroot-built ${NTI_FAKEROOT_INSTALLED}

${NTI_FAKEROOT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FAKEROOT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-fakeroot
nti-fakeroot: nti-fakeroot-installed

TARGETS+=nti-fakeroot

endif	# HAVE_FAKEROOT_CONFIG
