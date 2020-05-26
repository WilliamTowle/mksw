# xosview v1.9.1		[ since v1.8.3	2009-09-04 ]
# last mod WmT, 2012-10-25	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_XOSVIEW_CONFIG},y)
HAVE_XOSVIEW_CONFIG:=y

#DESCRLIST+= "'nti-xosview' -- xosview"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XOSVIEW_VERSION},)
#XOSVIEW_VERSION=1.8.3
XOSVIEW_VERSION=1.9.1
#XOSVIEW_VERSION=1.12
endif

#XOSVIEW_SRC=${SOURCES}/x/xosview-${XOSVIEW_VERSION}.tar.bz2
XOSVIEW_SRC=${SOURCES}/x/xosview_${XOSVIEW_VERSION}.orig.tar.gz

#URLS+= http://www.pogo.org.uk/~mark/xosview/releases/xosview-1.12.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/x/xosview/xosview_${XOSVIEW_VERSION}.orig.tar.gz

ifeq (${XOSVIEW_NEEDS_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
endif

NTI_XOSVIEW_TEMP=nti-xosview-${XOSVIEW_VERSION}

NTI_XOSVIEW_EXTRACTED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/configure
NTI_XOSVIEW_CONFIGURED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/config.log
NTI_XOSVIEW_BUILT=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/xosview
NTI_XOSVIEW_INSTALLED=${NTI_TC_ROOT}/usr/bin/xosview


## ,-----
## |	Extract
## +-----

${NTI_XOSVIEW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xosview-${XOSVIEW_VERSION} ] || rm -rf ${EXTTEMP}/xosview-${XOSVIEW_VERSION}
	zcat ${XOSVIEW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XOSVIEW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XOSVIEW_TEMP}
	mv ${EXTTEMP}/xosview-${XOSVIEW_VERSION} ${EXTTEMP}/${NTI_XOSVIEW_TEMP}


## ,-----
## |	Configure
## +-----

## [2016-03-29] debian v1.9.1 has ./configure

${NTI_XOSVIEW_CONFIGURED}: ${NTI_XOSVIEW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 ;\
	)
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			> Makefile \
#			mv configure configure.OLD || exit 1 ;\
#			cat configure.OLD \
#				| sed 's/`pkg-config/`$$PKG_CONFIG/' \
#				> configure ;\
#			chmod a+x configure \
#			| sed '/^PREFIX/	s%/.*%'${NTI_TC_ROOT}'/usr%' \


## ,-----
## |	Build
## +-----

${NTI_XOSVIEW_BUILT}: ${NTI_XOSVIEW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XOSVIEW_INSTALLED}: ${NTI_XOSVIEW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/X11/app-defaults ;\
		make install \
	)

##

.PHONY: nti-xosview
ifeq (${XOSVIEW_NEEDS_X11},true)
nti-xosview: nti-libX11 \
	${NTI_XOSVIEW_INSTALLED}
else
nti-xosview: ${NTI_XOSVIEW_INSTALLED}
endif


ALL_NTI_TARGETS+= nti-xosview

endif	# HAVE_XOSVIEW_CONFIG
