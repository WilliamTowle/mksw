# dpkg v1.18.24			[ since v1.18.24, c.2017-08-25 ]
# last mod WmT, 2017-08-30	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DPKG_CONFIG},y)
HAVE_DPKG_CONFIG:=y

#DESCRLIST+= "'nti-dpkg' -- dpkg"

include ${CFG_ROOT}/ENV/buildtype.mak

# autotools?
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak
# unzip? xzcat? 

ifeq (${DPKG_VERSION},)
DPKG_VERSION=1.18.24
endif

DPKG_SRC=${SOURCES}/d/dpkg_1.18.24.tar.xz
URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.18.24.tar.xz

include ${CFG_ROOT}/tui/ncurses/v6.0.mak
include ${CFG_ROOT}/base/patch/v2.7.1.mak

NTI_DPKG_TEMP=nti-dpkg-${DPKG_VERSION}

NTI_DPKG_EXTRACTED=${EXTTEMP}/${NTI_DPKG_TEMP}/README
NTI_DPKG_CONFIGURED=${EXTTEMP}/${NTI_DPKG_TEMP}/config.status
NTI_DPKG_BUILT=${EXTTEMP}/${NTI_DPKG_TEMP}/src/dpkg
NTI_DPKG_INSTALLED=${NTI_TC_ROOT}/usr/bin/dpkg


DPKG_DEB_HOST_TOOL= ${NTI_TC_ROOT}/usr/bin/dpkg-deb


## ,-----
## |	Extract
## +-----

${NTI_DPKG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/dpkg-${DPKG_VERSION} ] || rm -rf ${EXTTEMP}/dpkg-${DPKG_VERSION}
	#bzcat ${DPKG_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${DPKG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DPKG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DPKG_TEMP}
	mv ${EXTTEMP}/dpkg-${DPKG_VERSION} ${EXTTEMP}/${NTI_DPKG_TEMP}


## ,-----
## |	Configure
## +-----

## CPPFLAGS because CXX and GEN phases need 'ncurses' headers

${NTI_DPKG_CONFIGURED}: ${NTI_DPKG_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DPKG_TEMP} || exit 1 ;\
		CFLAGS='-O2 '"` ${NCURSES_CONFIG_TOOL} --cflags `" \
		CPPFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS="` ${NCURSES_CONFIG_TOOL} --libs `" \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DPKG_BUILT}: ${NTI_DPKG_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DPKG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DPKG_INSTALLED}: ${NTI_DPKG_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DPKG_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-dpkg
nti-dpkg: \
	nti-ncurses \
	nti-patch \
	${NTI_DPKG_INSTALLED}

ALL_NTI_TARGETS+= nti-dpkg

endif	# HAVE_DPKG_CONFIG
