# expat v2.1.0			[ since v0.37.1, 2013-04-22 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_EXPAT_CONFIG},y)
HAVE_EXPAT_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


#DESCRLIST+= "'nti-expat' -- expat"

ifeq (${EXPAT_VERSION},)
EXPAT_VERSION=2.1.0
endif

EXPAT_SRC=${SOURCES}/e/expat-${EXPAT_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz?use_mirror=ignum


CTI_EXPAT_TEMP=cti-expat-${EXPAT_VERSION}

CTI_EXPAT_EXTRACTED=${EXTTEMP}/${CTI_EXPAT_TEMP}/README
CTI_EXPAT_CONFIGURED=${EXTTEMP}/${CTI_EXPAT_TEMP}/config.log
CTI_EXPAT_BUILT=${EXTTEMP}/${CTI_EXPAT_TEMP}/lib/xmlrole.lo
CTI_EXPAT_INSTALLED=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/expat.pc


NTI_EXPAT_TEMP=nti-expat-${EXPAT_VERSION}

NTI_EXPAT_EXTRACTED=${EXTTEMP}/${NTI_EXPAT_TEMP}/README
NTI_EXPAT_CONFIGURED=${EXTTEMP}/${NTI_EXPAT_TEMP}/config.log
NTI_EXPAT_BUILT=${EXTTEMP}/${NTI_EXPAT_TEMP}/lib/xmlrole.lo
NTI_EXPAT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/expat.pc


## ,-----
## |	Extract
## +-----

${CTI_EXPAT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/expat-${EXPAT_VERSION} ] || rm -rf ${EXTTEMP}/expat-${EXPAT_VERSION}
	zcat ${EXPAT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_EXPAT_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_EXPAT_TEMP}
	mv ${EXTTEMP}/expat-${EXPAT_VERSION} ${EXTTEMP}/${CTI_EXPAT_TEMP}

##

${NTI_EXPAT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/expat-${EXPAT_VERSION} ] || rm -rf ${EXTTEMP}/expat-${EXPAT_VERSION}
	zcat ${EXPAT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_EXPAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_EXPAT_TEMP}
	mv ${EXTTEMP}/expat-${EXPAT_VERSION} ${EXTTEMP}/${NTI_EXPAT_TEMP}


## ,-----
## |	Configure
## +-----

${CTI_EXPAT_CONFIGURED}: ${CTI_EXPAT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_EXPAT_TEMP} || exit 1 ;\
		  CC=${CUI_GCC} \
		    CFLAGS='-O2' \
		  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${CTI_TC_ROOT}/usr \
				--build=${HOSTSPEC} \
				--host=${TARGSPEC} \
				|| exit 1 \
	)

##

${NTI_EXPAT_CONFIGURED}: ${NTI_EXPAT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_EXPAT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		  CC=${NTI_GCC} \
		    CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${CTI_EXPAT_BUILT}: ${CTI_EXPAT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_EXPAT_TEMP} || exit 1 ;\
		make \
	)

##

${NTI_EXPAT_BUILT}: ${NTI_EXPAT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_EXPAT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CTI_EXPAT_INSTALLED}: ${CTI_EXPAT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_EXPAT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-expat
cti-expat: cti-pkg-config ${CTI_EXPAT_INSTALLED}

ALL_CTI_TARGETS+= cti-expat

##

${NTI_EXPAT_INSTALLED}: ${NTI_EXPAT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_EXPAT_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/`basename ${NTI_EXPAT_INSTALLED}` ${NTI_EXPAT_INSTALLED} \

.PHONY: nti-expat
nti-expat: nti-pkg-config ${NTI_EXPAT_INSTALLED}

ALL_NTI_TARGETS+= nti-expat

endif	# HAVE_EXPAT_CONFIG
