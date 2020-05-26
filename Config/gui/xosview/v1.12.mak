## last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]
#
#ifneq (${HAVE_XOSVIEW_CONFIG},y)
#HAVE_XOSVIEW_CONFIG:=y
#
#include ${CFG_ROOT}/ENV/buildtype.mak
#
## http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/x/xosview/xosview_1.9.3.orig.tar.gz
## also at http://www.pogo.org.uk/~mark/xosview/releases/xosview-1.9.3.tar.gz
#
#XOSVIEW_VERSION	:= 1.9.3
#XOSVIEW_SUBDIR	= xosview-${XOSVIEW_VERSION}
## TODO: need URL(s)
#XOSVIEW_ARCHIVE	= ${SOURCES}/x/xosview_${XOSVIEW_VERSION}.orig.tar.gz
#
#XOSVIEW_EXTRACTED	= ${EXTTEMP}/${XOSVIEW_SUBDIR}/README
#XOSVIEW_CONFIGURED	= ${EXTTEMP}/${XOSVIEW_SUBDIR}/Makefile
#XOSVIEW_BUILT		= ${EXTTEMP}/${XOSVIEW_SUBDIR}/xosview
#XOSVIEW_INSTALLED	= ${HOME}/bin/xosview
#
#
### ,-----
### |	Extract
### +-----
#
#${XOSVIEW_EXTRACTED}:
#	echo "*** (i) EXTRACT -> $@ ***"
#	zcat ${XOSVIEW_ARCHIVE} | tar xvf - -C ${EXTTEMP}
##	mv ${EXTTEMP}/${XOSVIEW_SUBDIR} ${EXTTEMP}/${XOSVIEW_SUBDIR}
#
#
### ,-----
### |	Configure
### +-----
#
#
### ,-----
### |	Build
### +-----
#
#${XOSVIEW_BUILT}: ${XOSVIEW_CONFIGURED}
#	echo "*** (i) BUILD -> $@ ***"
#	( cd ${EXTTEMP}/${XOSVIEW_SUBDIR} || exit 1 ;\
#		make \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#${XOSVIEW_INSTALLED}:
#	${MAKE} ${XOSVIEW_BUILT}
#	echo "*** (i) INSTALL -> $@ ***"
#	( cd ${EXTTEMP}/${XOSVIEW_SUBDIR} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: nti-xosview
#nti-xosview:
#	${MAKE} ${XOSVIEW_INSTALLED}
#
#ALL_NTI_TARGETS+= nti-xosview
#
#endif	# HAVE_XOSVIEW_CONFIG


# xosview v1.9.3		[ since v1.8.3	2009-09-04 ]
# last mod WmT, 2012-10-25	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_XOSVIEW_CONFIG},y)
HAVE_XOSVIEW_CONFIG:=y

#DESCRLIST+= "'nti-xosview' -- xosview"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${XOSVIEW_VERSION},)
#XOSVIEW_VERSION=1.8.3
XOSVIEW_VERSION=1.12
endif

#XOSVIEW_SRC=${SOURCES}/x/xosview-${XOSVIEW_VERSION}.tar.bz2
XOSVIEW_SRC=${SOURCES}/x/xosview_1.12.orig.tar.gz

#URLS+= http://www.pogo.org.uk/~mark/xosview/releases/xosview-1.12.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/x/xosview/xosview_1.12.orig.tar.gz

include ${CFG_ROOT}/ENV/buildtype.mak

NTI_XOSVIEW_TEMP=nti-xosview-${XOSVIEW_VERSION}

NTI_XOSVIEW_EXTRACTED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/README
NTI_XOSVIEW_CONFIGURED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/Makefile.OLD
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

${NTI_XOSVIEW_CONFIGURED}: ${NTI_XOSVIEW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/.*%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


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
		make install \
	)

##

.PHONY: nti-xosview
nti-xosview: ${NTI_XOSVIEW_INSTALLED}

ALL_NTI_TARGETS+= nti-xosview

endif	# HAVE_XOSVIEW_CONFIG
