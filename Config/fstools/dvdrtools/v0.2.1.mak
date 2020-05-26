#!usr/bin/make
## dvdrtools 0.2.1		[ since v0.3.1, 2009-01-26 ]
## last mod WmT, 2012-08-11	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_DVDRTOOLS_CONFIG},y)
HAVE_DVDRTOOLS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DVDRTOOLS_VERSION},)
DVDRTOOLS_VERSION=0.2.1
endif

DVDRTOOLS_SRC= ${SOURCES}/d/dvdrtools-${DVDRTOOLS_VERSION}.tar.bz2
URLS+= https://download-mirror.savannah.gnu.org/releases/dvdrtools/dvdrtools-0.2.1.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/multiverse/d/dvdrtools/dvdrtools_0.3.1.orig.tar.gz

NTI_DVDRTOOLS_TEMP=		nti-dvdrtools-${DVDRTOOLS_VERSION}

NTI_DVDRTOOLS_EXTRACTED=	${EXTTEMP}/${NTI_DVDRTOOLS_TEMP}/Makefile.in
NTI_DVDRTOOLS_CONFIGURED=	${EXTTEMP}/${NTI_DVDRTOOLS_TEMP}/Makefile
NTI_DVDRTOOLS_BUILT=		${EXTTEMP}/${NTI_DVDRTOOLS_TEMP}/readcd/readcd
NTI_DVDRTOOLS_INSTALLED=	${NTI_TC_ROOT}/usr/bin/mkisofs


## ,-----
## |	Extract
## +-----

${NTI_DVDRTOOLS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/dvdrtools-${DVDRTOOLS_VERSION} ] || rm -rf ${EXTTEMP}/dvdrtools-${DVDRTOOLS_VERSION}
	bzcat ${DVDRTOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP}
	mv ${EXTTEMP}/dvdrtools-${DVDRTOOLS_VERSION} ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DVDRTOOLS_CONFIGURED}: ${NTI_DVDRTOOLS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP} || exit 1 ;\
	  	CC=${NTI_GCC} \
	    	  CFLAGS=-O2 \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
		case ${DVDRTOOLS_VERSION} in \
		0.2.1) \
			[ -r readcd/readcd.c.OLD ] || mv readcd/readcd.c readcd/readcd.c.OLD || exit 1 ;\
			cat readcd/readcd.c.OLD \
				| sed 's/clone/opt_clone/' \
				> readcd/readcd.c \
		;; \
		esac \
	) || exit 1


## ,-----
## |	Build
## +-----

${NTI_DVDRTOOLS_BUILT}: ${NTI_DVDRTOOLS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP} || exit 1 ;\
		make || exit 1 \
	)


## ,-----
## |	Install
## +-----

# TODO: install to $INSTTEMP...
${NTI_DVDRTOOLS_INSTALLED}: ${NTI_DVDRTOOLS_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DVDRTOOLS_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

##

.PHONY: nti-dvdrtools
nti-dvdrtools: ${NTI_DVDRTOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-dvdrtools

endif	# HAVE_DVDRTOOLS_CONFIG
