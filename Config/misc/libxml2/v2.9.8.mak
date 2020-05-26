# libxml2 v2.9.8		[ earliest v2.9.8, v.2018-03-14 ]
# last mod WmT, 2018-03-14	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXML2_CONFIG},y)
HAVE_LIBXML2_CONFIG:=y

DESCRLIST+= "'nti-libxml2' -- libxml2"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak
#include ${CFG_ROOT}/tools/xz-utils/v5.2.3.mak

ifeq (${LIBXML2_VERSION},)
LIBXML2_VERSION= 2.9.8
endif

LIBXML2_SRC= ${SOURCES}/l/libxml2-${LIBXML2_VERSION}.tar.gz
URLS+= http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

# Dependencies?
#include ${CFG_ROOT}/misc/zlib/v1.2.11.mak


NTI_LIBXML2_TEMP=nti-libxml2-${LIBXML2_VERSION}

NTI_LIBXML2_EXTRACTED=${EXTTEMP}/${NTI_LIBXML2_TEMP}/configure
NTI_LIBXML2_CONFIGURED=${EXTTEMP}/${NTI_LIBXML2_TEMP}/config.log
NTI_LIBXML2_BUILT=${EXTTEMP}/${NTI_LIBXML2_TEMP}/.libs/libxml2.la
NTI_LIBXML2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libxml-2.0.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXML2_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxml2-${LIBXML2_VERSION} ] || rm -rf ${EXTTEMP}/libxml2-${LIBXML2_VERSION}
	zcat ${LIBXML2_SRC} | tar xvf - -C ${EXTTEMP}
	#bzcat ${LIBXML2_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${LIBXML2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXML2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXML2_TEMP}
	mv ${EXTTEMP}/libxml2-${LIBXML2_VERSION} ${EXTTEMP}/${NTI_LIBXML2_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXML2_CONFIGURED}: ${NTI_LIBXML2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXML2_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --without-python \
			  || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXML2_BUILT}: ${NTI_LIBXML2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXML2_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXML2_INSTALLED}: ${NTI_LIBXML2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXML2_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-libxml2
nti-libxml2: \
	${NTI_LIBXML2_INSTALLED}

ALL_NTI_TARGETS+= nti-libxml2

endif	# HAVE_LIBXML2_CONFIG
