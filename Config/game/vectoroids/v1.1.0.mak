# vectoroids v1.1.0		[ EARLIEST v1.1.0, c.2003-01-20 ]
# last mod WmT, 2013-01-25	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_VECTOROIDS_CONFIG},y)
HAVE_VECTOROIDS_CONFIG:=y

#DESCRLIST+= "'nti-vectoroids' -- vectoroids"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak

ifeq (${VECTOROIDS_VERSION},)
VECTOROIDS_VERSION=1.1.0
endif
VECTOROIDS_SRC=${SOURCES}/v/vectoroids-${VECTOROIDS_VERSION}.tar.gz

URLS+= ftp://ftp.tuxpaint.org/unix/x/vectoroids/src/vectoroids-1.1.0.tar.gz

NTI_VECTOROIDS_TEMP=nti-vectoroids-${VECTOROIDS_VERSION}

NTI_VECTOROIDS_EXTRACTED=${EXTTEMP}/${NTI_VECTOROIDS_TEMP}/COPYING.txt
NTI_VECTOROIDS_CONFIGURED=${EXTTEMP}/${NTI_VECTOROIDS_TEMP}/Makefile.OLD
NTI_VECTOROIDS_BUILT=${EXTTEMP}/${NTI_VECTOROIDS_TEMP}/vectoroids
NTI_VECTOROIDS_INSTALLED=${NTI_TC_ROOT}/usr/bin/vectoroids


## ,-----
## |	Extract
## +-----

${NTI_VECTOROIDS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/vectoroids-${VECTOROIDS_VERSION} ] || rm -rf ${EXTTEMP}/vectoroids-${VECTOROIDS_VERSION}
	zcat ${VECTOROIDS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VECTOROIDS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VECTOROIDS_TEMP}
	mv ${EXTTEMP}/vectoroids-${VECTOROIDS_VERSION} ${EXTTEMP}/${NTI_VECTOROIDS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VECTOROIDS_CONFIGURED}: ${NTI_VECTOROIDS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VECTOROIDS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC='${NTI_GCC}'\n%' \
			| sed '/^CFLAGS/	s%\\$$% -I'${NTI_TC_ROOT}'/usr/include/SDL \\%' \
			| sed '/^PREFIX/	s%/.*%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_VECTOROIDS_BUILT}: ${NTI_VECTOROIDS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VECTOROIDS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VECTOROIDS_INSTALLED}: ${NTI_VECTOROIDS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VECTOROIDS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-vectoroids
nti-vectoroids: nti-SDL nti-SDL_image nti-SDL_mixer ${NTI_VECTOROIDS_INSTALLED}
#nti-vectoroids: nti-libogg nti-libvorbis nti-SDL nti-SDL_mixer ${NTI_VECTOROIDS_INSTALLED}

ALL_NTI_TARGETS+= nti-vectoroids

endif	# HAVE_VECTOROIDS_CONFIG
