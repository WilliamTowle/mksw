# gpm v1.99.7			[ since v?.?, c.????-??-?? ]
# last mod WmT, 2017-03-28	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_GPM_CONFIG},y)
HAVE_GPM_CONFIG:=y

#DESCRLIST+= "'nti-gpm' -- gpm"

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${GPM_VERSION},)
#GPM_VERSION=1.20.7
GPM_VERSION=1.99.6
#GPM_VERSION=1.99.7
endif

GPM_SRC=${SOURCES}/g/gpm-${GPM_VERSION}.tar.bz2
URLS+= http://www.nico.schottelius.org/software/gpm/archives/gpm-${GPM_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/autoconf/v2.65.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/bison/v2.4.1.mak
##include ${CFG_ROOT}/buildtools/bison/v2.5.1.mak
#include ${CFG_ROOT}/buildtools/shtool/v2.0.8.mak

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
## [v1.99.7] needs -D_GNU_SOURCE to fix "storage size of 'sucred' isn't known"

${NTI_GPM_CONFIGURED}: ${NTI_GPM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPM_TEMP} || exit 1 ;\
		case ${GPM_VERSION} in \
		1.99.7) \
			[ -r doc/Makefile.in.OLD ] || mv doc/Makefile.in doc/Makefile.in.OLD || exit 1 ;\
			cat doc/Makefile.in.OLD \
				| sed '/^	/	s/$$(MKDIR)/$$(MKDIR_P)/' \
				> doc/Makefile.in \
		;; \
		esac ;\
		[ -r Makefile.include.in.OLD ] || mv Makefile.include.in Makefile.include.in.OLD || exit 1 ;\
		case ${GPM_VERSION} in \
		1.99.6) \
			cat Makefile.include.in.OLD \
				| sed '/^CFLAGS/	{ s/-Wall// ; s/-Wextra// ; s/-Werror// }' \
				| sed '/^RM/	s%$$%\nMKDIR = /bin/mkdir -p%' \
				> Makefile.include.in ;\
		;; \
		1.99.7) \
			cat Makefile.include.in.OLD \
				| sed '/^CFLAGS/	{ s/-Wall// ; s/-Wextra// ; s/-Werror// }' \
				> Makefile.include.in ;\
		;; \
		esac ;\
		[ -r src/daemon/open_console.c.OLD ] || mv src/daemon/open_console.c src/daemon/open_console.c.OLD || exit 1 ;\
		cat src/daemon/open_console.c.OLD \
			| sed '/Linux specific/			s%$$%\n#include <linux/kdev_t.h>\n%' \
			| sed '/^int open_console/,/^}$$/	s/major(/MAJOR(/' \
			> src/daemon/open_console.c ;\
		CFLAGS='-O2 -D_GNU_SOURCE' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--sysconfdir=${NTI_TC_ROOT}/etc \
			|| exit 1 \
	)

#	( cd ${EXTTEMP}/${NTI_GPM_TEMP} || exit 1 ;\
#		[ -r autogen.sh.OLD ] || mv autogen.sh autogen.sh.OLD || exit 1 ;\
#		cat autogen.sh.OLD \
#			| sed 's/$${LIBTOOLIZE-[a-z]*}/'${HOSTSPEC}'-libtoolize/' \
#			> autogen.sh ;\
#		chmod a+x autogen.sh ;\
#		./autogen.sh || exit 1 ;\
#		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
#		cat configure.OLD \
#			| sed '/ac_dir in config/ s%;% '${NTI_TC_ROOT}'/usr/share/automake-1.14 ; %' \
#			> configure ;\
#		chmod a+x configure ;\
#		CFLAGS='-O2' \
#		LIBTOOL=${HOSTSPEC}-libtool \
#		  ./configure \
#			--prefix=${NTI_TC_ROOT}/usr \
#			--sysconfdir=${NTI_TC_ROOT}/etc \
#			--without-curses \
#			|| exit 1 ;\
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
#		cat Makefile.OLD \
#			| sed '/SUBDIRS/	s/ doc / /' \
#			> Makefile \
#	)


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
#nti-gpm: nti-autoconf nti-automake nti-bison nti-libtool nti-shtool \
#	${NTI_GPM_INSTALLED}
nti-gpm: ${NTI_GPM_INSTALLED}

ALL_NTI_TARGETS+= nti-gpm

endif	# HAVE_GPM_CONFIG
