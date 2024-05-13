# libtool v2.4.7		[ since v1.4.2, c.2002-10-30 ]
# last mod WmT, 2024-05-21	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBTOOL_CONFIG},y)
HAVE_LIBTOOL_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBTOOL_VERSION},)
# see also v1 to 1.5.26
#LIBTOOL_VERSION=2.4.2
LIBTOOL_VERSION=2.4.7
endif

LIBTOOL_SRC=${DIR_DOWNLOADS}/l/libtool-${LIBTOOL_VERSION}.tar.gz
LIBTOOL_URL= http://mirrorservice.org/sites/ftp.gnu.org/gnu/libtool/libtool-${LIBTOOL_VERSION}.tar.gz

#|ifeq (${LIBTOOL_VERSION},2.4.2)
#|CTI_LIBTOOL_PATCHES=${SOURCES}/l/buildroot-libtool-v2.4.patch
#|endif

# Dependencies
include ${MF_CONFIGDIR}/build-tools/m4/v1.4.19.mk


#|CTI_LIBTOOL_TEMP=cti-libtool-${LIBTOOL_VERSION}
#|
#|CTI_LIBTOOL_EXTRACTED=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/Makefile
#|CTI_LIBTOOL_CONFIGURED=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/config.log
#|CTI_LIBTOOL_BUILT=${EXTTEMP}/${CTI_LIBTOOL_TEMP}/libltdl/libltdl.la
#|CTI_LIBTOOL_INSTALLED=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-libtool


NTI_LIBTOOL_TEMP=${DIR_EXTTEMP}/nti-libtool-${LIBTOOL_VERSION}

NTI_LIBTOOL_EXTRACTED=${NTI_LIBTOOL_TEMP}/configure
NTI_LIBTOOL_CONFIGURED=${NTI_LIBTOOL_TEMP}/config.log
NTI_LIBTOOL_BUILT=${NTI_LIBTOOL_TEMP}/libltdl/libltdl.la
NTI_LIBTOOL_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-libtool

LIBTOOL_HOST_TOOL= ${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-libtool


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libtool-uriurl:
	@echo "${LIBTOOL_SRC} ${LIBTOOL_URL}"

show-all-uriurl:: show-nti-libtool-uriurl


${NTI_LIBTOOL_EXTRACTED}: | nti-sanity ${LIBTOOL_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBTOOL_TEMP} ARCHIVES=${LIBTOOL_SRC} EXTRACT_OPTS='--strip-components=1'


#|# [2012-12-03] need to specify CC=, or runs *native* 'gcc -shared'
#|${CTI_LIBTOOL_CONFIGURED}: ${CTI_LIBTOOL_EXTRACTED}
#|	echo "*** (i) CONFIGURE -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
#|		CC=${CTI_TARGET_SYSTYPE}-gcc \
#|			./configure \
#|				  --prefix=${DIR_CTI_TOOLCHAIN}/usr \
#|				  --host=${TARGSPEC} \
#|				  --build=${HOSTSPEC} \
#|				  --program-prefix=${CTI_TARGET_SYSTYPE}- \
#|				|| exit 1 \
#|	)

${NTI_LIBTOOL_CONFIGURED}: ${NTI_LIBTOOL_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBTOOL_TEMP} || exit 1 ;\
		CC=${NUI_HOST_GCC} \
		  CFLAGS='-O2' \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--program-prefix=${NUI_HOST_SYSTYPE}- \
			|| exit 1 \
	)


#|${CTI_LIBTOOL_BUILT}: ${CTI_LIBTOOL_CONFIGURED}
#|	echo "*** (i) BUILD -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
#|		make \
#|	)

${NTI_LIBTOOL_BUILT}: ${NTI_LIBTOOL_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_LIBTOOL_TEMP} && make )


#|${CTI_LIBTOOL_INSTALLED}: ${CTI_LIBTOOL_BUILT}
#|	echo "*** (i) INSTALLED -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_LIBTOOL_TEMP} || exit 1 ;\
#|		make install \
#|	)


${NTI_LIBTOOL_INSTALLED}: ${NTI_LIBTOOL_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_LIBTOOL_TEMP} && make install )

#

USAGE_TEXT+= "'nti-libtool' - build libtool for NTI toolchain"

.PHONY: nti-libtool
nti-libtool: nti-m4 \
	${NTI_LIBTOOL_INSTALLED}


all-nti-targets:: nti-libtool


endif	# HAVE_LIBTOOL_CONFIG
