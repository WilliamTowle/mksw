# glib v2.50.3			[ earliest v2.26.1, c.2011-09-08 ]
# last mod WmT, 2017-03-29	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_GLIB_CONFIG},y)
HAVE_GLIB_CONFIG:=y

DESCRLIST+= "'cti-glib' -- glib"
DESCRLIST+= "'nti-glib' -- glib"

include ${CFG_ROOT}/ENV/buildtype.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak

ifeq (${GLIB_VERSION},)
#GLIB_VERSION= 2.26.1
#GLIB_VERSION= 2.28.8
#GLIB_VERSION= 2.30.0
#GLIB_VERSION= 2.40.0
#GLIB_VERSION= 2.46.1
#GLIB_VERSION= 2.49.1
GLIB_VERSION= 2.50.3
#GLIB_VERSION= 2.51.5
#GLIB_VERSION= 2.52.0
endif

#GLIB_SRC= ${SOURCES}/g/glib-${GLIB_VERSION}.tar.bz2
GLIB_SRC= ${SOURCES}/g/glib-${GLIB_VERSION}.tar.xz
#URLS+= http://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-${GLIB_VERSION}.tar.xz
URLS+= http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-${GLIB_VERSION}.tar.xz

include ${CFG_ROOT}/misc/gettext/v0.19.8.mak
include ${CFG_ROOT}/misc/libiconv/v1.14.mak
include ${CFG_ROOT}/misc/libffi/v3.2.1.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

CTI_GLIB_TEMP=cti-glib-${GLIB_VERSION}

CTI_GLIB_EXTRACTED=${EXTTEMP}/${CTI_GLIB_TEMP}/glib-2.0.pc.in
CTI_GLIB_CONFIGURED=${EXTTEMP}/${CTI_GLIB_TEMP}/gio/Makefile.OLD
CTI_GLIB_BUILT=${EXTTEMP}/${CTI_GLIB_TEMP}/glib/.libs/libglib-2.0.la
CTI_GLIB_INSTALLED=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/glib-2.0.pc

NTI_GLIB_TEMP=nti-glib-${GLIB_VERSION}

NTI_GLIB_EXTRACTED=${EXTTEMP}/${NTI_GLIB_TEMP}/glib-2.0.pc.in
NTI_GLIB_CONFIGURED=${EXTTEMP}/${NTI_GLIB_TEMP}/gio/Makefile.OLD
NTI_GLIB_BUILT=${EXTTEMP}/${NTI_GLIB_TEMP}/glib/.libs/libglib-2.0.la
NTI_GLIB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/glib-2.0.pc


## ,-----
## |	Extract
## +-----

${CTI_GLIB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/glib-${GLIB_VERSION} ] || rm -rf ${EXTTEMP}/glib-${GLIB_VERSION}
	#bzcat ${GLIB_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${GLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_GLIB_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_GLIB_TEMP}
	mv ${EXTTEMP}/glib-${GLIB_VERSION} ${EXTTEMP}/${CTI_GLIB_TEMP}

##

${NTI_GLIB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/glib-${GLIB_VERSION} ] || rm -rf ${EXTTEMP}/glib-${GLIB_VERSION}
	#bzcat ${GLIB_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${GLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GLIB_TEMP}
	mv ${EXTTEMP}/glib-${GLIB_VERSION} ${EXTTEMP}/${NTI_GLIB_TEMP}



## ,-----
## |	Configure
## +-----

## no 'tests' -- v2.25.7 tries to run an alien binary
## CFLAGS and LDFLAGS passed as suits libiconv location
## '--with-pcre=internal' because Debian's lacks Unicode/UTF-8
## '--disable-libmount' ("linux default") for v2.50.x+

${NTI_GLIB_CONFIGURED}: ${NTI_GLIB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GLIB_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		  LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --with-libiconv=gnu \
			  --with-pcre=internal \
			  --disable-fam \
			  --disable-libmount \
			  --disable-xattr \
			  || exit 1 ;\
		[ -r gio/Makefile.OLD ] || mv gio/Makefile gio/Makefile.OLD || exit 1 ;\
		cat gio/Makefile.OLD \
			| sed '/DIST_SUBDIRS/,+2	s/tests//' \
			| sed '/SUBDIRS/,+2	s/tests//' \
			> gio/Makefile \
	)

##

## TARGCPU=arm expected

${CTI_GLIB_CONFIGURED}: ${CTI_GLIB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_GLIB_TEMP} || exit 1 ;\
		CC=${CUI_GCC} \
		  CFLAGS='-O2 -I'${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/include' \
		  LDFLAGS='-L'${CTI_TC_ROOT}'/usr/'${TARGSPEC}'/lib' \
		  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \
		  glib_cv_stack_grows=no \
		  glib_cv_uscore=no \
		  ac_cv_func_posix_getpwuid_r=no \
		  ac_cv_func_posix_getgrgid_r=no \
			./configure \
			  --prefix=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			  --with-libiconv=gnu \
			  --disable-fam \
			  --disable-xattr \
			  || exit 1 ;\
		[ -r gio/Makefile.OLD ] || mv gio/Makefile gio/Makefile.OLD || exit 1 ;\
		cat gio/Makefile.OLD \
			| sed '/DIST_SUBDIRS/,+2	s/tests//' \
			| sed '/SUBDIRS/,+2	s/tests//' \
			> gio/Makefile \
	)



## ,-----
## |	Build
## +-----

${CTI_GLIB_BUILT}: ${CTI_GLIB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_GLIB_TEMP} || exit 1 ;\
		make \
	)

##

${NTI_GLIB_BUILT}: ${NTI_GLIB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GLIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CTI_GLIB_INSTALLED}: ${CTI_GLIB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_GLIB_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: cti-glib
cti-glib: cti-pkg-config \
	cti-libffi cti-libiconv cti-zlib \
	${CTI_GLIB_INSTALLED}

ALL_CTI_TARGETS+= cti-glib

##

${NTI_GLIB_INSTALLED}: ${NTI_GLIB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GLIB_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-glib
nti-glib: nti-pkg-config \
	nti-gettext nti-libffi nti-libiconv nti-zlib \
	${NTI_GLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-glib

endif	# HAVE_GLIB_CONFIG
