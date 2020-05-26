# libvterm v0.99.7		[ since v0.99.7, c.2017-03-28 ]
# last mod WmT, 2017-03-28	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBVTERM_CONFIG},y)
HAVE_LIBVTERM_CONFIG:=y

#DESCRLIST+= "'cti-libvterm' -- libvterm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


ifeq (${LIBVTERM_VERSION},)
LIBVTERM_VERSION:=0.99.7
endif

LIBVTERM_SRC=${SOURCES}/l/libvterm-${LIBVTERM_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/libvterm/libvterm-0.99.7.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibvterm%2Ffiles%2F&ts=1490708023&use_mirror=netcologne"

#include ${CFG_ROOT}/tui/gpm/v1.20.7.mak

NTI_LIBVTERM_TEMP=nti-libvterm-${LIBVTERM_VERSION}

#NTI_LIBVTERM_EXTRACTED=${EXTTEMP}/${NTI_LIBVTERM_TEMP}/LICENSE
NTI_LIBVTERM_EXTRACTED=${EXTTEMP}/${NTI_LIBVTERM_TEMP}/COPYING
NTI_LIBVTERM_CONFIGURED=${EXTTEMP}/${NTI_LIBVTERM_TEMP}/Makefile.OLD
NTI_LIBVTERM_BUILT=${EXTTEMP}/${NTI_LIBVTERM_TEMP}/libvterm.so
NTI_LIBVTERM_INSTALLED=${NTI_TC_ROOT}/usr/local/lib/libvterm.so


## ,-----
## |	Extract
## +-----

${NTI_LIBVTERM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/libvterm-${LIBVTERM_VERSION} ] || rm -rf ${EXTTEMP}/libvterm-${LIBVTERM_VERSION}
	[ ! -d ${EXTTEMP}/libvterm ] || rm -rf ${EXTTEMP}/libvterm
	zcat ${LIBVTERM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBVTERM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBVTERM_TEMP}
	#mv ${EXTTEMP}/libvterm-${LIBVTERM_VERSION} ${EXTTEMP}/${NTI_LIBVTERM_TEMP}
	mv ${EXTTEMP}/libvterm ${EXTTEMP}/${NTI_LIBVTERM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBVTERM_CONFIGURED}: ${NTI_LIBVTERM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVTERM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC = '${NTI_GCC}'\n%' \
			| sed '/^	/	s/g*cc/$$(CC)/' \
			| sed '/^prefix/	s%^%DESTDIR = '${NTI_TC_ROOT}'\n%' \
			| sed '/^includedir/	s%/usr%$$(prefix)%' \
			| sed '/^libdir/	s%/usr%$$(prefix)%' \
			| sed '/^	/	s%$$(includedir)/*%$$(DESTDIR)$$(includedir)/%' \
			| sed '/^	/	s%$$(libdir)/*%$$(DESTDIR)$$(libdir)/%' \
			| sed '/^	/	s%/usr/lib%$$(DESTDIR)/$$(libdir)%' \
			| sed '/ldconfig/	{ s/^	/	-/ ; s%-ldconfig%-/sbin/ldconfig% }' \
			> Makefile \
	)

#			| sed 's/PKG_CFG/PKG_CFLAGS/' \
#			| sed '/^PKG_CFLAGS/	s%=%= -I'${NTI_TC_ROOT}'/usr/include%' \



## ,-----
## |	Build
## +-----

${NTI_LIBVTERM_BUILT}: ${NTI_LIBVTERM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVTERM_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBVTERM_INSTALLED}: ${NTI_LIBVTERM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVTERM_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/include/' || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/lib/' || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libvterm
#nti-libvterm: nti-libtool nti-pkg-config \
#	${NTI_LIBVTERM_INSTALLED}
nti-libvterm: ${NTI_LIBVTERM_INSTALLED}

ALL_NTI_TARGETS+= nti-libvterm

endif	# HAVE_LIBVTERM_CONFIG
