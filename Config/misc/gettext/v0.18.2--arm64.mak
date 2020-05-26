# gettext v0.18.2		[ earliest v0.18.2, ????-??-?? ]
# last mod WmT, 2016-06-06	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_GETTEXT_CONFIG},y)
HAVE_GETTEXT_CONFIG:=y

#DESCRLIST+= "'nti-gettext' -- gettext"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GETTEXT_VERSION},)
GETTEXT_VERSION=0.18.2
endif

GETTEXT_SRC=${SOURCES}/g/gettext-${GETTEXT_VERSION}.tar.gz
URLS+= http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.2.tar.gz

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/buildtools/libtool/v2.4.6--arm64.mak
#include ${CFG_ROOT}/misc/libiconv/v1.14--arm64.mak

NTI_GETTEXT_TEMP=nti-gettext-${GETTEXT_VERSION}

NTI_GETTEXT_EXTRACTED=${EXTTEMP}/${NTI_GETTEXT_TEMP}/README
NTI_GETTEXT_CONFIGURED=${EXTTEMP}/${NTI_GETTEXT_TEMP}/config.status
NTI_GETTEXT_BUILT=${EXTTEMP}/${NTI_GETTEXT_TEMP}/gettext-runtime/src/gettext.sh
NTI_GETTEXT_INSTALLED=${NTI_TC_ROOT}/usr/lib/libgettextlib.so


## ,-----
## |	Extract
## +-----

${NTI_GETTEXT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/gettext-${GETTEXT_VERSION} ] || rm -rf ${EXTTEMP}/gettext-${GETTEXT_VERSION}
	zcat ${GETTEXT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GETTEXT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GETTEXT_TEMP}
	mv ${EXTTEMP}/gettext-${GETTEXT_VERSION} ${EXTTEMP}/${NTI_GETTEXT_TEMP}


## ,-----
## |	Configure
## +-----

## 2013-04-25: trying --disable-c++

${NTI_GETTEXT_CONFIGURED}: ${NTI_GETTEXT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GETTEXT_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		  CXX=no \
		    CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--disable-libasprintf \
				--disable-java \
				--disable-c++ \
				--disable-csharp \
				--without-emacs \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_GETTEXT_BUILT}: ${NTI_GETTEXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GETTEXT_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_GETTEXT_INSTALLED}: ${NTI_GETTEXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GETTEXT_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-gettext
nti-gettext: nti-libtool ${NTI_GETTEXT_INSTALLED}
#nti-gettext: nti-libtool nti-libiconv ${NTI_GETTEXT_INSTALLED}

ALL_NTI_TARGETS+= nti-gettext

endif	# HAVE_GETTEXT_CONFIG
