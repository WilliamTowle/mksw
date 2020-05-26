#!usr/bin/make
# memtest86 v4.3.7		[ since v3.0, c.2003-07-05 ]
# last mod WmT, 2016-10-26	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_MEMTEST86_CONFIG},y)
HAVE_MEMTEST86_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MEMTEST86_VERSION},)
MEMTEST86_VERSION=4.3.7
endif

MEMTEST86_SRC= ${SOURCES}/m/memtest86_${MEMTEST86_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/memtest86/memtest86_4.3.7.orig.tar.gz

NTI_MEMTEST86_TEMP=		nti-memtest86-${MEMTEST86_VERSION}

NTI_MEMTEST86_EXTRACTED=	${EXTTEMP}/${NTI_MEMTEST86_TEMP}/Makefile
NTI_MEMTEST86_CONFIGURED=	${EXTTEMP}/${NTI_MEMTEST86_TEMP}/Makefile.OLD
NTI_MEMTEST86_BUILT=		${EXTTEMP}/${NTI_MEMTEST86_TEMP}/memtest.bin
NTI_MEMTEST86_INSTALLED=	${NTI_TC_ROOT}/usr/lib/memtest86/memtest.bin


## ,-----
## |	Extract
## +-----

${NTI_MEMTEST86_EXTRACTED}:
	[ ! -d ${EXTTEMP}/linux-${MEMTEST86_VERSION} ] || rm -rf ${EXTTEMP}/linux-${MEMTEST86_VERSION}
	zcat ${MEMTEST86_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MEMTEST86_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMTEST86_TEMP}
	#mv ${EXTTEMP}/memtest-${MEMTEST86_VERSION} ${EXTTEMP}/${NTI_MEMTEST86_TEMP}
	mv ${EXTTEMP}/src ${EXTTEMP}/${NTI_MEMTEST86_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MEMTEST86_CONFIGURED}: ${NTI_MEMTEST86_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CC=/		s%$$%\nLD='$(shell echo ${NTI_GCC} | sed 's/gcc$$/ld/')'%' \
			| sed '/^CFLAGS=/	s/-m32 //' \
			| sed '/^AS=/		s%as%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/as/')'%' \
			| sed '/^	/	s%objcopy%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/objcopy/')'%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_MEMTEST86_BUILT}: ${NTI_MEMTEST86_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		make memtest.bin \
	)


## ,-----
## |	Install
## +-----

${NTI_MEMTEST86_INSTALLED}: ${NTI_MEMTEST86_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/memtest86 || exit 1 ;\
		cp memtest.bin ${NTI_TC_ROOT}/usr/lib/memtest86/ \
	)

.PHONY: nti-memtest86
nti-memtest86: ${NTI_MEMTEST86_INSTALLED}

ALL_NTI_TARGETS+= nti-memtest86

endif	# HAVE_MEMTEST86_CONFIG

