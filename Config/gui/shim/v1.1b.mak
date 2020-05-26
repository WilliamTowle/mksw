# shim v1.1b			[ EARLIEST v1.1b, c.20??-??-?? ]
# last mod WmT, 2013-12-26	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_SHIM_CONFIG},y)
HAVE_SHIM_CONFIG:=y

#DESCRLIST+= "'nti-shim' -- shim"

ifeq (${SHIM_VERSION},)
SHIM_VERSION=1.1b
endif
SHIM_SRC=${SOURCES}/s/shim-${SHIM_VERSION}.tar.gz

URLS+= http://www.xs4all.nl/~amorel/aseq/pegasosppc/download/shim-1.1b.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak


NTI_SHIM_TEMP=nti-shim-${SHIM_VERSION}

NTI_SHIM_EXTRACTED=${EXTTEMP}/${NTI_SHIM_TEMP}/license
NTI_SHIM_CONFIGURED=${EXTTEMP}/${NTI_SHIM_TEMP}/Makefile
NTI_SHIM_BUILT=${EXTTEMP}/${NTI_SHIM_TEMP}/shim
NTI_SHIM_INSTALLED=${NTI_TC_ROOT}/usr/bin/shim


## ,-----
## |	Extract
## +-----

${NTI_SHIM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_SHIM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SHIM_TEMP}
	mkdir -p ${EXTTEMP}/${NTI_SHIM_TEMP}
	zcat ${SHIM_SRC} | tar xvf - -C ${EXTTEMP}/${NTI_SHIM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SHIM_CONFIGURED}: ${NTI_SHIM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SHIM_TEMP} || exit 1 ;\
		[ -r SDL ] || ln -sf . SDL ;\
		sed -n '/^"/ { s/"//g ; s/cc -lSDL -lSDL_image/CC=\nCFLAGS:=\nLDFLAGS:=\nLIBS:=\n\n\ndefault:\n	$${CC} $${CFLAGS} $${LDFLAGS} $${LIBS}/ ; p }' compile.readme > Makefile.OLD ;\
		wc -l Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/CC=/		s/$$/gcc/' \
			| sed '/CFLAGS:=/	s%$$%-I. -I${NTI_TC_ROOT}/usr/include -I${NTI_TC_ROOT}/usr/include/SDL%' \
			| sed '/LDFLAGS:=/	s%$$%-L${NTI_TC_ROOT}/usr/lib%' \
			| sed '/LIBS:=/	s%$$%-lSDL -lSDL_image -lm%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_SHIM_BUILT}: ${NTI_SHIM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SHIM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SHIM_INSTALLED}: ${NTI_SHIM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SHIM_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		cp shim ${NTI_TC_ROOT}/usr/bin \
	)
#	v1.1b doesn't have an 'install' rule
#	make install \

##

.PHONY: nti-shim
nti-shim: nti-SDL nti-SDL_image ${NTI_SHIM_INSTALLED}

ALL_NTI_TARGETS+= nti-shim

endif	# HAVE_SHIM_CONFIG
