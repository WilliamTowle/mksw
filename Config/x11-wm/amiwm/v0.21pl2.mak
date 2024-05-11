# amiwm v0.21pl2		[ since v0.21pl2, 2017-04-19 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_AMIWM_CONFIG},y)
HAVE_AMIWM_CONFIG:=y

DESCRLIST+= "'nti-amiwm' -- amiwm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${AMIWM_VERSION},)
AMIWM_VERSION=0.21pl2
endif

AMIWM_SRC=${SOURCES}/a/amiwm${AMIWM_VERSION}.tar.gz
URLS+= ftp://ftp.lysator.liu.se/pub/X11/wm/amiwm/amiwm0.21pl2.tar.gz

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak

NTI_AMIWM_TEMP=nti-amiwm-${AMIWM_VERSION}
NTI_AMIWM_EXTRACTED=${EXTTEMP}/${NTI_AMIWM_TEMP}/configure
NTI_AMIWM_CONFIGURED=${EXTTEMP}/${NTI_AMIWM_TEMP}/config.log
NTI_AMIWM_BUILT=${EXTTEMP}/${NTI_AMIWM_TEMP}/amiwm
NTI_AMIWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/amiwm


# ,-----
# |	Extract
# +-----

${NTI_AMIWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/amiwm-${AMIWM_VERSION} ] || rm -rf ${EXTTEMP}/amiwm-${AMIWM_VERSION}
	[ ! -d ${EXTTEMP}/amiwm${AMIWM_VERSION} ] || rm -rf ${EXTTEMP}/amiwm${AMIWM_VERSION}
	#bzcat ${AMIWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${AMIWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AMIWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AMIWM_TEMP}
	#mv ${EXTTEMP}/amiwm-${AMIWM_VERSION} ${EXTTEMP}/${NTI_AMIWM_TEMP}
	mv ${EXTTEMP}/amiwm${AMIWM_VERSION} ${EXTTEMP}/${NTI_AMIWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_AMIWM_CONFIGURED}: ${NTI_AMIWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKGCONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  --x-includes="` ${PKG_CONFIG_CONFIG_HOST_TOOL} --variable=prefix x11 `"'/include' \
			  --x-libraries="` ${PKG_CONFIG_CONFIG_HOST_TOOL} --variable=prefix x11 `"'/lib' \
				|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_AMIWM_BUILT}: ${NTI_AMIWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_AMIWM_INSTALLED}: ${NTI_AMIWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-amiwm
#nti-amiwm: nti-libX11 nti-libxcb \
#	${NTI_AMIWM_INSTALLED}
nti-amiwm: \
	nti-libX11 \
	${NTI_AMIWM_INSTALLED}

ALL_NTI_TARGETS+= nti-amiwm

endif	# HAVE_AMIWM_CONFIG
