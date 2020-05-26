# fakechroot v2.10		[ since v2.10, c.2010-08-31 ]
# last mod WmT, 2010-08-31	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_FAKECHROOT_CONFIG},y)
HAVE_FAKECHROOT_CONFIG:=y

DESCRLIST+= "'nti-fakechroot' -- fakechroot"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak

FAKECHROOT_VER=2.10
FAKECHROOT_SRC=${SRCDIR}/f/fakechroot_2.10.orig.tar.gz

URLS+= http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_2.10.orig.tar.gz


## ,-----
## |	package extract
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
## |	package configure
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
## |	package build
## +-----

NTI_FAKECHROOT_BUILT=${EXTTEMP}/${NTI_FAKECHROOT_TEMP}/faked

.PHONY: nti-fakechroot-built
nti-fakechroot-built: nti-fakechroot-configured ${NTI_FAKECHROOT_BUILT}

${NTI_FAKECHROOT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	package install
## +-----

NTI_FAKECHROOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked

.PHONY: nti-fakechroot-installed

nti-fakechroot-installed: nti-fakechroot-built ${NTI_FAKECHROOT_INSTALLED}

${NTI_FAKECHROOT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FAKECHROOT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-fakechroot
nti-fakechroot: nti-fakechroot-installed

TARGETS+=nti-fakechroot

endif	# HAVE_FAKECHROOT_CONFIG
