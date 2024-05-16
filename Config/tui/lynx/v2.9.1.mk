# lynx v2.9.1			[ since v2.8.4, c.2003-06-04 ]
# last mod WmT, 2024-05-16	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LYNX_CONFIG},y)
HAVE_LYNX_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LYNX_VERSION},)
#LYNX_VERSION=2.8.6
#LYNX_VERSION=2.8.7
#LYNX_VERSION=2.8.8
#LYNX_VERSION=2.8.9rel.1
LYNX_VERSION=2.9.1
endif

LYNX_SRC=${DIR_DOWNLOADS}/l/lynx${LYNX_VERSION}.tar.bz2
#URLS+= https://invisible-mirror.net/archives/lynx/tarballs/lynx${LYNX_VERSION}.tar.bz2
LYNX_URL=https://invisible-mirror.net/archives/lynx/tarballs/lynx${LYNX_VERSION}.tar.bz2


# Dependencies
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_LYNX_TEMP=${DIR_EXTTEMP}/nti-lynx-${LYNX_VERSION}

NTI_LYNX_EXTRACTED=${NTI_LYNX_TEMP}/configure
NTI_LYNX_CONFIGURED=${NTI_LYNX_TEMP}/config.log
NTI_LYNX_BUILT=${NTI_LYNX_TEMP}/lynx
NTI_LYNX_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/lynx


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-lynx-uriurl:
	@echo "${LYNX_SRC} ${LYNX_URL}"

show-all-uriurl:: show-nti-lynx-uriurl


${NTI_LYNX_EXTRACTED}: | nti-sanity ${LYNX_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LYNX_TEMP} ARCHIVES=${LYNX_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LYNX_CONFIGURED}: ${NTI_LYNX_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LYNX_TEMP} || exit 1 ;\
		CC=${NUI_HOST_GCC} \
		  CFLAGS='-O2 '"`${NCURSES_CONFIG_TOOL} --cflags`" \
		  LDFLAGS='-L'"`${NCURSES_CONFIG_TOOL} --libdir`" \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
			./configure \
				--prefix=${DIR_NTI_TOOLCHAIN}/usr \
				--with-screen=ncurses \
				--with-curses-dir=` ${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-pkg-config --variable=prefix ncurses ` \
				|| exit 1 ;\
		[ -r lynx.cfg.OLD ] || mv lynx.cfg lynx.cfg.OLD || exit 1 ;\
		cat lynx.cfg.OLD \
			| sed '/^#*COLOR:0/	{ s/^#// ; s/[a-z].*/white:black/ }' \
			| sed '/^#*COLOR:1/	{ s/^#// ; s/[a-z].*/brown:black/ }' \
			| sed '/^#*COLOR:2/	{ s/^#// ; s/[a-z].*/yellow:blue/ }' \
			| sed '/^#*COLOR:3/	{ s/^#// ; s/[a-z].*/green:black/ }' \
			| sed '/^#*COLOR:4/	{ s/^#// ; s/[a-z].*/yellow:black/ }' \
			| sed '/^#*COLOR:5/	{ s/^#// ; s/[a-z].*/blue:black/ }' \
			| sed '/^#*COLOR:6/	{ s/^#// ; s/[a-z].*/brightmagenta:black/ }' \
			> lynx.cfg \
	)


${NTI_LYNX_BUILT}: ${NTI_LYNX_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_LYNX_TEMP} || exit 1 ;\
		make \
	)


${NTI_LYNX_INSTALLED}: ${NTI_LYNX_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_LYNX_TEMP} || exit 1 ;\
		make install \
	)

##

USAGE_TEXT+= "'nti-lynx' - build lynx for NTI toolchain"

.PHONY: nti-lynx
nti-lynx: nti-ncurses ${NTI_LYNX_INSTALLED}


all-nti-targets:: nti-lynx


endif	# HAVE_LYNX_CONFIG
