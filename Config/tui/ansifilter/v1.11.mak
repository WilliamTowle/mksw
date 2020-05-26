# ansifilter v1.11		[ since v1.11, c. 2014-12-10 ]
# last mod WmT, 2014-12-10	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_ANSIFILTER_CONFIG},y)
HAVE_ANSIFILTER_CONFIG:=y

#DESCRLIST+= "'nti-ansifilter' -- ansifilter"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ANSIFILTER_VERSION},)
ANSIFILTER_VERSION=1.11
endif

ANSIFILTER_SRC=${SOURCES}/a/ansifilter-${ANSIFILTER_VERSION}.tar.gz
URLS+= http://andre-simon.de/zip/ansifilter-1.11.tar.gz
#ANSIFILTER_PATCHES=${CFG_ROOT}/tui/ansifilter/FOO.patch
#URLS+= 

##include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak

NTI_ANSIFILTER_TEMP=nti-ansifilter-${ANSIFILTER_VERSION}

NTI_ANSIFILTER_EXTRACTED=${EXTTEMP}/${NTI_ANSIFILTER_TEMP}/README
NTI_ANSIFILTER_CONFIGURED=${EXTTEMP}/${NTI_ANSIFILTER_TEMP}/Makefile
NTI_ANSIFILTER_BUILT=${EXTTEMP}/${NTI_ANSIFILTER_TEMP}/src/ansifilter
NTI_ANSIFILTER_INSTALLED=${NTI_TC_ROOT}/usr/bin/ansifilter


## ,-----
## |	Extract
## +-----

${NTI_ANSIFILTER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ansifilter-${ANSIFILTER_VERSION} ] || rm -rf ${EXTTEMP}/ansifilter-${ANSIFILTER_VERSION}
	zcat ${ANSIFILTER_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${ANSIFILTER_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${ANSIFILTER_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} || exit 1 ;\
			patch --batch -d ansifilter-${ANSIFILTER_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_ANSIFILTER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ANSIFILTER_TEMP}
	mv ${EXTTEMP}/ansifilter-${ANSIFILTER_VERSION} ${EXTTEMP}/${NTI_ANSIFILTER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ANSIFILTER_CONFIGURED}: ${NTI_ANSIFILTER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ANSIFILTER_TEMP} || exit 1 ;\
		[ -r makefile.OLD ] || mv makefile makefile.OLD || exit 1 ;\
		cat makefile.OLD \
			| sed '/^PREFIX/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_ANSIFILTER_BUILT}: ${NTI_ANSIFILTER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ANSIFILTER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ANSIFILTER_INSTALLED}: ${NTI_ANSIFILTER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ANSIFILTER_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ansifilter
nti-ansifilter: ${NTI_ANSIFILTER_INSTALLED}
#nti-ansifilter: nti-ncurses ${NTI_ANSIFILTER_INSTALLED}

ALL_NTI_TARGETS+= nti-ansifilter

endif	# HAVE_ANSIFILTER_CONFIG
