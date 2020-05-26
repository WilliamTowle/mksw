# nxlib v0.46			[ EARLIEST v0.46, 2017-03-31 ]
# last mod WmT, 2017-03-31	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_NXLIB_CONFIG},y)
HAVE_NXLIB_CONFIG:=y

#DESCRLIST+= "'nti-nxlib' -- NXLIB"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${NXLIB_VERSION},)
NXLIB_VERSION=0.46
endif

NXLIB_SRC=${SOURCES}/n/nxlib-${NXLIB_VERSION}.tar.gz
URLS+= http://www.libsdl.org/release/nxlib-${NXLIB_VERSION}.tar.gz

include ${CFG_ROOT}/gui/microwindows/v0.9x.mak

NTI_NXLIB_TEMP=nti-nxlib-${NXLIB_VERSION}

NTI_NXLIB_EXTRACTED=${EXTTEMP}/${NTI_NXLIB_TEMP}/LICENSE
NTI_NXLIB_CONFIGURED=${EXTTEMP}/${NTI_NXLIB_TEMP}/Makefile.OLD
NTI_NXLIB_BUILT=${EXTTEMP}/${NTI_NXLIB_TEMP}/libNX11.so
NTI_NXLIB_INSTALLED=${NTI_TC_ROOT}/opt/microwindows/lib/libNX11.so.6.2


## ,-----
## |	Extract
## +-----

${NTI_NXLIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/nxlib-${NXLIB_VERSION} ] || rm -rf ${EXTTEMP}/nxlib-${NXLIB_VERSION}
	[ ! -d ${EXTTEMP}/nxlib ] || rm -rf ${EXTTEMP}/nxlib
	zcat ${NXLIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NXLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NXLIB_TEMP}
	#mv ${EXTTEMP}/nxlib-${NXLIB_VERSION} ${EXTTEMP}/${NTI_NXLIB_TEMP}
	mv ${EXTTEMP}/nxlib ${EXTTEMP}/${NTI_NXLIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_NXLIB_CONFIGURED}: ${NTI_NXLIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NXLIB_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^SHAREDLIB/	s/N$$/Y/' \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^xCFLAGS/	s%$$%\nCFLAGS += -fPIC%' \
			| sed '/^MWIN_INCLUDE/	s%\.\.\/.*%'${NTI_TC_ROOT}'/opt/microwindows/include%' \
			| sed '/^MWIN_LIB/	s%\.\.\/.*%'${NTI_TC_ROOT}'/opt/microwindows/lib%' \
			| sed '/^INSTALL_DIR/	s%\..*%${NTI_TC_ROOT}/opt/microwindows/lib%' \
			| sed '/lib$$(LIBNAME).a/	s/^#//' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_NXLIB_BUILT}: ${NTI_NXLIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NXLIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_NXLIB_INSTALLED}: ${NTI_NXLIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NXLIB_TEMP} || exit 1 ;\
		cp libNX11.so ${NTI_TC_ROOT}/opt/microwindows/lib/ || exit 1 ;\
		cp libNX11.a ${NTI_TC_ROOT}/opt/microwindows/lib/ || exit 1 ;\
		( cd ${NTI_TC_ROOT}/opt/microwindows/lib/ && ln -sf libNX11.so libNX11.so.6 ) || exit 1 \
	)
#		make install \

##

.PHONY: nti-nxlib
nti-nxlib: ${NTI_NXLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-nxlib

endif	# HAVE_NXLIB_CONFIG
