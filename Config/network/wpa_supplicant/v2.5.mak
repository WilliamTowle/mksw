# wpa_supplicant v2.5		[ since v2.1, c.2014-03-27 ]
# last mod WmT, 2016-02-01	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_WPA_SUPPLICANT_CONFIG},y)
HAVE_WPA_SUPPLICANT_CONFIG:=y

#DESCRLIST+= "'nti-wpa_supplicant' -- wpa_supplicant"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


ifeq (${WPA_SUPPLICANT_VERSION},)
#WPA_SUPPLICANT_VERSION=2.1
#WPA_SUPPLICANT_VERSION=2.4
WPA_SUPPLICANT_VERSION=2.5
endif

#include ${CFG_ROOT}/network/openssl/v1.0.2d.mak
include ${CFG_ROOT}/network/openssl/v1.0.2f.mak
include ${CFG_ROOT}/network/libnl/v3.2.25.mak

WPA_SUPPLICANT_SRC=${SOURCES}/w/wpa_supplicant-${WPA_SUPPLICANT_VERSION}.tar.gz
URLS+= http://hostap.epitest.fi/releases/wpa_supplicant-${WPA_SUPPLICANT_VERSION}.tar.gz

NTI_WPA_SUPPLICANT_TEMP=nti-wpa_supplicant-${WPA_SUPPLICANT_VERSION}

NTI_WPA_SUPPLICANT_EXTRACTED=${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP}/README
NTI_WPA_SUPPLICANT_CONFIGURED=${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP}/wpa_supplicant/.config
NTI_WPA_SUPPLICANT_BUILT=${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP}/wpa_supplicant/wpa_supplicant
NTI_WPA_SUPPLICANT_INSTALLED=${NTI_TC_ROOT}/usr/sbin/wpa_supplicant


## ,-----
## |	Extract
## +-----

${NTI_WPA_SUPPLICANT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/wpa_supplicant-${WPA_SUPPLICANT_VERSION} ] || rm -rf ${EXTTEMP}/wpa_supplicant-${WPA_SUPPLICANT_VERSION}
	zcat ${WPA_SUPPLICANT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP}
	mv ${EXTTEMP}/wpa_supplicant-${WPA_SUPPLICANT_VERSION} ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_WPA_SUPPLICANT_CONFIGURED}: ${NTI_WPA_SUPPLICANT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP} || exit 1 ;\
		[ -r wpa_supplicant/Makefile.OLD ] || mv wpa_supplicant/Makefile wpa_supplicant/Makefile.OLD || exit 1 ;\
		cat wpa_supplicant/Makefile.OLD \
			| sed '/^ifndef CC/,/endif/	{ s/^\([ie]\)/#&/ ; s%g*cc%'${NTI_GCC}'% } ' \
			| sed '/^PKG_CONFIG/	s%pkg-config%'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config%' \
			| sed '/^export/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^LIBS/		s%-lcrypto%-L'${NTI_TC_ROOT}'/usr/lib -lcrypto%' \
			> wpa_supplicant/Makefile ;\
		cat wpa_supplicant/defconfig \
			| sed '/openssl.include/	{ s/^#// ; s%/usr/local/openssl/include%'${NTI_TC_ROOT}'/usr/include% }' \
			| sed '/openssl.lib/		{ s/^#// ; s%/usr/local/openssl/lib%'${NTI_TC_ROOT}'/usr/lib% }' \
			| sed '/CFLAGS.*libnl/		{ s/^#// ; s%-I.*%-I'${NTI_TC_ROOT}'/usr/include/libnl3% }' \
			| sed '/LIBS.*libnl/		{ s/^#// ; s%-L.*%-I'${NTI_TC_ROOT}'/usr/lib% }' \
			| sed '/CONFIG_LIBNL32/		s/^#// ' \
			> wpa_supplicant/.config \
	)
#		| sed '/CONFIG_TLS/		s/^#// ' \
#		| sed '/CONFIG_TLSV11/		s/^#// ' \
#		| sed '/CONFIG_TLSV12/		s/^#// ' \
#		| sed '/CONFIG_EAP_PWD/		s/^#// ' \
#		| sed '/CONFIG_EAP_FAST/	s/^#// ' \


## ,-----
## |	Build
## +-----

${NTI_WPA_SUPPLICANT_BUILT}: ${NTI_WPA_SUPPLICANT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP} || exit 1 ;\
		make -C wpa_supplicant \
	)


## ,-----
## |	Install
## +-----

${NTI_WPA_SUPPLICANT_INSTALLED}: ${NTI_WPA_SUPPLICANT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WPA_SUPPLICANT_TEMP} || exit 1 ;\
		make -C wpa_supplicant install \
	)

##

.PHONY: nti-wpa_supplicant
nti-wpa_supplicant: nti-pkg-config \
		nti-libnl nti-openssl ${NTI_WPA_SUPPLICANT_INSTALLED}

ALL_NTI_TARGETS+= nti-wpa_supplicant

endif	# HAVE_WPA_SUPPLICANT_CONFIG
