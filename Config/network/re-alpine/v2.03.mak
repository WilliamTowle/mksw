# realpine v2.03		[ since v2.03, c.2017-03-03 ]
# last mod WmT, 2017-03-03	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_RE_ALPINE_CONFIG},y)
HAVE_RE_ALPINE_CONFIG:=y

#DESCRLIST+= "'nti-re-alpine' -- re-alpine"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${RE_ALPINE_VERSION},)
RE_ALPINE_VERSION=2.03
endif

RE_ALPINE_SRC=${SOURCES}/r/re-alpine-${RE_ALPINE_VERSION}.tar.bz2
URLS+= "https://downloads.sourceforge.net/project/re-alpine/re-alpine-2.03.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fre-alpine%2F&ts=1488554090&use_mirror=superb-dca2"

NTI_RE_ALPINE_TEMP=nti-realpine-${RE_ALPINE_VERSION}

NTI_RE_ALPINE_EXTRACTED=${EXTTEMP}/${NTI_RE_ALPINE_TEMP}/VERSION
NTI_RE_ALPINE_CONFIGURED=${EXTTEMP}/${NTI_RE_ALPINE_TEMP}/Makefile.OLD
NTI_RE_ALPINE_BUILT=${EXTTEMP}/${NTI_RE_ALPINE_TEMP}/src/realpine
NTI_RE_ALPINE_INSTALLED=${NTI_TC_ROOT}/usr/sbin/realpine


## ,-----
## |	Extract
## +-----

${NTI_RE_ALPINE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/re-alpine-${RE_ALPINE_VERSION} ] || rm -rf ${EXTTEMP}/re-alpine-${RE_ALPINE_VERSION}
	bzcat ${RE_ALPINE_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${RE_ALPINE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_RE_ALPINE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_RE_ALPINE_TEMP}
	mv ${EXTTEMP}/re-alpine-${RE_ALPINE_VERSION} ${EXTTEMP}/${NTI_RE_ALPINE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_RE_ALPINE_CONFIGURED}: ${NTI_RE_ALPINE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RE_ALPINE_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_RE_ALPINE_BUILT}: ${NTI_RE_ALPINE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RE_ALPINE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_RE_ALPINE_INSTALLED}: ${NTI_RE_ALPINE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RE_ALPINE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-realpine
nti-realpine: ${NTI_RE_ALPINE_INSTALLED}

ALL_NTI_TARGETS+= nti-realpine

endif	# HAVE_RE_ALPINE_CONFIG
