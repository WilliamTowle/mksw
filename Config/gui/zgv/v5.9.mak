# zgv v5.9			[ EARLIEST v?.?? ]
# last mod WmT, 2014-07-01	[ (c) and GPLv2 1999-2014* ]

#	# zgv v5.9			[ since v5.9, c. 2005-02-07 ]
#	# last mod WmT, 2011-08-29	[ (c) and GPLv2 1999-2011 ]
#	
#	ifneq (${HAVE_ZGV_CONFIG},y)
#	HAVE_ZGV_CONFIG:=y
#	
#	DESCRLIST+= "'nti-zgv' -- zgv"
#	
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	ifeq (${ACTION},buildn)
#	include ${CFG_ROOT}/ENV/native.mak
#	else
#	include ${CFG_ROOT}/ENV/target.mak
#	endif
#	
#	ifeq (${ACTION},buildn)
#	include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#	endif
#	include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak
#	include ${CFG_ROOT}/distrotools-legacy/jpegsrc/v8c.mak
#	include ${CFG_ROOT}/distrotools-legacy/libtiff/v3.9.5.mak
#	include ${CFG_ROOT}/distrotools-legacy/libpng/v1.6.34.mak
#	
#	
#	ZGV_VER=5.9
#	ZGV_SRC=${SRCDIR}/z/zgv-5.9.tar.gz
#	
#	
#	
#	## ,-----
#	## |	Extract
#	## +-----
#	
#	
#	NTI_ZGV_TEMP=nti-zgv-${ZGV_VER}
#	NTI_ZGV_EXTRACTED=${EXTTEMP}/${NTI_ZGV_TEMP}/Makefile
#	
#	CUI_ZGV_TEMP=cui-zgv-${ZGV_VER}
#	CUI_ZGV_EXTRACTED=${EXTTEMP}/${CUI_ZGV_TEMP}/Makefile
#	CUI_ZGV_INSTTEMP=${EXTTEMP}/insttemp
#	
#	##
#	
#	.PHONY: nti-zgv-extracted
#	
#	nti-zgv-extracted: ${NTI_ZGV_EXTRACTED}
#	
#	${NTI_ZGV_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${NTI_ZGV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZGV_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${ZGV_SRC}
#		mv ${EXTTEMP}/zgv-${ZGV_VER} ${EXTTEMP}/${NTI_ZGV_TEMP}
#	
#	##
#	
#	.PHONY: cui-zgv-extracted
#	
#	cui-zgv-extracted: ${CUI_ZGV_EXTRACTED}
#	
#	${CUI_ZGV_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${CUI_ZGV_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_ZGV_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${ZGV_SRC}
#		mv ${EXTTEMP}/zgv-${ZGV_VER} ${EXTTEMP}/${CUI_ZGV_TEMP}
#	
#	
#	## ,-----
#	## |	Configure
#	## +-----
#	
#	
#	.PHONY: nti-zgv-configured
#	
#	nti-zgv-configured: nti-zgv-extracted ${NTI_ZGV_CONFIGURED}
#	
#	${NTI_ZGV_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
#		)
#	
#	##
#	
#	CUI_ZGV_CONFIGURED=${EXTTEMP}/${CUI_ZGV_TEMP}/src/zgv_io.c.OLD
#	
#	.PHONY: cui-zgv-configured
#	
#	cui-zgv-configured: cui-zgv-extracted ${CUI_ZGV_CONFIGURED}
#	
#	${CUI_ZGV_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CUI_ZGV_TEMP} || exit 1 ;\
#			[ -r config.mk.OLD ] || mv config.mk config.mk.OLD || exit 1 ;\
#			cat config.mk.OLD \
#				| sed '/^CC/		s%g*cc%'${CTI_GCC}'%' \
#				| sed '/BACKEND=SVGALIB/ s/^#*//' \
#				| sed '/BACKEND=SDL/	s/^/#/' \
#				| sed '/^PREFIX=/	s%/usr/local%'${CTI_TC_ROOT}'/usr%' \
#				> config.mk ;\
#			[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
#			cat src/Makefile.OLD \
#				| sed '/^CFLAGS+=/	s%/usr/local%'${CTI_TC_ROOT}'/usr%' \
#				| sed '/^ZGV_LIBS=/	s%/usr/local%'${CTI_TC_ROOT}'/usr%' \
#				| sed '/^	/	s%$$(BINDIR)%$${DESTDIR}/$$(BINDIR)%' \
#				> src/Makefile ;\
#			[ -r src/zgv_io.c.OLD ] || mv src/zgv_io.c src/zgv_io.c.OLD || exit 1 ;\
#			cat src/zgv_io.c.OLD \
#				| sed '/stop complaints/ s/^/break;/' \
#				> src/zgv_io.c \
#		)
#	
#	
#	## ,-----
#	## |	Build
#	## +-----
#	
#	NTI_ZGV_BUILT=${EXTTEMP}/${NTI_ZGV_TEMP}/zgv
#	
#	.PHONY: nti-zgv-built
#	nti-zgv-built: nti-zgv-configured ${NTI_ZGV_BUILT}
#	
#	${NTI_ZGV_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
#			make \
#		)
#	
#	##
#	
#	CUI_ZGV_BUILT=${EXTTEMP}/${CUI_ZGV_TEMP}/zgv
#	
#	.PHONY: cui-zgv-built
#	cui-zgv-built: cui-zgv-configured ${CUI_ZGV_BUILT}
#	
#	${CUI_ZGV_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CUI_ZGV_TEMP} || exit 1 ;\
#			make -C src CC=${NTI_GCC} bdf2h install-info || exit 1 ;\
#			make CC=${CTI_GCC} \
#		)
#	
#	
#	## ,-----
#	## |	Install
#	## +-----
#	
#	NTI_ZGV_INSTALLED=${NTI_TC_ROOT}/usr/bin/zgv
#	
#	.PHONY: nti-zgv-installed
#	
#	nti-zgv-installed: nti-zgv-built ${NTI_ZGV_INSTALLED}
#	
#	${NTI_ZGV_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		for SD in /usr/man /usr/info ; do \
#			mkdir -p ${NTI_TC_ROOT}/$${SD} || exit 1 ;\
#		done
#		( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
#			make RM="echo NOT DOING rm" install \
#		)
#	
#	##
#	
#	CUI_ZGV_INSTALLED=${CUI_ZGV_INSTTEMP}/usr/bin/zgv
#	
#	.PHONY: cui-zgv-installed
#	
#	cui-zgv-installed: cui-zgv-built ${CUI_ZGV_INSTALLED}
#	
#	${CUI_ZGV_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		for SD in /usr/man /usr/info ; do \
#			mkdir -p ${CUI_ZGV_INSTTEMP}/$${SD} || exit 1 ;\
#		done
#		( cd ${EXTTEMP}/${CUI_ZGV_TEMP} || exit 1 ;\
#			make RM="echo NOT DOING rm" install \
#		)
#	
#	##
#	
#	.PHONY: nti-zgv
#	nti-zgv: nti-native-gcc nti-SDL nti-jpegsrc nti-tiff nti-libpng nti-zgv-installed
#	
#	NTARGETS+= nti-zgv
#	
#	.PHONY: cui-zgv
#	cui-zgv: cti-cross-gcc cti-svgalib cti-jpegsrc cti-tiff cti-libpng cui-uClibc-rt cui-zgv-installed
#	
#	CTARGETS+= cui-zgv
#	
#	endif	# HAVE_ZGV_CONFIG

