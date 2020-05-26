# ccrypt v1.9 	   	   	[ since v1.9, c.2011-08-18 ]
# last mod WmT, 2017-04-11	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_CCRYPT},y)
HAVE_CCRYPT:=y

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak

ifeq (${CCRYPT_VERSION},)
CCRYPT_VERSION=1.9
endif

#CCRYPT_SRC=${SOURCES}/c/ccrypt-${CCRYPT_VERSION}.tar.gz
CCRYPT_SRC=${SOURCES}/c/ccrypt_${CCRYPT_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/c/ccrypt/ccrypt_${CCRYPT_VERSION}.orig.tar.gz

# deps?
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_CCRYPT_TEMP=nti-ccrypt-${CCRYPT_VERSION}

NTI_CCRYPT_EXTRACTED=${EXTTEMP}/${NTI_CCRYPT_TEMP}/configure
NTI_CCRYPT_CONFIGURED=${EXTTEMP}/${NTI_CCRYPT_TEMP}/Makefile
NTI_CCRYPT_BUILT=${EXTTEMP}/${NTI_CCRYPT_TEMP}/src/ccrypt
NTI_CCRYPT_INSTALLED=${NTI_TC_ROOT}/usr/bin/ccrypt


## ,-----
## |	Extract
## +-----

${NTI_CCRYPT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/ccrypt-${CCRYPT_VERSION} ] || rm -rf ${EXTTEMP}/ccrypt-${CCRYPT_VERSION}
	zcat ${CCRYPT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CCRYPT_TEMP}
	mv ${EXTTEMP}/ccrypt-${CCRYPT_VERSION} ${EXTTEMP}/${NTI_CCRYPT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CCRYPT_CONFIGURED}: ${NTI_CCRYPT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_CCRYPT_BUILT}: ${NTI_CCRYPT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CCRYPT_INSTALLED}: ${NTI_CCRYPT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		make install \
	)


.PHONY: nti-ccrypt
#nti-ccrypt: nti-pkg-config ${NTI_CCRYPT_INSTALLED}
nti-ccrypt: ${NTI_CCRYPT_INSTALLED}

ALL_NTI_TARGETS+= nti-ccrypt

endif	# HAVE_CCRYPT_CONFIG
