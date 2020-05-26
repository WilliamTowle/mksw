# gpm v1.20.7			[ since v?.?, c.????-??-?? ]
# last mod WmT, 2014-07-22	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_GPM_CONFIG},y)
HAVE_GPM_CONFIG:=y

#DESCRLIST+= "'nti-gpm' -- gpm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GPM_VERSION},)
GPM_VERSION=1.20.7
endif

GPM_SRC=${SOURCES}/g/gpm-1.20.7.tar.bz2
URLS+= http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

#include ${CFG_ROOT}/buildtools/autoconf/v2.65.mak
include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/buildtools/bison/v2.4.1.mak
#include ${CFG_ROOT}/buildtools/bison/v2.5.1.mak
include ${CFG_ROOT}/buildtools/shtool/v2.0.8.mak

NTI_GPM_TEMP=nti-gpm-${GPM_VERSION}

NTI_GPM_EXTRACTED=${EXTTEMP}/${NTI_GPM_TEMP}/README
NTI_GPM_CONFIGURED=${EXTTEMP}/${NTI_GPM_TEMP}/config.status
NTI_GPM_BUILT=${EXTTEMP}/${NTI_GPM_TEMP}/src/lib/libgpm.a
NTI_GPM_INSTALLED=${NTI_TC_ROOT}/usr/lib/libgpm.a



## ,-----
## |	Extract
## +-----

${NTI_GPM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/gpm-${GPM_VERSION} ] || rm -rf ${EXTTEMP}/gpm-${GPM_VERSION}
	bzcat ${GPM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GPM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GPM_TEMP}
	mv ${EXTTEMP}/gpm-${GPM_VERSION} ${EXTTEMP}/${NTI_GPM_TEMP}


## ,-----
## |	Configure
## +-----

## [v1.20.7] autogen.sh needs to find custom libtoolize (...et al?)
## [v1.20.7] problem with automake 2.68+, regarding AC_LANG_SOURCE
## [v1.20.7] '--without-curses' due to circular dependency issue
## [v1.20.7] poor tools detection for making documentation, therefore don't

${NTI_GPM_CONFIGURED}: ${NTI_GPM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPM_TEMP} || exit 1 ;\
		[ -r autogen.sh.OLD ] || mv autogen.sh autogen.sh.OLD || exit 1 ;\
		cat autogen.sh.OLD \
			| sed 's/$${LIBTOOLIZE-[a-z]*}/'${HOSTSPEC}'-libtoolize/' \
			> autogen.sh ;\
		chmod a+x autogen.sh ;\
		./autogen.sh || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/ac_dir in config/ s%;% '${NTI_TC_ROOT}'/usr/share/automake-1.14 ; %' \
			> configure ;\
		chmod a+x configure ;\
		CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--sysconfdir=${NTI_TC_ROOT}/etc \
			--without-curses \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/SUBDIRS/	s/ doc / /' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_GPM_BUILT}: ${NTI_GPM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPM_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_GPM_INSTALLED}: ${NTI_GPM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPM_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-gpm
nti-gpm: nti-autoconf nti-automake nti-bison nti-libtool nti-shtool \
	${NTI_GPM_INSTALLED}

ALL_NTI_TARGETS+= nti-gpm

endif	# HAVE_GPM_CONFIG
