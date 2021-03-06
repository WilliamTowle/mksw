# intltool v0.37.1		[ since v0.37.1, 2013-04-14 ]
# last mod WmT, 2014-03-12	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_INTLTOOL_CONFIG},y)
HAVE_INTLTOOL_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-intltool' -- intltool"

ifeq (${INTLTOOL_VERSION},)
INTLTOOL_VERSION=0.37.1
endif
INTLTOOL_SRC=${SOURCES}/i/intltool_${INTLTOOL_VERSION}.orig.tar.gz

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/i/intltool/intltool_0.37.1.orig.tar.gz
URLS+= http://ftp.gnome.org/pub/gnome/sources/intltool/0.37/intltool-0.37.1.tar.bz2

#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak
include ${CFG_ROOT}/perl/XML-Parser/v2.41.mak

NTI_INTLTOOL_TEMP=nti-intltool-${INTLTOOL_VERSION}

NTI_INTLTOOL_EXTRACTED=${EXTTEMP}/${NTI_INTLTOOL_TEMP}/README
NTI_INTLTOOL_CONFIGURED=${EXTTEMP}/${NTI_INTLTOOL_TEMP}/config.log
NTI_INTLTOOL_BUILT=${EXTTEMP}/${NTI_INTLTOOL_TEMP}/intltoolize
NTI_INTLTOOL_INSTALLED=${NTI_TC_ROOT}/usr/bin/intltoolize


## ,-----
## |	Extract
## +-----

${NTI_INTLTOOL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/intltool-${INTLTOOL_VERSION} ] || rm -rf ${EXTTEMP}/intltool-${INTLTOOL_VERSION}
	zcat ${INTLTOOL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_INTLTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_INTLTOOL_TEMP}
	mv ${EXTTEMP}/intltool-${INTLTOOL_VERSION} ${EXTTEMP}/${NTI_INTLTOOL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_INTLTOOL_CONFIGURED}: ${NTI_INTLTOOL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_INTLTOOL_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_INTLTOOL_BUILT}: ${NTI_INTLTOOL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_INTLTOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_INTLTOOL_INSTALLED}: ${NTI_INTLTOOL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_INTLTOOL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-intltool
nti-intltool: nti-perl nti-XML-Parser ${NTI_INTLTOOL_INSTALLED}

ALL_NTI_TARGETS+= nti-intltool

endif	# HAVE_INTLTOOL_CONFIG
