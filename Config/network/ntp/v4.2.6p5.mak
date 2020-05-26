# ntp v4.2.6p5			[ since v4.2.6p5, c.2003-08-13 ]
# last mod WmT, 2013-08-15	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_NTP_CONFIG},y)
HAVE_NTP_CONFIG:=y

#DESCRLIST+= "'nti-ntp' -- ntp"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${NTP_VERSION},)
NTP_VERSION= 4.2.6p5
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

NTP_SRC=${SOURCES}/n/ntp-${NTP_VERSION}.tar.gz
NTP_PATCHES=${SOURCES}/n/ntp-4.2.4_p5-adjtimex.patch

URLS+= http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.6p5.tar.gz
URLS+= http://sources.gentoo.org/net-misc/ntp/files/ntp-4.2.4_p5-adjtimex.patch

NTI_NTP_TEMP=nti-ntp-${NTP_VERSION}

NTI_NTP_EXTRACTED=${EXTTEMP}/${NTI_NTP_TEMP}/configure
NTI_NTP_CONFIGURED=${EXTTEMP}/${NTI_NTP_TEMP}/config.log
NTI_NTP_BUILT=${EXTTEMP}/${NTI_NTP_TEMP}/ntpd/ntpd
NTI_NTP_INSTALLED=${NTI_TC_ROOT}/usr/sbin/ntpd


## ,-----
## |	Extract
## +-----

${NTI_NTP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/ntp-${NTP_VERSION} ] || rm -rf ${EXTTEMP}/ntp-${NTP_VERSION}
	zcat ${NTP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NTP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NTP_TEMP}
	mv ${EXTTEMP}/ntp-${NTP_VERSION} ${EXTTEMP}/${NTI_NTP_TEMP}
ifneq (${NTP_PATCHES},)
	for PF in ${NTP_PATCHES} ; do \
		echo "*** PATCHING -- $${PF} ***" ;\
		grep '+++' $${PF} ;\
		patch --batch -d ${EXTTEMP}/${NTI_NTP_TEMP} -Np1 < $${PF} ;\
	done
endif


## ,-----
## |	Configure
## +-----

${NTI_NTP_CONFIGURED}: ${NTI_NTP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NTP_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--sysconfdir=/etc --with-binsubdir=sbin \
			--disable-ipv6 \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_NTP_BUILT}: ${NTI_NTP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NTP_TEMP} || exit 1 ;\
		make all LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_NTP_INSTALLED}: ${NTI_NTP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NTP_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)


##

.PHONY: nti-ntp
nti-ntp: nti-libtool ${NTI_NTP_INSTALLED}

ALL_NTI_TARGETS+= nti-ntp

endif	# HAVE_NTP_CONFIG
