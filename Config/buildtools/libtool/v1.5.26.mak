# libtool v1.5.26		[ since v1.4.2, c.2002-10-30 ]
# last mod WmT, 2015-09-18	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBTOOL_CONFIG},y)
HAVE_LIBTOOL_CONFIG:=y

DESCRLIST+= "'nti-libtool' -- libtool"
DESCRLIST+= "'cti-libtool' -- libtool"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBTOOL_VERSION},)
LIBTOOL_VERSION=1.5.26
endif

## no build deps

LIBTOOL_SRC=${SOURCES}/l/libtool-${LIBTOOL_VERSION}.tar.gz
URLS+= http://mirrorservice.org/sites/ftp.gnu.org/gnu/libtool/libtool-1.5.26.tar.gz
NATIVE_LIBTOOL_PATCHES:=
CROSS_LIBTOOL_PATCHES:=

CROSS_LIBTOOL_PATCHES+=${SOURCES}/l/buildroot-libtool.patch
URLS+= file://${SOURCES}/l/buildroot-libtool.patch

##

NTI_LIBTOOL_TEMP=nti-libtool-${LIBTOOL_VERSION}

NTI_LIBTOOL_EXTRACTED=${EXTTEMP}/${NTI_LIBTOOL_TEMP}/Makefile
NTI_LIBTOOL_CONFIGURED=${EXTTEMP}/${NTI_LIBTOOL_TEMP}/config.log
NTI_LIBTOOL_BUILT=${EXTTEMP}/${NTI_LIBTOOL_TEMP}/libltdl/libltdl.la
NTI_LIBTOOL_INSTALLED=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool


LIBTOOL_HOST_TOOL= ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config


CTI_LIBTOOL_TEMP=cti-libtool-${LIBTOOL_VERSION}

CTI_LIBTOOL_EXTRACTED=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/Makefile
CTI_LIBTOOL_CONFIGURED=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/config.log
CTI_LIBTOOL_BUILT=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/libltdl/libltdl.la
CTI_LIBTOOL_INSTALLED=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-libtool


LIBTOOL_HOST_TOOL= ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool


## ,-----
## |	Extract
## +-----

${NTI_LIBTOOL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libtool-${LIBTOOL_VERSION} ] || rm -rf ${EXTTEMP}/libtool-${LIBTOOL_VERSION}
	zcat ${LIBTOOL_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${NATIVE_LIBTOOL_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${NATIVE_LIBTOOL_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d libtool-${LIBTOOL_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_LIBTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTOOL_TEMP}
	mv ${EXTTEMP}/libtool-${LIBTOOL_VERSION} ${EXTTEMP}/${NTI_LIBTOOL_TEMP}


${CTI_LIBTOOL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libtool-${LIBTOOL_VERSION} ] || rm -rf ${EXTTEMP}/libtool-${LIBTOOL_VERSION}
	zcat ${LIBTOOL_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${CROSS_LIBTOOL_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${CROSS_LIBTOOL_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d libtool-${LIBTOOL_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${CTI_LIBTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBTOOL_TEMP}
	mv ${EXTTEMP}/libtool-${LIBTOOL_VERSION} ${EXTTEMP}/${CTI_LIBTOOL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBTOOL_CONFIGURED}: ${NTI_LIBTOOL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTOOL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--program-prefix=${HOSTSPEC}- \
			|| exit 1 \
	)

# [2012-12-03] need to specify CC=, or runs *native* 'gcc -shared'
${CTI_LIBTOOL_CONFIGURED}: ${CTI_LIBTOOL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
		CC=${TARGSPEC}-gcc \
			./configure \
				  --prefix=${CTI_TC_ROOT}/usr \
				  --host=${TARGSPEC} \
				  --build=${HOSTSPEC} \
				  --program-prefix=${TARGSPEC}- \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBTOOL_BUILT}: ${NTI_LIBTOOL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTOOL_TEMP} || exit 1 ;\
		make \
	)

${CTI_LIBTOOL_BUILT}: ${CTI_LIBTOOL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBTOOL_INSTALLED}: ${NTI_LIBTOOL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTOOL_TEMP} || exit 1 ;\
		make install \
	)

${CTI_LIBTOOL_INSTALLED}: ${CTI_LIBTOOL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cti-libtool
cti-libtool: ${CTI_LIBTOOL_INSTALLED}

ALL_CTI_TARGETS+= cti-libtool


.PHONY: nti-libtool
nti-libtool: ${NTI_LIBTOOL_INSTALLED}

ALL_NTI_TARGETS+= nti-libtool

endif	# HAVE_LIBTOOL_CONFIG
