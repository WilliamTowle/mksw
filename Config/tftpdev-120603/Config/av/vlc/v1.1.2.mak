# vlc v1.1.2			[ since v0.7.2, c.2004-01-31 ]
# last mod WmT, 2010-08-02	[ (c) and GPLv2 1999-2010 ]

# TODO: libmad can be done

ifneq (${HAVE_VLC_CONFIG},y)
HAVE_VLC_CONFIG:=y

DESCRLIST+= "'nti-vlc' -- vlc"

include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak


VLC_VER=1.1.2
VLC_SRC=${SRCDIR}/v/vlc-1.1.2.tar.bz2

URLS+=http://garr.dl.sourceforge.net/project/vlc/1.1.2/vlc-1.1.2.tar.bz2

##	package extract

NTI_VLC_TEMP=nti-vlc-${VLC_VER}

NTI_VLC_EXTRACTED=${EXTTEMP}/${NTI_VLC_TEMP}/Makefile

.PHONY: nti-vlc-extracted

nti-vlc-extracted: ${NTI_VLC_EXTRACTED}

${NTI_VLC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_VLC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VLC_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${VLC_SRC}
	mv ${EXTTEMP}/vlc-${VLC_VER} ${EXTTEMP}/${NTI_VLC_TEMP}

##	package configure

NTI_VLC_CONFIGURED=${EXTTEMP}/${NTI_VLC_TEMP}/config.status

.PHONY: nti-vlc-configured

nti-vlc-configured: nti-vlc-extracted ${NTI_VLC_CONFIGURED}

${NTI_VLC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_VLC_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			--disable-a52 \
			--disable-avcodec \
			--disable-dbus \
			--disable-lua \
			--disable-mad \
			--disable-postproc \
			--without-xcb \
			|| exit 1 \
	)

##	package build

NTI_VLC_BUILT=${EXTTEMP}/${NTI_VLC_TEMP}/vorbis.pc

.PHONY: nti-vlc-built
nti-vlc-built: nti-vlc-configured ${NTI_VLC_BUILT}

${NTI_VLC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_VLC_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_VLC_INSTALLED=${HTC_ROOT}/usr/lib/pkgconfig/vorbis.pc

.PHONY: nti-vlc-installed

nti-vlc-installed: nti-vlc-built ${NTI_VLC_INSTALLED}

${NTI_VLC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_VLC_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-vlc
nti-vlc: nti-pkg-config nti-native-gcc nti-vlc-installed

TARGETS+= nti-vlc

endif	# HAVE_VLC_CONFIG
