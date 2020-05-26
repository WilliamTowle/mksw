# libtirpc v0.2.0		[ since v0.2.0, c.2010-06-29 ]
# last mod WmT, 2010-06-29	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LIBTIRPC_CONFIG},y)
HAVE_LIBTIRPC_CONFIG:=y

DESCRIBE+= "'nti-libtirpc' -- libtirpc"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

LIBTIRPC_VER=0.2.0
LIBTIRPC_SRC=${SRCDIR}/l/libtirpc_0.2.0.orig.tar.gz

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/libt/libtirpc/libtirpc_0.2.0.orig.tar.gz

##	package extract

NTI_LIBTIRPC_TEMP=nti-libtirpc-${LIBTIRPC_VER}

NTI_LIBTIRPC_EXTRACTED=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/configure.in

.PHONY: nti-libtirpc-extracted
nti-libtirpc-extracted: ${NTI_LIBTIRPC_EXTRACTED}

${NTI_LIBTIRPC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTIRPC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBTIRPC_SRC}
	mv ${EXTTEMP}/libtirpc-${LIBTIRPC_VER}.orig ${EXTTEMP}/${NTI_LIBTIRPC_TEMP}

##	package configure

NTI_LIBTIRPC_CONFIGURED=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/config.status

.PHONY: nti-libtirpc-configured
nti-libtirpc-configured: nti-libtirpc-extracted ${NTI_LIBTIRPC_CONFIGURED}

${NTI_LIBTIRPC_CONFIGURED}: ${NTI_LIBTIRPC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		PKG_CONFIG=${HTC_ROOT}/usr/bin/pkg-config \
		  ./configure \
			--prefix=${HTC_ROOT}/usr \
			--enable-gss=no \
			|| exit 1 \
	)

##	package build

NTI_LIBTIRPC_BUILT=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/libtirpc.pc

.PHONY: nti-libtirpc-built
nti-libtirpc-built: nti-libtirpc-configured ${NTI_LIBTIRPC_BUILT}

${NTI_LIBTIRPC_BUILT}: ${NTI_LIBTIRPC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_LIBTIRPC_INSTALLED=${HTC_ROOT}/usr/lib/pkgconfig/libtirpc.pc

.PHONY: nti-libtirpc-installed
nti-libtirpc-installed: nti-libtirpc-built ${NTI_LIBTIRPC_INSTALLED}

${NTI_LIBTIRPC_INSTALLED}: ${HTC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		make install datarootdir=${HTC_ROOT} \
	)

.PHONY: nti-libtirpc
nti-libtirpc: nti-pkg-config nti-libtirpc-installed

TARGETS+=nti-libtirpc

endif	# HAVE_LIBTIRPC_CONFIG
