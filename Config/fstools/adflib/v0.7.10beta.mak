## adflib v0.7.10beta		[ EARLIEST v2.8, c.2003-01-16 ]
## last mod WmT, 2011-09-28	[ (c) and GPLv2 1999-2011 ]
#
#ifneq (${HAVE_ADFLIB_CONFIG},y)
#HAVE_ADFLIB_CONFIG:=y
#
#DESCRLIST+= "'nti-adflib' -- adflib"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#
### ,-----
### |	Extract
### +-----
#
#NTI_ADFLIB_TEMP=nti-adflib-${ADFLIB_VER}
#
#.PHONY: nti-adflib-extracted
#
#nti-adflib-extracted: ${NTI_ADFLIB_EXTRACTED}
#${NTI_ADFLIB_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_ADFLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ADFLIB_TEMP}
#	[ ! -d ${EXTTEMP}/adflib ] || rm -rf ${EXTTEMP}/adflib
#	make -C ${TOPLEV} extract ARCHIVES=${ADFLIB_SRC}
#	mv ${EXTTEMP}/adflib ${EXTTEMP}/${NTI_ADFLIB_TEMP}
##	mv ${EXTTEMP}/adflib-${ADFLIB_VER} ${EXTTEMP}/${NTI_ADFLIB_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#.PHONY: nti-adflib-configured
#
#nti-adflib-configured: nti-adflib-extracted ${NTI_ADFLIB_CONFIGURED}
#
#${NTI_ADFLIB_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\

#	)
#
#
### ,-----
### |	Build
### +-----
#
#.PHONY: nti-adflib-built
#nti-adflib-built: nti-adflib-configured ${NTI_ADFLIB_BUILT}
#
#${NTI_ADFLIB_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
#		make \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#.PHONY: nti-adflib-installed
#
#nti-adflib-installed: nti-adflib-built ${NTI_ADFLIB_INSTALLED}
#
#${NTI_ADFLIB_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: nti-adflib
#nti-adflib: nti-adflib-installed
#
#NTARGETS+= nti-adflib
#
#endif	# HAVE_ADFLIB_CONFIG


# adflib v2.12		[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_ADFLIB_CONFIG},y)
HAVE_ADFLIB_CONFIG:=y

#DESCRLIST+= "'nti-adflib' -- adflib"
#DESCRLIST+= "'cti-adflib' -- adflib"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#
#include ${CFG_ROOT}/gui/libXdmcp/v1.0.3.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.5.mak
##include ${CFG_ROOT}/gui/libXau/v1.0.6.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
##include ${CFG_ROOT}/gui/libXt/v1.0.9.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
##include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.0.mak
##include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.1.mak
#include ${CFG_ROOT}/gui/x11proto-input/v2.0.mak
##include ${CFG_ROOT}/gui/x11proto-input/v2.0.1.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.4.mak
##include ${CFG_ROOT}/gui/x11proto-kb/v1.0.5.mak
#include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.0.mak
##include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.1.mak

ifeq (${ADFLIB_VERSION},)
ADFLIB_VERSION=0.7.10beta
endif

#ADFLIB_SRC=${SOURCES}/a/adflib-${ADFLIB_VERSION}.zip
ADFLIB_SRC=${SOURCES}/a/adflib0.7.10beta_cvs1.1.1.1.zip
URLS+= http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/a/project/ad/adflib/adflib/adflib_src-0.7.10-cvs1.1.1.1/adflib0.7.10beta_cvs1.1.1.1.zip

NTI_ADFLIB_TEMP=nti-adflib-${ADFLIB_VERSION}

NTI_ADFLIB_EXTRACTED=${EXTTEMP}/${NTI_ADFLIB_TEMP}/Makefile
NTI_ADFLIB_CONFIGURED=${EXTTEMP}/${NTI_ADFLIB_TEMP}/Lib/myconf.sh
NTI_ADFLIB_BUILT=${EXTTEMP}/${NTI_ADFLIB_TEMP}/dosfslabel
NTI_ADFLIB_INSTALLED=${NTI_TC_ROOT}/usr/sbin/dosfslabel


## ,-----
## |	Extract
## +-----

${NTI_ADFLIB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/adflib-${ADFLIB_VERSION} ] || rm -rf ${EXTTEMP}/adflib-${ADFLIB_VERSION}
	unzip -d ${EXTTEMP} ${ADFLIB_SRC}
	[ ! -d ${EXTTEMP}/${NTI_ADFLIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ADFLIB_TEMP}
	mv ${EXTTEMP}/adflib ${EXTTEMP}/${NTI_ADFLIB_TEMP}
	#mv ${EXTTEMP}/adflib-${ADFLIB_VERSION} ${EXTTEMP}/${NTI_ADFLIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ADFLIB_CONFIGURED}: ${NTI_ADFLIB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		mv Lib/Makefile Lib/Makefile.OLD || exit 1 ;\
		cat Lib/Makefile.OLD \
			| sed '/egcs-2.91.66/	s/^/#	/' \
			| sed '/^	/	s%	myconf%	sh ./myconf.sh%' \
			> Lib/Makefile || exit 1 ;\
		sed 's/$$//' Lib/myconf > Lib/myconf.sh \
	)


## ,-----
## |	Build
## +-----

${NTI_ADFLIB_BUILT}: ${NTI_ADFLIB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ADFLIB_INSTALLED}: ${NTI_ADFLIB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ADFLIB_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-adflib
nti-adflib: ${NTI_ADFLIB_INSTALLED}

ALL_NTI_TARGETS+= nti-adflib

endif	# HAVE_ADFLIB_CONFIG
