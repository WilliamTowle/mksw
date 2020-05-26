# fbzx v3.1.0			[ EARLIEST v?.?? ]
# last mod WmT, 2016-06-23	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_FBZX_CONFIG},y)
HAVE_FBZX_CONFIG:=y

#DESCRLIST+= "'nti-fbzx' -- fbzx"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${FBZX_VERSION},)
#FBZX_VERSION=2.10.0
#FBZX_VERSION=3.0.0
FBZX_VERSION=3.1.0
endif

FBZX_SRC=${SOURCES}/f/fbzx-${FBZX_VERSION}.tar.bz2
URLS+= http://www.rastersoft.com/descargas/fbzx/fbzx-${FBZX_VERSION}.tar.bz2

include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
include ${CFG_ROOT}/audvid/pulseaudio/v8.0.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

NTI_FBZX_TEMP=nti-fbzx-${FBZX_VERSION}

NTI_FBZX_EXTRACTED=${EXTTEMP}/${NTI_FBZX_TEMP}/README
NTI_FBZX_CONFIGURED=${EXTTEMP}/${NTI_FBZX_TEMP}/src/Makefile.OLD
NTI_FBZX_BUILT=${EXTTEMP}/${NTI_FBZX_TEMP}/src/fbzx
NTI_FBZX_INSTALLED=${NTI_TC_ROOT}/usr/bin/fbzx


## ,-----
## |	Extract
## +-----

${NTI_FBZX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fbzx ] || rm -rf ${EXTTEMP}/fbzx
	#[ ! -d ${EXTTEMP}/fbzx-${FBZX_VERSION} ] || rm -rf ${EXTTEMP}/fbzx-${FBZX_VERSION}
	bzcat ${FBZX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FBZX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FBZX_TEMP}
	mv ${EXTTEMP}/fbzx ${EXTTEMP}/${NTI_FBZX_TEMP}
	#mv ${EXTTEMP}/fbzx-${FBZX_VERSION} ${EXTTEMP}/${NTI_FBZX_TEMP}


## ,-----
## |	Configure
## +-----

# using sdl-config so -I path doesn't include 'SDL' dir

${NTI_FBZX_CONFIGURED}: ${NTI_FBZX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		( echo 'PREFIX='${NTI_TC_ROOT}'/usr' ; cat Makefile.OLD ) > Makefile ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CFLAGS/	{ s%pkg-config%'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config% }' \
			| sed '/^CPPFLAGS/	{ s%pkg-config%'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config% }' \
			| sed '/^LDFLAGS/	{ s%pkg-config%'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config% }' \
			> src/Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FBZX_BUILT}: ${NTI_FBZX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FBZX_INSTALLED}: ${NTI_FBZX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-fbzx
nti-fbzx: nti-pkg-config \
	nti-alsa-lib nti-pulseaudio nti-SDL \
	${NTI_FBZX_INSTALLED}
#nti-fbzx: nti-SDL nti-alsa-lib ${NTI_FBZX_INSTALLED}

ALL_NTI_TARGETS+= nti-fbzx

endif	# HAVE_FBZX_CONFIG
