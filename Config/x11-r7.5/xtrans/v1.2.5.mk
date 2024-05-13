# xtrans v1.2.7			[ since v1.2, c. 2008-06-12 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_XTRANS_CONFIG},y)
HAVE_XTRANS_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${XTRANS_VERSION},)
XTRANS_VERSION=1.2.5
endif

XTRANS_SRC=${DIR_DOWNLOADS}/x/xtrans-${XTRANS_VERSION}.tar.bz2
XTRANS_URL+= http://www.x.org/releases/X11R7.5/src/lib/xtrans-${XTRANS_VERSION}.tar.bz2
#XTRANS_URL+= http://www.x.org/releases/X11R7.7/src/lib/xtrans-${XTRANS_VERSION}.tar.bz2

# Dependencies
#| include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_XTRANS_TEMP=${DIR_EXTTEMP}/nti-xtrans-${XTRANS_VERSION}

NTI_XTRANS_EXTRACTED=${NTI_XTRANS_TEMP}/configure
NTI_XTRANS_CONFIGURED=${NTI_XTRANS_TEMP}/config.status
NTI_XTRANS_BUILT=${NTI_XTRANS_TEMP}/xtrans.pc
NTI_XTRANS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xtrans.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-xtrans-uriurl:
	@echo "${XTRANS_SRC} ${XTRANS_URL}"

show-all-uriurl:: show-nti-xtrans-uriurl


${NTI_XTRANS_EXTRACTED}: | ${XTRANS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_XTRANS_TEMP} ARCHIVES=${XTRANS_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_XTRANS_CONFIGURED}: ${NTI_XTRANS_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_XTRANS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${NUI_HOST_SYSTYPE}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-pkg-config \
		PKG_CONFIG_PATH=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--bindir=${DIR_NTI_TOOLCHAIN}/usr/X11R7/bin \
			|| exit 1 \
	)


${NTI_XTRANS_BUILT}: ${NTI_XTRANS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_XTRANS_TEMP} || exit 1 ;\
		make \
	)

${NTI_XTRANS_INSTALLED}: ${NTI_XTRANS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_XTRANS_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-xtrans' - build xtrans for NTI toolchain"

.PHONY: nti-xtrans
nti-xtrans: nti-pkg-config \
	${NTI_XTRANS_INSTALLED}


endif	# HAVE_XTRANS_CONFIG
