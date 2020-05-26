# tiff v3.9.7			[ since v3.9.4, c. 2010-06-28 ]
# last mod WmT, 2014-06-30	[ (c) and GPLv2 1999-2014* ]

#	ifneq (${HAVE_LIBTIFF_CONFIG},y)
#	HAVE_LIBTIFF_CONFIG:=y
#	
#	DESCRLIST+= "'nti-libtiff' -- tiff"
#	
#	## v3.8.2: uses i686 linker (!!) for '*gcc -shared ...' [10-09-03]
#	## v3.9.4: uses i686 linker (!!) for '*gcc -shared ...' [10-09-03]
#	## v3.9.5: uses i686 linker (!!) for '*gcc -shared ...' [10-09-03]
#	
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	include ${CFG_ROOT}/ENV/native.mak
#	include ${CFG_ROOT}/ENV/target.mak
#	
#	include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#	
#	#TIFF_VER=3.8.2
#	#TIFF_VER=3.9.4
#	TIFF_VER=3.9.5
#	TIFF_SRC=${SRCDIR}/t/tiff-${TIFF_VER}.tar.gz
#	
#	
#	
#	## ,-----
#	## |	Extract
#	## +-----
#	
#	
#	NTI_LIBTIFF_TEMP=nti-libtiff-${TIFF_VER}
#	NTI_LIBTIFF_EXTRACTED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/configure
#	
#	CTI_LIBTIFF_TEMP=cti-libtiff-${TIFF_VER}
#	CTI_LIBTIFF_EXTRACTED=${EXTTEMP}/${CTI_LIBTIFF_TEMP}/configure
#	
#	##
#	
#	.PHONY: nti-libtiff-extracted
#	
#	nti-libtiff-extracted: ${NTI_LIBTIFF_EXTRACTED}
#	${NTI_LIBTIFF_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${NTI_LIBTIFF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTIFF_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${TIFF_SRC}
#		mv ${EXTTEMP}/tiff-${TIFF_VER} ${EXTTEMP}/${NTI_LIBTIFF_TEMP}
#	
#	##
#	
#	.PHONY: cti-libtiff-extracted
#	
#	cti-libtiff-extracted: ${CTI_LIBTIFF_EXTRACTED}
#	${CTI_LIBTIFF_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${CTI_LIBTIFF_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBTIFF_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${TIFF_SRC}
#		mv ${EXTTEMP}/tiff-${TIFF_VER} ${EXTTEMP}/${CTI_LIBTIFF_TEMP}
#	
#	
#	## ,-----
#	## |	Configure
#	## +-----
#	
#	NTI_LIBTIFF_CONFIGURED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/config.status
#	
#	.PHONY: nti-libtiff-configured
#	
#	nti-libtiff-configured: nti-libtiff-extracted ${NTI_LIBTIFF_CONFIGURED}
#	
#	${NTI_LIBTIFF_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
#			 ./configure \
#				--prefix=${NTI_TC_ROOT}/usr/ \
#				|| exit 1 \
#		)
#	
#	##
#	
#	CTI_LIBTIFF_CONFIGURED=${EXTTEMP}/${CTI_LIBTIFF_TEMP}/config.status
#	
#	.PHONY: cti-libtiff-configured
#	
#	cti-libtiff-configured: cti-libtiff-extracted ${CTI_LIBTIFF_CONFIGURED}
#	
#	${CTI_LIBTIFF_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CTI_LIBTIFF_TEMP} || exit 1 ;\
#			LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
#			 ./configure \
#				--prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC} \
#				--build=${NTI_SPEC} \
#				--host=${CTI_SPEC} \
#				--without-x \
#				--disable-shared \
#				--disable-cxx \
#				|| exit 1 \
#		)
#	
#	
#	## ,-----
#	## |	Build
#	## +-----
#	
#	
#	.PHONY: nti-libtiff-built
#	nti-libtiff-built: nti-libtiff-configured ${NTI_LIBTIFF_BUILT}
#	
#	${NTI_LIBTIFF_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
#			make \
#		)
#	
#	##
#	
#	CTI_LIBTIFF_BUILT=${EXTTEMP}/${CTI_LIBTIFF_TEMP}/tools/tiffmedian
#	
#	.PHONY: cti-libtiff-built
#	cti-libtiff-built: cti-libtiff-configured ${CTI_LIBTIFF_BUILT}
#	
#	${CTI_LIBTIFF_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CTI_LIBTIFF_TEMP} || exit 1 ;\
#			make \
#			LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
#		)
#	
#	
#	
#	## ,-----
#	## |	Install
#	## +-----
#	
#	NTI_LIBTIFF_INSTALLED=${NTI_TC_ROOT}/usr/bin/tiffmedian
#	
#	.PHONY: nti-libtiff-installed
#	
#	nti-libtiff-installed: nti-libtiff-built ${NTI_LIBTIFF_INSTALLED}
#	
#	${NTI_LIBTIFF_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
#			make install \
#		)
#	
#	##
#	
#	CTI_LIBTIFF_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/bin/tiffmedian
#	
#	.PHONY: cti-libtiff-installed
#	
#	cti-libtiff-installed: cti-libtiff-built ${CTI_LIBTIFF_INSTALLED}
#	
#	${CTI_LIBTIFF_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		( cd ${EXTTEMP}/${CTI_LIBTIFF_TEMP} || exit 1 ;\
#			make install \
#		)
#	
#	##
#	
#	.PHONY: nti-libtiff
#	nti-libtiff: nti-libtiff-installed
#	
#	NTARGETS+= nti-libtiff
#	
#	.PHONY: cti-libtiff
#	cti-libtiff: cti-cross-gcc cti-cross-libtool cti-libtiff-installed
#	
#	CTARGETS+= cti-libtiff
#	
#	endif	# HAVE_LIBTIFF_CONFIG

