# json-c v0.12.1		[ since v1.16, c.2016-06-23 ]
# last mod WmT, 2016-06-23	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_JSON_C_CONFIG},y)
HAVE_JSON_C_CONFIG:=y

#DESCRLIST+= "'nti-json-c' -- json-c"

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${JSON_C_VERSION},)
JSON_C_VERSION=0.12.1
endif

JSON_C_SRC=${SOURCES}/j/json-c-${JSON_C_VERSION}.tar.gz
URLS+= https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_JSON_C_TEMP=nti-json-c-${JSON_C_VERSION}

NTI_JSON_C_EXTRACTED=${EXTTEMP}/${NTI_JSON_C_TEMP}/README
NTI_JSON_C_CONFIGURED=${EXTTEMP}/${NTI_JSON_C_TEMP}/config.log
NTI_JSON_C_BUILT=${EXTTEMP}/${NTI_JSON_C_TEMP}/libjson-c.la
#NTI_JSON_C_INSTALLED=${NTI_TC_ROOT}/usr/lib/json-c.la
NTI_JSON_C_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/json-c.pc


## ,-----
## |	Extract
## +-----

${NTI_JSON_C_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/json-c-${JSON_C_VERSION} ] || rm -rf ${EXTTEMP}/json-c-${JSON_C_VERSION}
	#[ ! -d ${EXTTEMP}/json-c-${JSON_C_VERSION} ] || rm -rf ${EXTTEMP}/json-c-${JSON_C_VERSION}
	zcat ${JSON_C_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_JSON_C_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_JSON_C_TEMP}
	mv ${EXTTEMP}/json-c-${JSON_C_VERSION} ${EXTTEMP}/${NTI_JSON_C_TEMP}
	#mv ${EXTTEMP}/json-c-${JSON_C_VERSION} ${EXTTEMP}/${NTI_JSON_C_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_JSON_C_CONFIGURED}: ${NTI_JSON_C_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JSON_C_TEMP} || exit 1 ;\
		for MF in Makefile.in ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^pkgconfigdir/	s%$$(libdir)%$$(prefix)/'${HOSTSPEC}'/lib%' \
				> $${MF} ;\
		done ;\
		CFLAGS='-O2' \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)
#		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_JSON_C_BUILT}: ${NTI_JSON_C_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JSON_C_TEMP} || exit 1 ;\
		make \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_JSON_C_INSTALLED}: ${NTI_JSON_C_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JSON_C_TEMP} || exit 1 ;\
		make install \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-json-c
nti-json-c: ${NTI_JSON_C_INSTALLED}
#nti-json-c: nti-pkg-config \
#	${NTI_JSON_C_INSTALLED}

ALL_NTI_TARGETS+= nti-json-c

endif	# HAVE_JSON_C_CONFIG
