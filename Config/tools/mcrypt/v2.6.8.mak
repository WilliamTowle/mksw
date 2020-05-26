# mcrypt v2.6.8 	      	[ since v2.6.8, c.2011-08-18 ]
# last mod WmT, 2017-04-11	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_MCRYPT},y)
HAVE_MCRYPT:=y

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak

ifeq (${MCRYPT_VERSION},)
MCRYPT_VERSION=2.6.8
endif

MCRYPT_SRC=${SOURCES}/m/mcrypt-${MCRYPT_VERSION}.tar.gz
#MCRYPT_SRC=${SOURCES}/m/mcrypt_${MCRYPT_VERSION}.orig.tar.gz
URLS+= https://sourceforge.net/projects/mcrypt/files/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz/download

include ${CFG_ROOT}/tools/libmcrypt/v2.5.8.mak

NTI_MCRYPT_TEMP=nti-mcrypt-${MCRYPT_VERSION}

NTI_MCRYPT_EXTRACTED=${EXTTEMP}/${NTI_MCRYPT_TEMP}/configure
NTI_MCRYPT_CONFIGURED=${EXTTEMP}/${NTI_MCRYPT_TEMP}/Makefile
NTI_MCRYPT_BUILT=${EXTTEMP}/${NTI_MCRYPT_TEMP}/src/mcrypt
NTI_MCRYPT_INSTALLED=${NTI_TC_ROOT}/usr/bin/mcrypt


## ,-----
## |	Extract
## +-----

${NTI_MCRYPT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/mcrypt-${MCRYPT_VERSION} ] || rm -rf ${EXTTEMP}/mcrypt-${MCRYPT_VERSION}
	zcat ${MCRYPT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MCRYPT_TEMP}
	mv ${EXTTEMP}/mcrypt-${MCRYPT_VERSION} ${EXTTEMP}/${NTI_MCRYPT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MCRYPT_CONFIGURED}: ${NTI_MCRYPT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  LIBMCRYPT_CFLAGS="`${NTI_LIBMCRYPT_CONFIG_TOOL} --cflags`" \
		  LIBMCRYPT_LIBS="`${NTI_LIBMCRYPT_CONFIG_TOOL} --libs`" \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-libmcrypt-prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MCRYPT_BUILT}: ${NTI_MCRYPT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		make \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_MCRYPT_INSTALLED}: ${NTI_MCRYPT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		make install \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
	)


.PHONY: nti-mcrypt
nti-mcrypt: nti-libtool \
	nti-libmcrypt ${NTI_MCRYPT_INSTALLED}

ALL_NTI_TARGETS+= nti-mcrypt

endif	# HAVE_MCRYPT_CONFIG
