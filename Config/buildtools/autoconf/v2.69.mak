# autoconf v2.69		[ EARLIEST v?.?, c.????-??-?? ]
# last mod WmT, 2014-06-22	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_AUTOCONF_CONFIG},y)
HAVE_AUTOCONF_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-autoconf' -- autoconf"

ifeq (${AUTOCONF_VERSION},)
AUTOCONF_VERSION=2.69
endif
#AUTOCONF_SRC=${SOURCES}/a/autoconf-${AUTOCONF_VERSION}.tar.bz2
AUTOCONF_SRC=${SOURCES}/a/autoconf-${AUTOCONF_VERSION}.tar.gz

#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/m4/v1.4.17.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak
#include ${CFG_ROOT}/perl/perl/v5.22.0.mak

NTI_AUTOCONF_TEMP=nti-autoconf-${AUTOCONF_VERSION}

NTI_AUTOCONF_EXTRACTED=${EXTTEMP}/${NTI_AUTOCONF_TEMP}/README
NTI_AUTOCONF_CONFIGURED=${EXTTEMP}/${NTI_AUTOCONF_TEMP}/config.status
NTI_AUTOCONF_BUILT=${EXTTEMP}/${NTI_AUTOCONF_TEMP}/bin/autoconf
NTI_AUTOCONF_INSTALLED=${NTI_TC_ROOT}/usr/bin/autoconf


## ,-----
## |	Extract
## +-----

${NTI_AUTOCONF_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/autoconf-${AUTOCONF_VERSION} ] || rm -rf ${EXTTEMP}/autoconf-${AUTOCONF_VERSION}
	zcat ${AUTOCONF_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AUTOCONF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AUTOCONF_TEMP}
	mv ${EXTTEMP}/autoconf-${AUTOCONF_VERSION} ${EXTTEMP}/${NTI_AUTOCONF_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_AUTOCONF_CONFIGURED}: ${NTI_AUTOCONF_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_AUTOCONF_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_AUTOCONF_BUILT}: ${NTI_AUTOCONF_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_AUTOCONF_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_AUTOCONF_INSTALLED}: ${NTI_AUTOCONF_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_AUTOCONF_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-autoconf
nti-autoconf: nti-perl nti-m4 ${NTI_AUTOCONF_INSTALLED}

ALL_NTI_TARGETS+= nti-autoconf

endif	# HAVE_AUTOCONF_CONFIG
