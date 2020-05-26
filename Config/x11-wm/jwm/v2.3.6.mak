# jwm v2.3.6			[ since v2.0.1, c.2011-08-12 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_JWM_CONFIG},y)
HAVE_JWM_CONFIG:=y

#DESCRLIST+= "'cui-jwm' -- jwm"

ifeq (${JWM_VERSION},)
#JWM_VERSION=2.0.1
#JWM_VERSION=2.1.0
#JWM_VERSION=2.2.2
JWM_VERSION=2.3.6
endif

#JWM_SRC=${SOURCES}/j/jwm-${JWM_VERSION}.tar.bz2
JWM_SRC=${SOURCES}/j/jwm-${JWM_VERSION}.tar.xz
#URLS+= http://joewing.net/programs/jwm/releases/jwm-${JWM_VERSION}.tar.bz2
URLS+= http://joewing.net/programs/jwm/releases/jwm-${JWM_VERSION}.tar.xz

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
##include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak


NTI_JWM_TEMP=nti-jwm-${JWM_VERSION}
NTI_JWM_EXTRACTED=${EXTTEMP}/${NTI_JWM_TEMP}/configure
NTI_JWM_CONFIGURED=${EXTTEMP}/${NTI_JWM_TEMP}/src/Makefile.OLD
NTI_JWM_BUILT=${EXTTEMP}/${NTI_JWM_TEMP}/src/jwm
NTI_JWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/jwm


# ,-----
# |	Extract
# +-----

#	CUI_JWM_TEMP=cui-jwm-${JWM_VERSION}
#	CUI_JWM_INSTTEMP=${EXTTEMP}/insttemp
#	
#	CUI_JWM_EXTRACTED=${EXTTEMP}/${CUI_JWM_TEMP}/configure
#	
#	.PHONY: cui-jwm-extracted
#	
#	cui-jwm-extracted: ${CUI_JWM_EXTRACTED}
#	
#	${CUI_JWM_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${CUI_JWM_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_JWM_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${JWM_SRC}
#		mv ${EXTTEMP}/jwm-${JWM_VERSION} ${EXTTEMP}/${CUI_JWM_TEMP}


${NTI_JWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/jwm-${JWM_VERSION} ] || rm -rf ${EXTTEMP}/jwm-${JWM_VERSION}
	#bzcat ${JWM_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${JWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_JWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_JWM_TEMP}
	mv ${EXTTEMP}/jwm-${JWM_VERSION} ${EXTTEMP}/${NTI_JWM_TEMP}


# ,-----
# |	Configure
# +-----

#	#CUI_JWM_CONFIGURED=${EXTTEMP}/${CUI_JWM_TEMP}/config.status
#	CUI_JWM_CONFIGURED=${EXTTEMP}/${CUI_JWM_TEMP}/src/Makefile.OLD
#	
#	.PHONY: cui-jwm-configured
#	
#	cui-jwm-configured: cui-jwm-extracted ${CUI_JWM_CONFIGURED}
#	
#	${CUI_JWM_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
#			./configure \
#				--prefix=${CUI_TC_ROOT}/usr \
#				--disable-fribidi \
#				--disable-jpeg \
#				--disable-png \
#				--disable-shape \
#				--disable-xinerama \
#				--disable-xft \
#				--disable-xpm \
#				--disable-xrender \
#			  CC=${CUI_GCC} \
#			  CFLAGS='-O2' \
#				|| exit 1 ;\
#			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#			cat Makefile.OLD \
#				| sed '/	install/	s%$$(MANDIR)%$$(DESTDIR)/&%' \
#				| sed '/	install/	s%$$(SYSCONF)%$$(DESTDIR)/&%' \
#				> Makefile || exit 1 ;\
#			[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
#			cat src/Makefile.OLD \
#				| sed '/^CC[ 	]/	s%g*cc%'${CTI_GCC}'%' \
#				| sed '/^CFLAGS[ 	]/	s%I/usr%I'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr%g' \
#				| sed '/^LDFLAGS[ 	]/	s%L/usr%L'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr%g' \
#				| sed '/	install/	s%$$(BINDIR)%$$(DESTDIR)/&%' \
#				> src/Makefile || exit 1 \
#		)

# [2013-01-12, v2.1.0] added --disable-xmu due to missing CORNER_RADIUS in status.c
# [2013-03-26, v2.1.0] trying PKGCONFIG= for locating X11 (...fails)

${NTI_JWM_CONFIGURED}: ${NTI_JWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_JWM_TEMP} || exit 1 ;\
		PKGCONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  CFLAGS='-O2' \
		  LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib \
			--disable-fribidi \
			--disable-jpeg \
			--disable-png \
			--disable-shape \
			--disable-xinerama \
			--disable-xft \
			--disable-xmu \
			--disable-xpm \
			--disable-xrender \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/	install/	s%$$(MANDIR)%$$(DESTDIR)/&%' \
			| sed '/	install/	s%$$(SYSCONF)%$$(DESTDIR)/&%' \
			> Makefile || exit 1 ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/	install/	s%$$(BINDIR)%$$(DESTDIR)/&%' \
			> src/Makefile || exit 1 \
	)


# ,-----
# |	Build
# +-----

#	CUI_JWM_BUILT=${EXTTEMP}/${CUI_JWM_TEMP}/src/jwm
#	
#	.PHONY: cui-jwm-built
#	cui-jwm-built: cui-jwm-configured ${CUI_JWM_BUILT}
#	
#	${CUI_JWM_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
#			make \
#		)

${NTI_JWM_BUILT}: ${NTI_JWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_JWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

#	CUI_JWM_INSTALLED=${CUI_TC_ROOT}/usr/bin/jwm
#	
#	.PHONY: cui-jwm-installed
#	
#	cui-jwm-installed: cui-jwm-built ${CUI_JWM_INSTALLED}
#	
#	${CUI_JWM_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
#			make install \
#				DESTDIR=${CUI_JWM_INSTTEMP} \
#				|| exit 1 \
#		)
#	
#	.PHONY: cui-jwm
#	cui-jwm: cti-cross-gcc cti-libX11 cui-uClibc-rt cui-jwm-installed
#	
#	CTARGETS+= cui-jwm


${NTI_JWM_INSTALLED}: ${NTI_JWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_JWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

#.PHONY: nti-jwm
#nti-jwm: nti-libX11 ${NTI_JWM_INSTALLED}
.PHONY: nti-jwm
nti-jwm: ${NTI_JWM_INSTALLED}

ALL_NTI_TARGETS+= nti-jwm

endif	# HAVE_JWM_CONFIG
