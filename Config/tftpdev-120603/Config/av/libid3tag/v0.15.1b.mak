# libid3tag v0.15.1b		[ since v0.15.0b, c.2004-04-15 ]
# last mod WmT, 2009-09-01	[ (c) and GPLv2 1999-2009 ]

ifneq (${HAVE_LIBID3TAG_CONFIG},y)
HAVE_LIBID3TAG_CONFIG:=y

DESCRLIST+= "'nti-libid3tag' -- libid3tag"

include ${CFG_ROOT}/ENV/native.mak

include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak


LIBID3TAG_VER=0.15.1b
LIBID3TAG_SRC=${SRCDIR}/l/libid3tag_${LIBID3TAG_VER}.orig.tar.gz

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libi/libid3tag/libid3tag_0.15.1b.orig.tar.gz

##	package extract

NTI_LIBID3TAG_TEMP=nti-libid3tag-${LIBID3TAG_VER}

NTI_LIBID3TAG_EXTRACTED=${EXTTEMP}/${NTI_LIBID3TAG_TEMP}/Makefile

.PHONY: nti-libid3tag-extracted

nti-libid3tag-extracted: ${NTI_LIBID3TAG_EXTRACTED}

${NTI_LIBID3TAG_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBID3TAG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBID3TAG_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBID3TAG_SRC}
	mv ${EXTTEMP}/libid3tag-${LIBID3TAG_VER} ${EXTTEMP}/${NTI_LIBID3TAG_TEMP}

##	package configure

NTI_LIBID3TAG_CONFIGURED=${EXTTEMP}/${NTI_LIBID3TAG_TEMP}/config.status

.PHONY: nti-libid3tag-configured

nti-libid3tag-configured: nti-libid3tag-extracted ${NTI_LIBID3TAG_CONFIGURED}

${NTI_LIBID3TAG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBID3TAG_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

NTI_LIBID3TAG_BUILT=${EXTTEMP}/${NTI_LIBID3TAG_TEMP}/.libs/libid3tag.a

.PHONY: nti-libid3tag-built
nti-libid3tag-built: nti-libid3tag-configured ${NTI_LIBID3TAG_BUILT}

${NTI_LIBID3TAG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBID3TAG_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_LIBID3TAG_INSTALLED=${HTC_ROOT}/usr/lib/libid3tag.a

.PHONY: nti-libid3tag-installed

nti-libid3tag-installed: nti-libid3tag-built ${NTI_LIBID3TAG_INSTALLED}

${NTI_LIBID3TAG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBID3TAG_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libid3tag
nti-libid3tag: nti-native-gcc nti-libid3tag-installed

TARGETS+= nti-libid3tag

endif	# HAVE_LIBID3TAG_CONFIG
