# fbv v1.0b	 		[ EARLIEST v1.0b 2014-03-25 ]
# last mod WmT, 2004-08-05	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FBV_CONFIG},y)
HAVE_FBV_CONFIG:=y

#DESCRLIST+= "'nti-fbv' -- fbv"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
include ${CFG_ROOT}/audvid/libpng/v1.4.13.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

ifeq (${FBV_VERSION},)
FBV_VERSION=1.0b
endif

FBV_SRC=${SOURCES}/f/fbv-${FBV_VERSION}.tar.gz
URLS+= http://s-tech.elsat.net.pl/fbv/fbv-1.0b.tar.gz

NTI_FBV_TEMP=nti-fbv-${FBV_VERSION}

NTI_FBV_EXTRACTED=${EXTTEMP}/${NTI_FBV_TEMP}/configure
NTI_FBV_CONFIGURED=${EXTTEMP}/${NTI_FBV_TEMP}/config.h.OLD
NTI_FBV_BUILT=${EXTTEMP}/${NTI_FBV_TEMP}/fbv
NTI_FBV_INSTALLED=${NTI_TC_ROOT}/usr/bin/fbv


## ,-----
## |	Extract
## +-----

${NTI_FBV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fbv-${FBV_VERSION} ] || rm -rf ${EXTTEMP}/fbv-${FBV_VERSION}
	zcat ${FBV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FBV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FBV_TEMP}
	mv ${EXTTEMP}/fbv-${FBV_VERSION} ${EXTTEMP}/${NTI_FBV_TEMP}


## ,-----
## |	Configure
## +-----

## non-standard configure :(
## [v1.0b] LIBS in both Make.conf and Makefile

${NTI_FBV_CONFIGURED}: ${NTI_FBV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBV_TEMP} || exit 1 ;\
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr ;\
		[ -r Make.conf.OLD ] || mv Make.conf Make.conf.OLD || exit 1 ;\
		cat Make.conf.OLD \
			| sed '/^LIBS/	s/^/#/' \
			> Make.conf ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%$$% -I'${NTI_TC_ROOT}'/usr/include%' \
			| sed '/^CFLAGS/	s%$$%\nLDFLAGS=-L'${NTI_TC_ROOT}'/usr/lib%' \
			| sed '/^#*LIBS/	{ s/^#*// ; s/-L[^ ]*// ; s/-lungif// ; s/$$/ -lz/ }'\
			> Makefile ;\
		[ -r config.h.OLD ] || mv config.h config.h.OLD || exit 1 ;\
		cat config.h.OLD \
			| sed '/define FBV_SUPPORT_GIF/	s/define/undef/' \
			| sed '/define FBV_SUPPORT_BMP/	s/define/undef/' \
			> config.h \
	)


## ,-----
## |	Build
## +-----

${NTI_FBV_BUILT}: ${NTI_FBV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FBV_INSTALLED}: ${NTI_FBV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBV_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man/man1 ;\
		make install \
	)

##

.PHONY: nti-fbv
nti-fbv: nti-jpegsrc nti-libpng nti-zlib ${NTI_FBV_INSTALLED}
#nti-fbv: nti-SDL ${NTI_FBV_INSTALLED}

ALL_NTI_TARGETS+= nti-fbv

endif	# HAVE_FBV_CONFIG
