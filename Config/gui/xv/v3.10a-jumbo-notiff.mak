# xv v3.10a			[ since v3.10, c. 2009-09-04 ]
# last mod WmT, 2017-09-05	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XV_CONFIG},y)
HAVE_XV_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xv' -- xv"

ifeq (${XV_VERSION},)
XV_VERSION=3.10a
endif

XV_SRC=${SOURCES}/x/xv-3.10a.tar.gz
XV_PATCHES=${SOURCES}/x/xv-3.10a-jumbo-patches-20050501.tar.gz
#XV_PATCHES=${SOURCES}/x/xv-3.10a-jumbo-patches-20070520.tar.gz

URLS+=ftp://ftp.trilon.com/pub/xv/xv-3.10a.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/png-mng/XV%20jumbo%20patches/20070520/xv-3.10a-jumbo-patches-20070520.tar.gz?r=&ts=1361353474&use_mirror=switch'
# http://ftp.heanet.ie/disk1/slackware/pub/slackware/slackware-4.0/source/xap/xv/xv-3.10.tar.gz
# http://ftp.heanet.ie/disk1/slackware/pub/slackware/slackware-4.0/source/xap/xv/xv-3.10a.JPEG-patch
# http://ftp.heanet.ie/disk1/slackware/pub/slackware/slackware-4.0/source/xap/xv/xv-3.10a.TIFF-patch
# http://ftp.heanet.ie/disk1/slackware/pub/slackware/slackware-4.0/source/xap/xv/xv-3.10a.diff
# http://ftp.heanet.ie/disk1/slackware/pub/slackware/slackware-4.0/source/xap/xv/xv-3.10a.patch

#include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak

NTI_XV_TEMP=nti-xv-${XV_VERSION}

NTI_XV_EXTRACTED=${EXTTEMP}/${NTI_XV_TEMP}/README
NTI_XV_CONFIGURED=${EXTTEMP}/${NTI_XV_TEMP}/Makefile.OLD
NTI_XV_BUILT=${EXTTEMP}/${NTI_XV_TEMP}/xv
NTI_XV_INSTALLED=${NTI_TC_ROOT}/usr/bin/xv


## ,-----
## |	Extract
## +-----

${NTI_XV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/xv-${XV_VERSION} ] || rm -rf ${EXTTEMP}/xv-${XV_VERSION}
	zcat ${XV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XV_TEMP}
	mv ${EXTTEMP}/xv-${XV_VERSION} ${EXTTEMP}/${NTI_XV_TEMP}
ifneq (${XV_PATCHES},)
	for PF in ${XV_PATCHES} ; do \
		echo "*** PATCHING -- $${PF} ***" ;\
		grep '+++' $${PF} ;\
		zcat $${PF} | patch --batch -d ${EXTTEMP}/${NTI_XV_TEMP} -Np1 ;\
	done
endif

## ,-----
## |	Configure
## +-----

## [2017-09-05] fixed for 'const' in modern sys_errlist[]

${NTI_XV_CONFIGURED}: ${NTI_XV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XV_TEMP} || exit 1 ;\
		[ -r xv.h.OLD ] || mv xv.h xv.h.OLD || exit 1 ;\
		cat xv.h.OLD \
			| sed '/sys_errlist\[\]/ s%^%// {overkill ...and wrong}%' \
			> xv.h || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s/cc/gcc/' \
			| sed '/-DLINUX/	{ s/^#// ; s%-L[^ ]*%-I'${NTI_TC_ROOT}'/usr/include -L'${NTI_TC_ROOT}'/usr/lib%g }' \
			| sed '/^[A-Z]*DIR =/	{ s%/local/%/% ; s%/%'${NTI_TC_ROOT}'/% }' \
			| sed '/^TIFF/		s/^/#/' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_XV_BUILT}: ${NTI_XV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XV_INSTALLED}: ${NTI_XV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XV_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man/man1 ;\
		make install \
	)

##

.PHONY: nti-xv
#nti-xv: nti-libtiff ${NTI_XV_INSTALLED}
nti-xv: nti-libX11 ${NTI_XV_INSTALLED}

ALL_NTI_TARGETS+= nti-xv

endif	# HAVE_XV_CONFIG
