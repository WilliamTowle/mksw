# tetrix 2.5			[ since 2.2, c. 2006-01-07 ]
# last mod WmT, 2024-05-20	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_TETRIX_CONFIG},y)
HAVE_TETRIX_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${TETRIX_VERSION},)
#TETRIX_VERSION=2.2
TETRIX_VERSION=2.5
endif

TETRIX_SRC=${DIR_DOWNLOADS}/t/tetrix-${TETRIX_VERSION}.tar.gz
TETRIX_URL=http://www.catb.org/~esr/tetrix/tetrix-2.2.tar.gz


# Dependencies
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_TETRIX_TEMP=${DIR_EXTTEMP}/nti-tetrix-${TETRIX_VERSION}

NTI_TETRIX_EXTRACTED=${NTI_TETRIX_TEMP}/README
NTI_TETRIX_CONFIGURED=${NTI_TETRIX_TEMP}/Makefile.OLD
NTI_TETRIX_BUILT=${NTI_TETRIX_TEMP}/tetrix
NTI_TETRIX_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/tetrix


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-tetrix-uriurl:
	@echo "${TETRIX_SRC} ${TETRIX_URL}"

show-all-uriurl:: show-nti-tetrix-uriurl


${NTI_TETRIX_EXTRACTED}: | nti-sanity ${TETRIX_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_TETRIX_TEMP} ARCHIVES=${TETRIX_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_TETRIX_CONFIGURED}: ${NTI_TETRIX_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_TETRIX_TEMP} || exit 1 ;\
		for SRC in MoveR.c MoveL.c DrawP.c AdvanceP.c Rotate.c tet.c ; do \
			[ -r $${SRC}.OLD ] || mv $${SRC} $${SRC}.OLD || exit 1 ;\
			cat $${SRC}.OLD \
				| sed '/#include "tet.h"/	s/^/#include <stdlib.h>\n/' \
				| sed 's/exit();/exit(1);/' \
				| sed '/cuserid/ s/.*/strcmp(High[i].Name, getenv("USER"));/' \
				> $${SRC} ;\
		done ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS=/	s%^%CC='${NUI_HOST_GCC}'\n%' \
			| sed '/^CFLAGS=/	s%$$%\nCFLAGS+=-I'${DIR_NTI_TOOLCHAIN}'/usr/include -I'${DIR_NTI_TOOLCHAIN}'/usr/include/ncurses%' \
			| sed '/^	/	s/cc /$${CC} /' \
			| sed '/^	/	s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^	/	s%/usr/bin/install%/usr/bi/tetrix%' \
			| sed '/^	/	s%-lncurses%-L'${DIR_NTI_TOOLCHAIN}'/usr/lib -lncurses%' \
			> Makefile \
	)


${NTI_TETRIX_BUILT}: ${NTI_TETRIX_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_TETRIX_TEMP} || exit 1 ;\
		make || exit 1 \
	)


${NTI_TETRIX_INSTALLED}: ${NTI_TETRIX_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_TETRIX_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/bin || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/share/man/man6 || exit 1 ;\
		make install \
	)


##

USAGE_TEXT+= "'nti-tetrix' - build tetrix for NTI toolchain"

.PHONY: nti-tetrix
nti-tetrix: nti-ncurses ${NTI_TETRIX_INSTALLED}


all-nti-targets:: nti-tetrix


endif	# HAVE_TETRIX_CONFIG
