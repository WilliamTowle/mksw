# mpg123 v1.13.2		[ since v0.59r, c.2003-07-05 ]
# last mod WmT, 2011-10-11	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MPG123_CONFIG},y)
HAVE_MPG123_CONFIG:=y

DESCRLIST+= "'nti-mpg123' -- mpg123"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif


ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak


#MPG123_VER=1.12.3
MPG123_VER=1.13.2
MPG123_SRC= ${SRCDIR}/m/mpg123-${MPG123_VER}.tar.bz2

URLS+= http://mpg123.org/download/mpg123-${MPG123_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

CUI_MPG123_TEMP=cui-mpg123-${MPG123_VER}
CUI_MPG123_INSTTEMP=${EXTTEMP}/insttemp

CUI_MPG123_EXTRACTED=${EXTTEMP}/${CUI_MPG123_TEMP}/configure

.PHONY: cui-mpg123-extracted

cui-mpg123-extracted: ${CUI_MPG123_EXTRACTED}

${CUI_MPG123_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_MPG123_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_MPG123_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MPG123_SRC}
	mv ${EXTTEMP}/mpg123-${MPG123_VER} ${EXTTEMP}/${CUI_MPG123_TEMP}

##

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

CUI_MPG123_CONFIGURED=${EXTTEMP}/${CUI_MPG123_TEMP}/config.status

.PHONY: cui-mpg123-configured

cui-mpg123-configured: cui-mpg123-extracted ${CUI_MPG123_CONFIGURED}

${CUI_MPG123_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_MPG123_TEMP} || exit 1 ;\
	  CC=${CTI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${CUI_TC_ROOT}/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			|| exit 1 \
	)
#		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
#			--with-audio=sdl \
#			--with-default-audio=sdl \

##

NTI_MPG123_CONFIGURED=${EXTTEMP}/${NTI_MPG123_TEMP}/config.status

.PHONY: nti-mpg123-configured

nti-mpg123-configured: nti-mpg123-extracted ${NTI_MPG123_CONFIGURED}

${NTI_MPG123_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
#			--with-audio=sdl \
#			--with-default-audio=sdl \


## ,-----
## |	Build
## +-----

CUI_MPG123_BUILT=${EXTTEMP}/${CUI_MPG123_TEMP}/src/mpg123

.PHONY: cui-mpg123-built
cui-mpg123-built: cui-mpg123-configured ${CUI_MPG123_BUILT}

${CUI_MPG123_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_MPG123_TEMP} || exit 1 ;\
		make \
	)

##

CUI_MPG123_BUILT=${EXTTEMP}/${CUI_MPG123_TEMP}/src/mpg123

.PHONY: cui-mpg123-built
cui-mpg123-built: cui-mpg123-configured ${CUI_MPG123_BUILT}

${CUI_MPG123_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_MPG123_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CUI_MPG123_INSTALLED=${CUI_MPG123_INSTTEMP}/usr/bin/mpg123

.PHONY: cui-mpg123-installed

cui-mpg123-installed: cui-mpg123-built ${CUI_MPG123_INSTALLED}

${CUI_MPG123_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_MPG123_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_MPG123_INSTTEMP} \
			|| exit 1 \
	)

.PHONY: cui-mpg123
cui-mpg123: cti-cross-gcc cui-mpg123-installed
#cui-mpg123: cti-pkg-config cti-SDL cui-mpg123-installed

CTARGETS+= cui-mpg123

##

NTI_MPG123_INSTALLED=${NTI_TC_ROOT}/usr/bin/mpg123

.PHONY: nti-mpg123-installed

nti-mpg123-installed: nti-mpg123-built ${NTI_MPG123_INSTALLED}

${NTI_MPG123_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MPG123_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mpg123
nti-mpg123: nti-gcc nti-mpg123-installed
#nti-mpg123: nti-pkg-config nti-SDL nti-mpg123-installed

NTARGETS+= nti-mpg123

endif	# HAVE_MPG123_CONFIG
