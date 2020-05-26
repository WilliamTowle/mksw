# python v2.7.6			[ since v2.7.5, c.2013-05-27 ]
# last mod WmT, 2014-03-04	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_PYTHON2_CONFIG},y)
HAVE_PYTHON2_CONFIG:=y

#DESCRLIST+= "'nti-python2' -- python 2"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PYTHON2_VERSION},)
#PYTHON2_VERSION=2.7.5
PYTHON2_VERSION=2.7.6
endif

PYTHON2_SRC=${SOURCES}/p/Python-${PYTHON2_VERSION}.tgz
URLS+= http://www.python.org/ftp/python/${PYTHON2_VERSION}/Python-${PYTHON2_VERSION}.tgz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_PYTHON2_TEMP=nti-python2-${PYTHON2_VERSION}

NTI_PYTHON2_EXTRACTED=${EXTTEMP}/${NTI_PYTHON2_TEMP}/configure
NTI_PYTHON2_CONFIGURED=${EXTTEMP}/${NTI_PYTHON2_TEMP}/Makefile.OLD
NTI_PYTHON2_BUILT=${EXTTEMP}/${NTI_PYTHON2_TEMP}/python
#NTI_PYTHON2_INSTALLED=${NTI_TC_ROOT}/usr/bin/python
NTI_PYTHON2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/python2.pc

## ,-----
## |	Extract
## +-----

${NTI_PYTHON2_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/Python-${PYTHON2_VERSION} ] || rm -rf ${EXTTEMP}/Python-${PYTHON2_VERSION}
	zcat ${PYTHON2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PYTHON2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PYTHON2_TEMP}
	mv ${EXTTEMP}/Python-${PYTHON2_VERSION} ${EXTTEMP}/${NTI_PYTHON2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PYTHON2_CONFIGURED}: ${NTI_PYTHON2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON2_TEMP} || exit 1 ;\
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

${NTI_PYTHON2_BUILT}: ${NTI_PYTHON2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON2_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_PYTHON2_INSTALLED}: ${NTI_PYTHON2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON2_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)

##

.PHONY: nti-python2
nti-python2: nti-pkg-config nti-libtool ${NTI_PYTHON2_INSTALLED}

ALL_NTI_TARGETS+= nti-python2

endif	# HAVE_PYTHON2_CONFIG
