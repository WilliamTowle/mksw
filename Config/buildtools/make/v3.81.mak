# make v3.81			[ EARLIEST v?.?? ]
# last mod WmT, 2012-08-31	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_MAKE_CONFIG},y)
HAVE_MAKE_CONFIG:=y

#DESCRLIST+= "'nti-make' -- make"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MAKE_VERSION},)
MAKE_VERSION=3.81
endif

MAKE_SRC=${SOURCES}/m/make-${MAKE_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/make/make-${MAKE_VERSION}.tar.bz2


NTI_MAKE_TEMP=nti-make-${MAKE_VERSION}

NTI_MAKE_EXTRACTED=${EXTTEMP}/${NTI_MAKE_TEMP}/Makefile
NTI_MAKE_CONFIGURED=${EXTTEMP}/${NTI_MAKE_TEMP}/config.log
NTI_MAKE_BUILT=${EXTTEMP}/${NTI_MAKE_TEMP}/make
NTI_MAKE_INSTALLED=${NTI_TC_ROOT}/usr/bin/make


## ,-----
## |	Extract
## +-----

${NTI_MAKE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/make-${MAKE_VERSION} ] || rm -rf ${EXTTEMP}/make-${MAKE_VERSION}
	bzcat ${MAKE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MAKE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MAKE_TEMP}
	mv ${EXTTEMP}/make-${MAKE_VERSION} ${EXTTEMP}/${NTI_MAKE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MAKE_CONFIGURED}: ${NTI_MAKE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MAKE_BUILT}: ${NTI_MAKE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_MAKE_INSTALLED}: ${NTI_MAKE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-make
nti-make: ${NTI_MAKE_INSTALLED}

ALL_NTI_TARGETS+= nti-make

endif	# HAVE_MAKE_CONFIG