ifneq (${HAVE_LIBTIFF_CONFIG},y)
HAVE_LIBTIFF_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

DESCRLIST+= "'nti-libtiff' -- libtiff"

ifeq (${LIBTIFF_VERSION},)
#LIBTIFF_VERSION=3.8.2
LIBTIFF_VERSION=3.9.7
endif

LIBTIFF_SRC=${SOURCES}/t/tiff-${LIBTIFF_VERSION}.tar.gz
URLS+= # ftp://ftp.remotesensing.org/pub/libtiff/tiff-${TIFF_VERSION}.tar.gz

NTI_LIBTIFF_TEMP=nti-libtiff-${LIBTIFF_VERSION}

NTI_LIBTIFF_EXTRACTED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/README
NTI_LIBTIFF_CONFIGURED=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/config.status
NTI_LIBTIFF_BUILT=${EXTTEMP}/${NTI_LIBTIFF_TEMP}/tools/tiffmedian
NTI_LIBTIFF_INSTALLED=${NTI_TC_ROOT}/usr/lib/libtiff.a
# [v4+] NTI_LIBTIFF_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libtiff-4.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBTIFF_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tiff-${LIBTIFF_VERSION} ] || rm -rf ${EXTTEMP}/tiff-${LIBTIFF_VERSION}
	zcat ${LIBTIFF_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBTIFF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTIFF_TEMP}
	mv ${EXTTEMP}/tiff-${LIBTIFF_VERSION} ${EXTTEMP}/${NTI_LIBTIFF_TEMP}


## ,-----
## |	Configure
## +-----

# libtiff has no dependencies to recover from pkg-config
${NTI_LIBTIFF_CONFIGURED}: ${NTI_LIBTIFF_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-cxx \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBTIFF_BUILT}: ${NTI_LIBTIFF_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBTIFF_INSTALLED}: ${NTI_LIBTIFF_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTIFF_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libtiff
nti-libtiff: ${NTI_LIBTIFF_INSTALLED}

ALL_NTI_TARGETS+= nti-libtiff

endif	# HAVE_LIBTIFF_CONFIG
