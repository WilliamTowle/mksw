# openssh v7.2p1		[ since v3.6.1p2, c.2003-06-05 ]
# last mod WmT, 2016-03-09	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_OPENSSH_CONFIG},y)
HAVE_OPENSSH_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

DESCRLIST+= "'nti-openssh' -- openssh"

ifeq (${OPENSSH_VERSION},)
#OPENSSH_VERSION=6.2p2
#OPENSSH_VERSION=6.4p1
#OPENSSH_VERSION=6.6p1
#OPENSSH_VERSION=6.7p1
#OPENSSH_VERSION=6.8p1
#OPENSSH_VERSION=6.9p1
#OPENSSH_VERSION=7.1p1
OPENSSH_VERSION=7.2p1
endif

OPENSSH_SRC=${SOURCES}/o/openssh-${OPENSSH_VERSION}.tar.gz
URLS+=http://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/network/openssl/v1.0.2d.mak
include ${CFG_ROOT}/network/openssl/v1.0.2g.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

ifneq (${OPENSSH_WITH_X11},false)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
endif

NTI_OPENSSH_TEMP=nti-openssh-${OPENSSH_VERSION}

NTI_OPENSSH_EXTRACTED=${EXTTEMP}/${NTI_OPENSSH_TEMP}/Makefile
NTI_OPENSSH_CONFIGURED=${EXTTEMP}/${NTI_OPENSSH_TEMP}/config.status
NTI_OPENSSH_BUILT=${EXTTEMP}/${NTI_OPENSSH_TEMP}/sftp
NTI_OPENSSH_INSTALLED=${NTI_TC_ROOT}/usr/bin/sftp

#CUI_OPENSSH_INSTTEMP=${EXTTEMP}/insttemp


## ,-----
## |	package extract
## +-----


.PHONY: nti-openssh-extracted
nti-openssh-extracted: ${NTI_OPENSSH_EXTRACTED}

${NTI_OPENSSH_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/openssh-${OPENSSH_VERSION} ] || rm -rf ${EXTTEMP}/openssh-${OPENSSH_VERSION}
	zcat ${OPENSSH_SRC} | tar xvf - -C ${EXTTEMP}
#	bzcat ${OPENSSH_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPENSSH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENSSH_TEMP}
	mv ${EXTTEMP}/openssh-${OPENSSH_VERSION} ${EXTTEMP}/${NTI_OPENSSH_TEMP}


## ,-----
## |	package configure
## +-----


.PHONY: nti-openssh-configured
nti-openssh-configured: nti-openssh-extracted ${NTI_OPENSSH_CONFIGURED}

ifneq (${OPENSSH_WITH_X11},false)
OPENSSH_CONFIGURE_ARGS:= \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib
else
#OPENSSH_CONFIGURE_ARGS:= \
#			--without-x
endif

## [v6.6p1] force rpath in LDFLAGS to fix openssl header version test

${NTI_OPENSSH_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  PKGCONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --with-cflags='' --with-cppflags='' --with-ldflags='-Wl,-rpath,'${NTI_TC_ROOT}'/usr/lib' --without-rpath \
			  --disable-lastlog \
			  --disable-utmp --disable-utmpx \
			  --disable-wtmp --disable-wtmpx \
			  --disable-strip \
			  --with-privsep-path=${NTI_TC_ROOT}/var/empty \
			  --with-zlib=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix zlib ` \
			  --with-ssl-dir=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix openssl ` \
			  ${OPENSSH_CONFIGURE_ARGS} \
			  || exit 1 \
	)


## ,-----
## |	package build
## +-----


.PHONY: nti-openssh-built
nti-openssh-built: nti-openssh-configured ${NTI_OPENSSH_BUILT}

${NTI_OPENSSH_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	package install
## +-----


.PHONY: nti-openssh-installed
nti-openssh-installed: nti-openssh-built ${NTI_OPENSSH_INSTALLED}

${NTI_OPENSSH_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		make install || exit 1 \
	)


.PHONY: nti-openssh
ifneq (${OPENSSH_WITH_X11},false)
nti-openssh: nti-pkg-config nti-zlib nti-openssl nti-libX11 nti-openssh-installed
else
nti-openssh: nti-pkg-config nti-zlib nti-openssl nti-openssh-installed
endif

ALL_NTI_TARGETS+= nti-openssh

endif	# HAVE_OPENSSH_CONFIG
