# hostapd v2.4			[ since v2.1, c.2014-02-28 ]
# last mod WmT, 2015-03-25	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_HOSTAPD_CONFIG},y)
HAVE_HOSTAPD_CONFIG:=y

#DESCRLIST+= "'nti-hostapd' -- hostapd"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${HOSTAPD_VERSION},)
#HOSTAPD_VERSION=2.1
HOSTAPD_VERSION=2.4
endif

HOSTAPD_SRC=${SOURCES}/h/hostapd-${HOSTAPD_VERSION}.tar.gz
URLS+= http://hostap.epitest.fi/releases/hostapd-${HOSTAPD_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

include ${CFG_ROOT}/network/openssl/v1.0.2a.mak
include ${CFG_ROOT}/network/libnl/v3.2.25.mak

NTI_HOSTAPD_TEMP=nti-hostapd-${HOSTAPD_VERSION}

NTI_HOSTAPD_EXTRACTED=${EXTTEMP}/${NTI_HOSTAPD_TEMP}/README
NTI_HOSTAPD_CONFIGURED=${EXTTEMP}/${NTI_HOSTAPD_TEMP}/hostapd/.config
NTI_HOSTAPD_BUILT=${EXTTEMP}/${NTI_HOSTAPD_TEMP}/hostapd/hostapd
NTI_HOSTAPD_INSTALLED=${NTI_TC_ROOT}/usr/bin/hostapd


## ,-----
## |	Extract
## +-----

${NTI_HOSTAPD_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/hostapd-${HOSTAPD_VERSION} ] || rm -rf ${EXTTEMP}/hostapd-${HOSTAPD_VERSION}
	zcat ${HOSTAPD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_HOSTAPD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_HOSTAPD_TEMP}
	mv ${EXTTEMP}/hostapd-${HOSTAPD_VERSION} ${EXTTEMP}/${NTI_HOSTAPD_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_HOSTAPD_CONFIGURED}: ${NTI_HOSTAPD_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_HOSTAPD_TEMP} || exit 1 ;\
		[ -r hostapd/Makefile.OLD ] || mv hostapd/Makefile hostapd/Makefile.OLD || exit 1 ;\
		cat hostapd/Makefile.OLD \
			| sed '/^ifndef CC/,/endif/	{ s/^\([ie]\)/#&/ ; s%g*cc%'${NTI_GCC}'% } ' \
			| sed '/-lcrypto/	s%-lcrypto%-L'${NTI_TC_ROOT}'/usr/lib -lcrypto%' \
			| sed '/^export BINDIR/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/	s%$$(DESTDIR)/usr/local%$$(DESTDIR)/'${NTI_TC_ROOT}'/usr%' \
			> hostapd/Makefile ;\
		cat hostapd/defconfig \
			| sed '/CONFIG_TLS/		s%$$%\LIBS += -L'${NTI_TC_ROOT}'/usr/lib\n%' \
			| sed '/CONFIG_TLS/		s%$$%\nCFLAGS += -I'${NTI_TC_ROOT}'/usr/include\n%' \
			| sed '/CFLAGS.*libnl/		{ s/^#// ; s%-I.*%-I'${NTI_TC_ROOT}'/usr/include/libnl3% }' \
			| sed '/LIBS.*libnl/		{ s/^#// ; s%-L.*%-I'${NTI_TC_ROOT}'/usr/lib% }' \
			| sed '/CONFIG_LIBNL32/		s/^#// ' \
			> hostapd/.config \
	)


## ,-----
## |	Build
## +-----

${NTI_HOSTAPD_BUILT}: ${NTI_HOSTAPD_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_HOSTAPD_TEMP} || exit 1 ;\
		make -C hostapd \
			PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
			PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
	)


## ,-----
## |	Install
## +-----

${NTI_HOSTAPD_INSTALLED}: ${NTI_HOSTAPD_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_HOSTAPD_TEMP} || exit 1 ;\
		make -C hostapd install \
			PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
			PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
	)

##

.PHONY: nti-hostapd
nti-hostapd: nti-pkg-config nti-libtool \
	nti-libnl nti-openssl ${NTI_HOSTAPD_INSTALLED}

ALL_NTI_TARGETS+= nti-hostapd

endif	# HAVE_HOSTAPD_CONFIG