ifneq (${HAVE_ZGV_CONFIG},y)
HAVE_ZGV_CONFIG:=y

#DESCRLIST+= "'nti-zgv' -- zgv"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ZGV_VERSION},)
ZGV_VERSION=5.9
endif

#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
include ${CFG_ROOT}/audvid/libpng/v1.2.51.mak
#include ${CFG_ROOT}/audvid/libpng/v1.4.13.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.10.mak
include ${CFG_ROOT}/audvid/libtiff/v3.9.7.mak
#include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak

ZGV_SRC=${SOURCES}/z/zgv-${ZGV_VERSION}.tar.gz
URLS+= http://www.svgalib.org/rus/zgv/zgv-5.9.tar.gz

NTI_ZGV_TEMP=nti-zgv-${ZGV_VERSION}

NTI_ZGV_EXTRACTED=${EXTTEMP}/${NTI_ZGV_TEMP}/Makefile
NTI_ZGV_CONFIGURED=${EXTTEMP}/${NTI_ZGV_TEMP}/src/zgv_io.c.OLD
NTI_ZGV_BUILT=${EXTTEMP}/${NTI_ZGV_TEMP}/src/zgv
NTI_ZGV_INSTALLED=${NTI_TC_ROOT}/usr/bin/zgv-sdl


## ,-----
## |	Extract
## +-----

${NTI_ZGV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/zgv-${ZGV_VERSION} ] || rm -rf ${EXTTEMP}/zgv-${ZGV_VERSION}
	zcat ${ZGV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZGV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZGV_TEMP}
	mv ${EXTTEMP}/zgv-${ZGV_VERSION} ${EXTTEMP}/${NTI_ZGV_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ZGV_CONFIGURED}: ${NTI_ZGV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
		[ -r config.mk.OLD ] || mv config.mk config.mk.OLD || exit 1 ;\
		cat config.mk.OLD \
			| sed '/BACKEND=SVGALIB/ s/^/#/' \
			| sed '/BACKEND=SDL/	s/^#*//' \
			| sed '/^PREFIX=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> config.mk ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CFLAGS+=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^ZGV_LIBS=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/	s%$$(BINDIR)%$${DESTDIR}/$$(BINDIR)%' \
			> src/Makefile ;\
		[ -r src/zgv_io.c.OLD ] || mv src/zgv_io.c src/zgv_io.c.OLD || exit 1 ;\
		cat src/zgv_io.c.OLD \
			| sed '/stop complaints/ s/^/break;/' \
			> src/zgv_io.c \
	)
# [ config.mk ] | sed '/^CC/		s%g*cc%'${NTI_GCC}'%'


## ,-----
## |	Build
## +-----

${NTI_ZGV_BUILT}: ${NTI_ZGV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ZGV_INSTALLED}: ${NTI_ZGV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	mkdir -p ${NTI_TC_ROOT}/usr/info ${NTI_TC_ROOT}/usr/man
	( cd ${EXTTEMP}/${NTI_ZGV_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-zgv
nti-zgv: nti-SDL nti-jpegsrc nti-libpng nti-libtiff ${NTI_ZGV_INSTALLED}

ALL_NTI_TARGETS+= nti-zgv

endif	# HAVE_ZGV_CONFIG
