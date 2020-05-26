# ms-sys v2.5.3			[ since v2.0.0, c.2004-06-07 ]
# last mod WmT, 2016-03-09	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_MS_SYS_CONFIG},y)
HAVE_MS_SYS_CONFIG:=y

#DESCRLIST+= "'nti-ms-sys' -- ms-sys"
#DESCRLIST+= "'cti-ms-sys' -- ms-sys"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${MS_SYS_VERSION},)
#MS_SYS_VERSION=2.4.0
#MS_SYS_VERSION=2.4.1
#MS_SYS_VERSION=2.5.2
MS_SYS_VERSION=2.5.3
endif

MS_SYS_SRC=${SOURCES}/m/ms-sys-${MS_SYS_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/ms-sys/ms-sys%20stable/2.4.0/ms-sys-2.4.0.tar.gz?use_mirror=garr
URLS+= http://prdownloads.sourceforge.net/ms-sys/ms-sys-${MS_SYS_VERSION}.tar.gz

NTI_MS_SYS_TEMP=nti-ms-sys-${MS_SYS_VERSION}

NTI_MS_SYS_EXTRACTED=${EXTTEMP}/${NTI_MS_SYS_TEMP}/COPYING
NTI_MS_SYS_CONFIGURED=${EXTTEMP}/${NTI_MS_SYS_TEMP}/Makefile
NTI_MS_SYS_BUILT=${EXTTEMP}/${NTI_MS_SYS_TEMP}/bin/ms-sys
NTI_MS_SYS_INSTALLED=${NTI_TC_ROOT}/usr/bin/ms-sys


## ,-----
## |	Extract
## +-----

${NTI_MS_SYS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ms-sys-${MS_SYS_VERSION} ] || rm -rf ${EXTTEMP}/ms-sys-${MS_SYS_VERSION}
	zcat ${MS_SYS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MS_SYS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MS_SYS_TEMP}
	mv ${EXTTEMP}/ms-sys-${MS_SYS_VERSION} ${EXTTEMP}/${NTI_MS_SYS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MS_SYS_CONFIGURED}: ${NTI_MS_SYS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MS_SYS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s/?//' \
			| sed '/^EXTRA_/	s/^/#/' \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^all/		s%$$(MO_FILES)%%' \
			| sed '/^install/	s%$$(NLS_FILES)%%' \
			| sed '/(MO_FILES)/,/^$$/ s/^/#/' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MS_SYS_BUILT}: ${NTI_MS_SYS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MS_SYS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

# NB. pre-2.1.4, may need LDFLAGS to contain "-lintl" (gettext)

${NTI_MS_SYS_INSTALLED}: ${NTI_MS_SYS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MS_SYS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-ms-sys
nti-ms-sys: ${NTI_MS_SYS_INSTALLED}

ALL_NTI_TARGETS+= nti-ms-sys

endif	# HAVE_MS_SYS_CONFIG
