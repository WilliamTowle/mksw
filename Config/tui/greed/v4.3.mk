# greed 4.4			[ since v4.1, c. 2015-08-12 ]
# last mod WmT, 2024-05-17	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_GREED_CONFIG},y)
HAVE_GREED_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${GREED_VERSION},)
#GREED_VERSION=4.1
GREED_VERSION=4.3
endif

GREED_SRC=${DIR_DOWNLOADS}/g/greed-${GREED_VERSION}.tar.gz
GREED_URL=http://www.catb.org/~esr/greed/greed-${GREED_VERSION}.tar.gz


# Dependencies
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_GREED_TEMP=${DIR_EXTTEMP}/nti-greed-${GREED_VERSION}

NTI_GREED_EXTRACTED=${NTI_GREED_TEMP}/README
NTI_GREED_CONFIGURED=${NTI_GREED_TEMP}/Makefile.OLD
NTI_GREED_BUILT=${NTI_GREED_TEMP}/greed
NTI_GREED_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/games/greed


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-greed-uriurl:
	@echo "${GREED_SRC} ${GREED_URL}"

show-all-uriurl:: show-nti-greed-uriurl


${NTI_GREED_EXTRACTED}: | nti-sanity ${GREED_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_GREED_TEMP} ARCHIVES=${GREED_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_GREED_CONFIGURED}: ${NTI_GREED_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_GREED_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^VERS/		s%$$%\nCC='${NUI_HOST_GCC}'%' \
			| sed '/^CC=/		s%$$%\nCFLAGS=-I'${DIR_NTI_TOOLCHAIN}'/usr/include -I'${DIR_NTI_TOOLCHAIN}'/usr/include/ncurses%' \
			| sed '/^CFLAGS=/	s%$$%\nLDFLAGS=-L'${DIR_NTI_TOOLCHAIN}'/usr/lib%' \
			| sed '/^BIN/		s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^SFILE/		s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^	/	s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^	/	s/-lcurses/-lncurses/' \
			> Makefile \
	)


${NTI_GREED_BUILT}: ${NTI_GREED_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_GREED_TEMP} || exit 1 ;\
		make || exit 1 \
	)


${NTI_GREED_INSTALLED}: ${NTI_GREED_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_GREED_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/games || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/share/man/man6 || exit 1 ;\
		make install \
	)


##

USAGE_TEXT+= "'nti-greed' - build greed for NTI toolchain"

.PHONY: nti-greed
nti-greed: nti-ncurses ${NTI_GREED_INSTALLED}


all-nti-targets:: nti-greed


endif	# HAVE_GREED_CONFIG
