# libao 0.8.8			[ since v2.13, c.2009-11-20 ]
# last mod WmT, 2011-10-01	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LIBAO_CONFIG},y)
HAVE_LIBAO_CONFIG:=y

DESCRLIST+= "'nti-uade' -- uade"
DESCRLIST+= "'cti-uade' -- uade"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

LIBAO_VER:= 0.8.8
LIBAO_SRC:= ${SRCDIR}/l/libao-${LIBAO_VER}.tar.gz

URLS+= http://downloads.xiph.org/releases/ao/libao-${LIBAO_VER}.tar.gz

NTI_LIBAO_TEMP=nti-libao-${LIBAO_VER}
NTI_LIBAO_EXTRACTED=${EXTTEMP}/${NTI_LIBAO_TEMP}/Makefile.in
NTI_LIBAO_BUILT=${EXTTEMP}/${NTI_LIBAO_TEMP}/src/libao.la
NTI_LIBAO_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ao.pc


# ,-----
# |	Extract
# +-----

CTI_LIBAO_TEMP=cti-libao-${LIBAO_VER}

CTI_LIBAO_EXTRACTED=${EXTTEMP}/${CTI_LIBAO_TEMP}/Makefile.in

.PHONY: cti-libao-extracted

cti-libao-extracted: ${CTI_LIBAO_EXTRACTED}

${CTI_LIBAO_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_LIBAO_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBAO_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBAO_SRC}
	mv ${EXTTEMP}/libao-${LIBAO_VER} ${EXTTEMP}/${CTI_LIBAO_TEMP}

##

.PHONY: nti-libao-extracted

nti-libao-extracted: ${NTI_LIBAO_EXTRACTED}

${NTI_LIBAO_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBAO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBAO_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBAO_SRC}
	mv ${EXTTEMP}/libao-${LIBAO_VER} ${EXTTEMP}/${NTI_LIBAO_TEMP}


# ,-----
# |	Configure
# +-----

CTI_LIBAO_CONFIGURED=${EXTTEMP}/${CTI_LIBAO_TEMP}/ao.pc

.PHONY: cti-libao-configured

cti-libao-configured: cti-libao-extracted ${CTI_LIBAO_CONFIGURED}

${CTI_LIBAO_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LIBAO_TEMP} || exit 1 ;\
	  CC=${CTI_GCC} \
	    CFLAGS='-O2' \
	    PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			|| exit 1 \
	)

##

NTI_LIBAO_CONFIGURED=${EXTTEMP}/${NTI_LIBAO_TEMP}/ao.pc

.PHONY: nti-libao-configured

nti-libao-configured: nti-libao-extracted ${NTI_LIBAO_CONFIGURED}

${NTI_LIBAO_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
	  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

CTI_LIBAO_BUILT=${EXTTEMP}/${CTI_LIBAO_TEMP}/src/libao.la

.PHONY: cti-libao-built
cti-libao-built: cti-libao-configured ${CTI_LIBAO_BUILT}

${CTI_LIBAO_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LIBAO_TEMP} || exit 1 ;\
		make \
	)

##

.PHONY: nti-libao-built
nti-libao-built: nti-libao-configured ${NTI_LIBAO_BUILT}

${NTI_LIBAO_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

CTI_LIBAO_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/ao.pc

.PHONY: cti-libao-installed

cti-libao-installed: cti-libao-built ${CTI_LIBAO_INSTALLED}

${CTI_LIBAO_INSTALLED}:
	( cd ${EXTTEMP}/${CTI_LIBAO_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: cti-libao
cti-libao: cti-cross-gcc cti-cross-pkg-config cti-libao-installed

CTARGETS+= cti-libao

##

.PHONY: nti-libao-installed

nti-libao-installed: nti-libao-built ${NTI_LIBAO_INSTALLED}

${NTI_LIBAO_INSTALLED}:
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/ao.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ \
	)

.PHONY: nti-libao
nti-libao: nti-gcc nti-pkg-config nti-libao-installed

NTARGETS+= nti-libao

endif	# HAVE_LIBAO_CONFIG
