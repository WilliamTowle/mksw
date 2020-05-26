# mt-daapd v0.2.4.2		[ since v0.2.4.2, c.2009-09-01 ]
# last mod WmT, 2009-09-01	[ (c) and GPLv2 1999-2009 ]

ifneq (${HAVE_MTDAAPD_CONFIG},y)
HAVE_MTDAAPD_CONFIG:=y

DESCRLIST+= "'nti-mt-daapd' -- mt-daapd"

include ${CFG_ROOT}/ENV/native.mak

include ${CFG_ROOT}/av/libid3tag/v0.15.1b.mak
include ${CFG_ROOT}/misc/gdbm/v1.8.3.mak
include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak


MTDAAPD_VER=0.2.4.2
MTDAAPD_SRC=${SRCDIR}/m/mt-daapd-${MTDAAPD_VER}.tar.gz

URLS+=http://downloads.sourceforge.net/project/mt-daapd/mt-daapd/0.2.4.2/mt-daapd-0.2.4.2.tar.gz?use_mirror=heanet

##	package extract

NTI_MTDAAPD_TEMP=nti-mt-daapd-${MTDAAPD_VER}

NTI_MTDAAPD_EXTRACTED=${EXTTEMP}/${NTI_MTDAAPD_TEMP}/Makefile

.PHONY: nti-mt-daapd-extracted

nti-mt-daapd-extracted: ${NTI_MTDAAPD_EXTRACTED}

${NTI_MTDAAPD_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MTDAAPD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MTDAAPD_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MTDAAPD_SRC}
	mv ${EXTTEMP}/mt-daapd-${MTDAAPD_VER} ${EXTTEMP}/${NTI_MTDAAPD_TEMP}

##	package configure

NTI_MTDAAPD_CONFIGURED=${EXTTEMP}/${NTI_MTDAAPD_TEMP}/config.status

.PHONY: nti-mt-daapd-configured

nti-mt-daapd-configured: nti-mt-daapd-extracted ${NTI_MTDAAPD_CONFIGURED}

${NTI_MTDAAPD_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MTDAAPD_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2 -DDEFAULT_CONFIGFILE=\"$${sysconfdir}\"' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			--sysconfdir=${HTC_ROOT}/etc \
			--localstatedir=${HTC_ROOT}/var \
			--with-id3tag=${HTC_ROOT}/usr \
			--with-gdbm-includes=${HTC_ROOT}/usr/include \
			--with-gdbm-libs=${HTC_ROOT}/usr/lib \
			|| exit 1 \
	)

##	package build

NTI_MTDAAPD_BUILT=${EXTTEMP}/${NTI_MTDAAPD_TEMP}/src/mt-daapd

.PHONY: nti-mt-daapd-built
nti-mt-daapd-built: nti-mt-daapd-configured ${NTI_MTDAAPD_BUILT}

${NTI_MTDAAPD_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MTDAAPD_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_MTDAAPD_INSTALLED=${HTC_ROOT}/usr/sbin/mt-daapd

.PHONY: nti-mt-daapd-installed

nti-mt-daapd-installed: nti-mt-daapd-built ${NTI_MTDAAPD_INSTALLED}

${NTI_MTDAAPD_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${HTC_ROOT}/etc/
	mkdir -p ${HTC_ROOT}/var/cache/mt-daapd
	( cd ${EXTTEMP}/${NTI_MTDAAPD_TEMP} || exit 1 ;\
		cp -ar admin-root ${HTC_ROOT}/etc/mt-daapd-www ;\
		cp contrib/mt-daapd.playlist ${HTC_ROOT}/etc || exit 1 ;\
		cat contrib/mt-daapd.conf \
			| sed '/^mp3_dir/	s%/.*%/opt/local/music/mp3/%' \
			| sed '/^playlist/	s%/.*%'${HTC_ROOT}'/etc/mt-daapd.playlist%' \
			| sed '/^web_root/	s%/.*%'${HTC_ROOT}'/etc/mt-daapd-www%' \
			> ${HTC_ROOT}/etc/mt-daapd.conf || exit 1 ;\
		make install \
	)

.PHONY: nti-mt-daapd
nti-mt-daapd: nti-native-gcc nti-libid3tag nti-gdbm nti-mt-daapd-installed

TARGETS+= nti-mt-daapd

endif	# HAVE_MTDAAPD_CONFIG
