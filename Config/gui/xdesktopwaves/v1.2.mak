# xdesktopwaves v1.2		[ EARLIEST v1.34, c.2002-10-09 ]
# last mod WmT, 2012-10-24	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_XDESKTOPWAVES_CONFIG},y)
HAVE_XDESKTOPWAVES_CONFIG:=y

#DESCRLIST+= "'nti-xdesktopwaves' -- xdesktopwaves"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XDESKTOPWAVES_VERSION},)
XDESKTOPWAVES_VERSION=1.2
endif

XDESKTOPWAVES_SRC=${SOURCES}/x/xdesktopwaves-${XDESKTOPWAVES_VERSION}.tar.gz

#URLS+= http://downloads.sourceforge.net/project/xdesktopwaves/xdesktopwaves/1.3/xdesktopwaves-1.3.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fxdesktopwaves%2Ffiles%2F&ts=1483713665&use_mirror=netix
URLS+= http://downloads.sourceforge.net/project/xdesktopwaves/xdesktopwaves/${XDESKTOPWAVES_VERSION}/xdesktopwaves-${XDESKTOPWAVES_VERSION}.tar.gz?use_mirror=ignum

NTI_XDESKTOPWAVES_TEMP=nti-xdesktopwaves-${XDESKTOPWAVES_VERSION}

NTI_XDESKTOPWAVES_EXTRACTED=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/README
NTI_XDESKTOPWAVES_CONFIGURED=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/Makefile.OLD
NTI_XDESKTOPWAVES_BUILT=${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}/xdesktopwaves
NTI_XDESKTOPWAVES_INSTALLED=${NTI_TC_ROOT}/usr/X11R6/bin/xdesktopwaves


## ,-----
## |	Extract
## +-----

${NTI_XDESKTOPWAVES_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION} ] || rm -rf ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION}
	zcat ${XDESKTOPWAVES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}
	mv ${EXTTEMP}/xdesktopwaves-${XDESKTOPWAVES_VERSION} ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP}


## ,-----
## |	Configure
## +-----

# FIXME: munge Makefile for CC, CFLAGS, LDFLAGS (-> use toolchain)

${NTI_XDESKTOPWAVES_CONFIGURED}: ${NTI_XDESKTOPWAVES_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^[A-Z1]*DIR/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CFLAGS/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^LFLAGS/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_XDESKTOPWAVES_BUILT}: ${NTI_XDESKTOPWAVES_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XDESKTOPWAVES_INSTALLED}: ${NTI_XDESKTOPWAVES_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/X11R6/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/X11R6/man/man1 ;\
		make install \
	)

##

.PHONY: nti-xdesktopwaves
nti-xdesktopwaves: ${NTI_XDESKTOPWAVES_INSTALLED}

ALL_NTI_TARGETS+= nti-xdesktopwaves

endif	# HAVE_XDESKTOPWAVES_CONFIG
