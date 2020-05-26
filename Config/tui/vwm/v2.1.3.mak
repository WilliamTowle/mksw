# vwm v2.1.3			[ since v2.1.3, c.2017-03-27 ]
# last mod WmT, 2017-03-28	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_VWM_CONFIG},y)
HAVE_VWM_CONFIG:=y

#DESCRLIST+= "'nti-vwm' -- vwm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


ifeq (${VWM_VERSION},)
VWM_VERSION=2.1.3
endif

VWM_SRC=${SOURCES}/v/vwm-${VWM_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/vwm/vwm-${VWM_VERSION}.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fvwm%2F%3Fsource%3Drecommended&ts=1490628458&use_mirror=netix"

include ${CFG_ROOT}/tui/libpseudo/v1.2.0.mak
include ${CFG_ROOT}/tui/libviper/v1.4.6.mak
include ${CFG_ROOT}/tui/libvterm/v0.99.7.mak
#include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_VWM_TEMP=nti-vwm-${VWM_VERSION}

NTI_VWM_EXTRACTED=${EXTTEMP}/${NTI_VWM_TEMP}/LICENSE
NTI_VWM_CONFIGURED=${EXTTEMP}/${NTI_VWM_TEMP}/Makefile.OLD
NTI_VWM_BUILT=${EXTTEMP}/${NTI_VWM_TEMP}/vwm
NTI_VWM_INSTALLED=${NTI_TC_ROOT}/usr/local/bin/vwm


## ,-----
## |	Extract
## +-----

${NTI_VWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/vwm-${VWM_VERSION} ] || rm -rf ${EXTTEMP}/vwm-${VWM_VERSION}
	[ ! -d ${EXTTEMP}/vwm ] || rm -rf ${EXTTEMP}/vwm
	zcat ${VWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VWM_TEMP}
	#mv ${EXTTEMP}/vwm-${VWM_VERSION} ${EXTTEMP}/${NTI_VWM_TEMP}
	mv ${EXTTEMP}/vwm ${EXTTEMP}/${NTI_VWM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VWM_CONFIGURED}: ${NTI_VWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_VWM_TEMP} || exit 1 ;\
		for SD in . modules/vwmterm3 ; do \
			[ -r $${SD}/Makefile.OLD ] || mv $${SD}/Makefile $${SD}/Makefile.OLD || exit 1 ;\
			cat $${SD}/Makefile.OLD \
				| sed '/^CFLAGS/		s%^%CC = '${NTI_GCC}'\n%' \
				| sed '/^	/	s%g*cc%$$(CC)%' \
				| sed 's/PKG_CFG/PKG_CFLAGS/' \
				| sed '/^PKG_CFLAGS/		s%=%= -I'${NTI_TC_ROOT}'/usr/include/ -I'${NTI_TC_ROOT}'/usr/local/include/%' \
				| sed '/^W*LIBS/	s%=%= -L'${NTI_TC_ROOT}'/usr/lib/ -L'${NTI_TC_ROOT}'/usr/local/lib/%' \
				| sed '/^prefix/	s%^%DESTDIR = '${NTI_TC_ROOT}'\n%' \
				| sed '/^moddir/	s%/usr/lib%$$(libdir)%' \
				| sed '/^	/	s%$$(bindir)%$$(DESTDIR)/$$(bindir)%' \
				| sed '/^	/	s%$$(headerdir)%$$(DESTDIR)/$$(headerdir)%' \
				| sed '/^	/	s%$$(moddir)%$$(DESTDIR)/$$(moddir)%' \
				> $${SD}/Makefile ;\
		done \
	)


## ,-----
## |	Build
## +-----

${NTI_VWM_BUILT}: ${NTI_VWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_VWM_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_VWM_INSTALLED}: ${NTI_VWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_VWM_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/bin/' || exit 1 ;\
		make install || exit 1 ;\
	)

.PHONY: nti-vwm
#nti-vwm: nti-ncurses ${NTI_VWM_INSTALLED}
nti-vwm: nti-libpseudo nti-libviper nti-libvterm \
	${NTI_VWM_INSTALLED}

ALL_NTI_TARGETS+= nti-vwm

endif	# HAVE_VWM_CONFIG
