# fbi v1.31	 		[ EARLIEST v1.31 2014-03-25 ]
# last mod WmT, 2014-03-25	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FBI_CONFIG},y)
HAVE_FBI_CONFIG:=y

#DESCRLIST+= "'nti-fbi' -- fbi"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
##include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
##include ${CFG_ROOT}/audvid/libpng/v1.4.12.mak
##include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak

ifeq (${FBI_VERSION},)
FBI_VERSION=1.31
endif

FBI_SRC=${SOURCES}/f/fbi_${FBI_VERSION}.tar.gz
URLS+= http://www.kraxel.org/releases/fbida/fbi_1.31.tar.gz

NTI_FBI_TEMP=nti-fbi-${FBI_VERSION}

NTI_FBI_EXTRACTED=${EXTTEMP}/${NTI_FBI_TEMP}/README
NTI_FBI_CONFIGURED=${EXTTEMP}/${NTI_FBI_TEMP}/mk/Variables.mk.OLD
NTI_FBI_BUILT=${EXTTEMP}/${NTI_FBI_TEMP}/fbi
NTI_FBI_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/fbi


## ,-----
## |	Extract
## +-----

${NTI_FBI_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fbi-${FBI_VERSION} ] || rm -rf ${EXTTEMP}/fbi-${FBI_VERSION}
	zcat ${FBI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FBI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FBI_TEMP}
	mv ${EXTTEMP}/fbi-${FBI_VERSION} ${EXTTEMP}/${NTI_FBI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FBI_CONFIGURED}: ${NTI_FBI_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBI_TEMP} || exit 1 ;\
		[ -r mk/Variables.mk.OLD ] || mv mk/Variables.mk mk/Variables.mk.OLD || exit 1 ;\
		cat mk/Variables.mk.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^prefix/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> mk/Variables.mk \
	)


## ,-----
## |	Build
## +-----

${NTI_FBI_BUILT}: ${NTI_FBI_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBI_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FBI_INSTALLED}: ${NTI_FBI_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBI_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
	)

##

.PHONY: nti-fbi
nti-fbi: ${NTI_FBI_INSTALLED}
#nti-fbi: nti-SDL ${NTI_FBI_INSTALLED}

ALL_NTI_TARGETS+= nti-fbi

endif	# HAVE_FBI_CONFIG
