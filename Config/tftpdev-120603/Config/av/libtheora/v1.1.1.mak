# libtheora v1.1.1		[ since v1.1.1, c.2010-07-30 ]
# last mod WmT, 2010-07-30	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_LIBTHEORA_CONFIG},y)
HAVE_LIBTHEORA_CONFIG:=y

DESCRLIST+= "'nti-libtheora' -- libtheora"

include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak


LIBTHEORA_VER=1.1.1
LIBTHEORA_SRC=${SRCDIR}/l/libtheora-1.1.1.tar.bz2

URLS+=http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2

##	package extract

NTI_LIBTHEORA_TEMP=nti-libtheora-${LIBTHEORA_VER}

NTI_LIBTHEORA_EXTRACTED=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/Makefile

.PHONY: nti-libtheora-extracted

nti-libtheora-extracted: ${NTI_LIBTHEORA_EXTRACTED}

${NTI_LIBTHEORA_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTHEORA_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBTHEORA_SRC}
	mv ${EXTTEMP}/libtheora-${LIBTHEORA_VER} ${EXTTEMP}/${NTI_LIBTHEORA_TEMP}

##	package configure

NTI_LIBTHEORA_CONFIGURED=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/config.status

.PHONY: nti-libtheora-configured

nti-libtheora-configured: nti-libtheora-extracted ${NTI_LIBTHEORA_CONFIGURED}

${NTI_LIBTHEORA_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

NTI_LIBTHEORA_BUILT=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/theora.pc

.PHONY: nti-libtheora-built
nti-libtheora-built: nti-libtheora-configured ${NTI_LIBTHEORA_BUILT}

${NTI_LIBTHEORA_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_LIBTHEORA_INSTALLED=${HTC_ROOT}/usr/lib/pkgconfig/theora.pc

.PHONY: nti-libtheora-installed

nti-libtheora-installed: nti-libtheora-built ${NTI_LIBTHEORA_INSTALLED}

${NTI_LIBTHEORA_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libtheora
nti-libtheora: nti-pkg-config nti-native-gcc nti-libtheora-installed

TARGETS+= nti-libtheora

endif	# HAVE_LIBTHEORA_CONFIG
