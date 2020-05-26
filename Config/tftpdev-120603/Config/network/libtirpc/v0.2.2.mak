# libtirpc v0.2.2		[ since v0.2.0, c.2010-06-29 ]
# last mod WmT, 2010-06-29	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LIBTIRPC_CONFIG},y)
HAVE_LIBTIRPC_CONFIG:=y

DESCRLIST+= "'nti-libtirpc' -- libtirpc"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

#LIBTIRPC_VER=0.2.0
LIBTIRPC_VER=0.2.2
ifeq (${LIBTIRPC},0.2.0)
LIBTIRPC_SRC=${SRCDIR}/l/libtirpc_0.2.0.orig.tar.gz
else
LIBTIRPC_SRC=${SRCDIR}/l/libtirpc-0.2.2.tar.bz2
endif

ifeq (${LIBTIRPC},0.2.0)
URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/libt/libtirpc/libtirpc_0.2.0.orig.tar.gz
else
URL=http://downloads.sourceforge.net/project/libtirpc/libtirpc/0.2.2/libtirpc-0.2.2.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flibtirpc%2F&ts=1306236587&use_mirror=kent
endif


## ,-----
## |	Extract
## +-----

NTI_LIBTIRPC_TEMP=nti-libtirpc-${LIBTIRPC_VER}

NTI_LIBTIRPC_EXTRACTED=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/configure.in

.PHONY: nti-libtirpc-extracted
nti-libtirpc-extracted: ${NTI_LIBTIRPC_EXTRACTED}

${NTI_LIBTIRPC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTIRPC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBTIRPC_SRC}
ifeq (${LIBTIRPC},0.2.0)
	mv ${EXTTEMP}/libtirpc-${LIBTIRPC_VER}.orig ${EXTTEMP}/${NTI_LIBTIRPC_TEMP}
else
	mv ${EXTTEMP}/libtirpc-${LIBTIRPC_VER} ${EXTTEMP}/${NTI_LIBTIRPC_TEMP}
endif


## ,-----
## |	Configure
## +-----

NTI_LIBTIRPC_CONFIGURED=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/config.status

.PHONY: nti-libtirpc-configured
nti-libtirpc-configured: nti-libtirpc-extracted ${NTI_LIBTIRPC_CONFIGURED}

${NTI_LIBTIRPC_CONFIGURED}: ${NTI_LIBTIRPC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		  CC=${NTI_GCC} \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-gss=no \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_LIBTIRPC_BUILT=${EXTTEMP}/${NTI_LIBTIRPC_TEMP}/libtirpc.pc

.PHONY: nti-libtirpc-built
nti-libtirpc-built: nti-libtirpc-configured ${NTI_LIBTIRPC_BUILT}

${NTI_LIBTIRPC_BUILT}: ${NTI_LIBTIRPC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_LIBTIRPC_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/libtirpc.pc

.PHONY: nti-libtirpc-installed
nti-libtirpc-installed: nti-libtirpc-built ${NTI_LIBTIRPC_INSTALLED}

${NTI_LIBTIRPC_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTIRPC_TEMP} || exit 1 ;\
		make install datarootdir=${NTI_TC_ROOT} \
	)

.PHONY: nti-libtirpc
nti-libtirpc: nti-pkg-config nti-libtirpc-installed

NTARGETS+= nti-libtirpc

endif	# HAVE_LIBTIRPC_CONFIG
