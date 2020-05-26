# linux_logo v5.11		[ since v?.??, c.????-??-?? ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LINUX_LOGO_CONFIG},y)
HAVE_LINUX_LOGO_CONFIG:=y

#DESCRLIST+= "'nti-linux_logo' -- linux_logo"
#DESCRLIST+= "'cti-linux_logo' -- linux_logo"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LINUX_LOGO_VERSION},)
#LINUX_LOGO_VERSION=5.0
LINUX_LOGO_VERSION=5.11
endif

#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

LINUX_LOGO_SRC=${SOURCES}/l/linux_logo-${LINUX_LOGO_VERSION}.tar.gz
URLS+= http://www.deater.net/weave/vmwprod/linux_logo/linux_logo-5.11.tar.gz
# Older: at http://metalab.unc.edu/pub/Linux/logos/penguins/

NTI_LINUX_LOGO_TEMP=nti-linux_logo-${LINUX_LOGO_VERSION}

NTI_LINUX_LOGO_EXTRACTED=${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}/configure
NTI_LINUX_LOGO_CONFIGURED=${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}/logo_config
NTI_LINUX_LOGO_BUILT=${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}/linux_logo
NTI_LINUX_LOGO_INSTALLED=${NTI_TC_ROOT}/usr/bin/linux_logo


## ,-----
## |	Extract
## +-----

${NTI_LINUX_LOGO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION} ] || rm -rf ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION}
	zcat ${LINUX_LOGO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}
	mv ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION} ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}


## ,-----
## |	Configure
## +-----

## [v5.11] Use of the 'po' subdirs requires 'msgfmt' ('gettext' package)

${NTI_LINUX_LOGO_CONFIGURED}: ${NTI_LINUX_LOGO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/cd po && /	{ s%^%ifneq ($${XGETTEXT},)\n% ; s%$$%\nendif% }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LINUX_LOGO_BUILT}: ${NTI_LINUX_LOGO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
		make || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_LINUX_LOGO_INSTALLED}: ${NTI_LINUX_LOGO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-linux_logo
nti-linux_logo: nti-ncurses ${NTI_LINUX_LOGO_INSTALLED}

ALL_NTI_TARGETS+= nti-linux_logo

endif	# HAVE_LINUX_LOGO_CONFIG
