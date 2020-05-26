# libxkbcommon v20151026	[ since v20151026, 2015-10-26 ]
# last mod WmT, 2015-10-26	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_LIBXKBCOMMON_CONFIG},y)
HAVE_LIBXKBCOMMON_CONFIG:=y

DESCRLIST+= "'nti-libxkbcommon' -- libxkbcommon"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

LIBXKBCOMMON_VERSION=20151026
LIBXKBCOMMON_SRC=${SOURCES}/l/libxkbcommon-master.zip
URLS+= http://SERVER/PATH/src/l/libxkbcommon-master.zip

##include ${CFG_ROOT}/gui/mesalib/v9.2.0.mak
#include ${CFG_ROOT}/audvid/gpu-viv-bin/vmx6q-3.10.17-1.0.2.mak
include ${CFG_ROOT}/gui/util-macros/v1.17.1.mak

NTI_LIBXKBCOMMON_TEMP=nti-libxkbcommon-${LIBXKBCOMMON_VERSION}

NTI_LIBXKBCOMMON_EXTRACTED=${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}/configure.ac
NTI_LIBXKBCOMMON_CONFIGURED=${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}/config.log
NTI_LIBXKBCOMMON_BUILT=${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}/.libs/libxkbcommon.a
NTI_LIBXKBCOMMON_INSTALLED=${NTI_TC_ROOT}/usr/lib/libxkbcommon.a



## ,-----
## |	Extract
## +-----

${NTI_LIBXKBCOMMON_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/libxkbcommon-${LIBXKBCOMMON_VERSION} ] || rm -rf ${EXTTEMP}/libxkbcommon-${LIBXKBCOMMON_VERSION}
	[ ! -d ${EXTTEMP}/libxkbcommon-master ] || rm -rf ${EXTTEMP}/libxkbcommon-master
	#bzcat ${LIBXKBCOMMON_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${LIBXKBCOMMON_SRC} -d ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}
	#mv ${EXTTEMP}/libxkbcommon-${LIBXKBCOMMON_VERSION} ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}
	mv ${EXTTEMP}/libxkbcommon-master ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXKBCOMMON_CONFIGURED}: ${NTI_LIBXKBCOMMON_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP} || exit 1 ;\
		ACLOCAL='aclocal -I'${NTI_TC_ROOT}'/usr/share/aclocal' \
		  autoreconf -fi || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr/ \
			  --disable-x11 \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXKBCOMMON_BUILT}: ${NTI_LIBXKBCOMMON_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXKBCOMMON_INSTALLED}: ${NTI_LIBXKBCOMMON_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBCOMMON_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libxkbcommon
nti-libxkbcommon: \
	nti-pkg-config \
	\
	nti-util-macros \
	\
	${NTI_LIBXKBCOMMON_INSTALLED}

ALL_NTI_TARGETS+= nti-libxkbcommon

endif	# HAVE_LIBXKBCOMMON_CONFIG
