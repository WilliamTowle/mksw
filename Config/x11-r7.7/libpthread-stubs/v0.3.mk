# libpthread-stubs v0.1		[ since v0.1, 2013-05-27 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBPTHREAD_STUBS_CONFIG},y)
HAVE_LIBPTHREAD_STUBS_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBPTHREAD_STUBS_VERSION},)
#LIBPTHREAD_STUBS_VERSION=0.1
LIBPTHREAD_STUBS_VERSION=0.3
endif

LIBPTHREAD_STUBS_SRC=${DIR_DOWNLOADS}/l/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.bz2
LIBPTHREAD_STUBS_URL=http://www.x.org/releases/individual/xcb/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_LIBPTHREAD_STUBS_TEMP=${DIR_EXTTEMP}/nti-libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}

NTI_LIBPTHREAD_STUBS_EXTRACTED=${NTI_LIBPTHREAD_STUBS_TEMP}/configure
NTI_LIBPTHREAD_STUBS_CONFIGURED=${NTI_LIBPTHREAD_STUBS_TEMP}/config.status
NTI_LIBPTHREAD_STUBS_BUILT=${NTI_LIBPTHREAD_STUBS_TEMP}/pthread-stubs.pc
NTI_LIBPTHREAD_STUBS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/pthread-stubs.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libpthread-stubs-uriurl:
	@echo "${LIBPTHREAD_STUBS_SRC} ${LIBPTHREAD_STUBS_URL}"

show-all-uriurl:: show-nti-libpthread-stubs-uriurl


${NTI_LIBPTHREAD_STUBS_EXTRACTED}: | nti-sanity ${LIBPTHREAD_STUBS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBPTHREAD_STUBS_TEMP} ARCHIVES=${LIBPTHREAD_STUBS_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LIBPTHREAD_STUBS_CONFIGURED}: ${NTI_LIBPTHREAD_STUBS_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${NUI_HOST_SYSTYPE}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--bindir=${DIR_NTI_TOOLCHAIN}/usr/X11R7/bin \
			|| exit 1 \
	)


${NTI_LIBPTHREAD_STUBS_BUILT}: ${NTI_LIBPTHREAD_STUBS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make \
	)


${NTI_LIBPTHREAD_STUBS_INSTALLED}: ${NTI_LIBPTHREAD_STUBS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBPTHREAD_STUBS_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-libpthread-stubs' - build libpthread-stubs for NTI toolchain"

.PHONY: nti-libpthread-stubs
nti-libpthread-stubs: nti-pkg-config \
	${NTI_LIBPTHREAD_STUBS_INSTALLED}

all-nti-targets:: nti-libpthread-stubs


endif	# HAVE_LIBPTHREAD_STUBS_CONFIG
