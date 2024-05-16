# bastet v0.41			[ since v0.37, c. 2004-05-05 ]
# last mod WmT, 2024-05-16	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BASTET_CONFIG},y)
HAVE_BASTET_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${BASTET_VERSION},)
BASTET_VERSION=0.41
endif

BASTET_SRC=${DIR_DOWNLOADS}/b/bastet-${BASTET_VERSION}.tgz
#| URLS+=http://fph.altervista.org/prog/files/bastet-0.41.tgz
BASTET_URL=https://download.tuxfamily.org/slitaz/sources/packages-2.0/b/bastet-0.41.tgz


# Dependencies
#| include ${CFG_ROOT}/build-tools/pkg-config/v0.23.mak
#| include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_BASTET_TEMP=${DIR_EXTTEMP}/nti-bastet-${BASTET_VERSION}

NTI_BASTET_EXTRACTED=${NTI_BASTET_TEMP}/TODO
NTI_BASTET_CONFIGURED=${NTI_BASTET_TEMP}/Makefile.OLD
NTI_BASTET_BUILT=${NTI_BASTET_TEMP}/bastet
NTI_BASTET_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/bastet


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-bastet-uriurl:
	@echo "${BASTET_SRC} ${BASTET_URL}"

show-all-uriurl:: show-nti-bastet-uriurl


${NTI_BASTET_EXTRACTED}: | nti-sanity ${BASTET_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_BASTET_TEMP} ARCHIVES=${BASTET_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_BASTET_CONFIGURED}: ${NTI_BASTET_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_BASTET_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^[A-Z]*_PREFIX=/ { s%/%$${DESTDIR}/% ; s%/%'${DIR_NTI_TOOLCHAIN}'/% }' \
				| sed '/^CC=/	s%g*cc$$%'${NUI_HOST_GCC}'%' \
				| sed '/^CFLAGS=/	s%$$% '"` ${NCURSES_CONFIG_TOOL} --cflags `"'%' \
				| sed '/^LDFLAGS=/	s%-lncurses%-L'"` ${NCURSES_CONFIG_TOOL} --libdir `"'%' \
				| sed '/^LDFLAGS=/	s%$$%\nLIBS=-lncurses%' \
				| sed '/^	chown/ s/^/#/' \
				| sed '/$$(CC) $$(LDFLAGS)/	s/$$/ $$(LIBS)/' \
				> $${MF} || exit 1 ;\
		done \
	)


${NTI_BASTET_BUILT}: ${NTI_BASTET_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_BASTET_TEMP} || exit 1 ;\
		make \
	)


${NTI_BASTET_INSTALLED}: ${NTI_BASTET_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_BASTET_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/var/games ;\
		make install VARPREFIX=${DIR_NTI_TOOLCHAIN} \
	)


##

USAGE_TEXT+= "'nti-bastet' - build bastet for NTI toolchain"

.PHONY: nti-bastet
nti-bastet: nti-ncurses ${NTI_BASTET_INSTALLED}


all-nti-targets:: nti-bastet

endif	# HAVE_BASTET_CONFIG
