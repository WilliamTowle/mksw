# python v3.4.0			[ since v3.3.4, c.2013-05-27 ]
# last mod WmT, 2014-03-19	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_PYTHON3_CONFIG},y)
HAVE_PYTHON3_CONFIG:=y

#DESCRLIST+= "'nti-python3' -- python 3"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PYTHON3_VERSION},)
#PYTHON3_VERSION=3.3.4
PYTHON3_VERSION=3.4.0
endif

PYTHON3_SRC=${SOURCES}/p/Python-${PYTHON3_VERSION}.tgz
URLS+= http://legacy.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_PYTHON3_TEMP=nti-python3-${PYTHON3_VERSION}

NTI_PYTHON3_EXTRACTED=${EXTTEMP}/${NTI_PYTHON3_TEMP}/configure
NTI_PYTHON3_CONFIGURED=${EXTTEMP}/${NTI_PYTHON3_TEMP}/Makefile.OLD
NTI_PYTHON3_BUILT=${EXTTEMP}/${NTI_PYTHON3_TEMP}/python
#NTI_PYTHON3_INSTALLED=${NTI_TC_ROOT}/usr/bin/python3
NTI_PYTHON3_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/python3.pc

## ,-----
## |	Extract
## +-----

${NTI_PYTHON3_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/python-${PYTHON3_VERSION} ] || rm -rf ${EXTTEMP}/python-${PYTHON3_VERSION}
	zcat ${PYTHON3_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PYTHON3_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PYTHON3_TEMP}
	mv ${EXTTEMP}/Python-${PYTHON3_VERSION} ${EXTTEMP}/${NTI_PYTHON3_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PYTHON3_CONFIGURED}: ${NTI_PYTHON3_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON3_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/^CPPFLAGS=/ s% -I/usr/include/[^ "]*%%' \
			> configure ;\
		chmod a+x configure ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-ipv6 \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^LIBPC/	s%$$(LIBDIR)%'${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_PYTHON3_BUILT}: ${NTI_PYTHON3_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON3_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PYTHON3_INSTALLED}: ${NTI_PYTHON3_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON3_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-python3
nti-python3: nti-pkg-config nti-libtool ${NTI_PYTHON3_INSTALLED}

ALL_NTI_TARGETS+= nti-python3

endif	# HAVE_PYTHON3_CONFIG
