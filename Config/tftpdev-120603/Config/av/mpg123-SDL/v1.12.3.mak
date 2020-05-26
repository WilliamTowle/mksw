# mpg123 v1.12.3		[ since v0.59r, c.2003-07-05 ]
# last mod WmT, 2010-03-01	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MPG123_CONFIG},y)
HAVE_MPG123_CONFIG:=y

DESCRLIST+= "'nti-mpg123' -- mpg123"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/gui/SDL/v1.2.14.mak


MPG123_VER=1.12.3
MPG123_SRC=${SRCDIR}/m/mpg123-${MPG123_VER}.tar.bz2

URLS+=http://mpg123.org/download/mpg123-${MPG123_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_MPG123_TEMP=nti-mpg123-${MPG123_VER}

NTI_MPG123_EXTRACTED=${EXTTEMP}/${NTI_MPG123_TEMP}/configure

.PHONY: nti-mpg123-extracted

nti-mpg123-extracted: ${NTI_MPG123_EXTRACTED}

${NTI_MPG123_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MPG123_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MPG123_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MPG123_SRC}
	mv ${EXTTEMP}/mpg123-${MPG123_VER} ${EXTTEMP}/${NTI_MPG123_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MPG123_CONFIGURED=${EXTTEMP}/${NTI_MPG123_TEMP}/config.status

.PHONY: nti-mpg123-configured

nti-mpg123-configured: nti-mpg123-extracted ${NTI_MPG123_CONFIGURED}

${NTI_MPG123_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-audio=sdl \
			--with-default-audio=sdl \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_MPG123_BUILT=${EXTTEMP}/${NTI_MPG123_TEMP}/src/mpg123

.PHONY: nti-mpg123-built
nti-mpg123-built: nti-mpg123-configured ${NTI_MPG123_BUILT}

${NTI_MPG123_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_MPG123_INSTALLED=${NTI_TC_ROOT}/usr/bin/mpg123

.PHONY: nti-mpg123-installed

nti-mpg123-installed: nti-mpg123-built ${NTI_MPG123_INSTALLED}

${NTI_MPG123_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mpg123
nti-mpg123: nti-pkg-config nti-SDL nti-mpg123-installed

NTARGETS+= nti-mpg123

endif	# HAVE_MPG123_CONFIG
