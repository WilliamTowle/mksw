# grep v2.20			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-09-18	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_GREP_CONFIG},y)
HAVE_GREP_CONFIG:=y

#DESCRLIST+= "'nti-grep' -- grep"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GREP_VERSION},)
#GREP_VER=2.5.1a
#GREP_VERSION=2.18
GREP_VERSION=2.20
endif

GREP_SRC=${SOURCES}/g/grep-${GREP_VERSION}.tar.bz2
GREP_SRC=${SOURCES}/g/grep-${GREP_VERSION}.tar.xz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/grep/grep-${GREP_VERSION}.tar.xz

# FIXME: some (which?) versions have 'diffutils' dependency

NTI_GREP_TEMP=nti-grep-${GREP_VERSION}

NTI_GREP_EXTRACTED=${EXTTEMP}/${NTI_GREP_TEMP}/configure
NTI_GREP_CONFIGURED=${EXTTEMP}/${NTI_GREP_TEMP}/config.status
NTI_GREP_BUILT=${EXTTEMP}/${NTI_GREP_TEMP}/src/grep
NTI_GREP_INSTALLED=${NTI_TC_ROOT}/bin/grep


## ,-----
## |	Extract
## +-----

${NTI_GREP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/grep-${GREP_VERSION} ] || rm -rf ${EXTTEMP}/grep-${GREP_VERSION}
	#bzcat ${GREP_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${GREP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GREP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GREP_TEMP}
	mv ${EXTTEMP}/grep-${GREP_VERSION} ${EXTTEMP}/${NTI_GREP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_GREP_CONFIGURED}: ${NTI_GREP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GREP_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--exec-prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_GREP_BUILT}: ${NTI_GREP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GREP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_GREP_INSTALLED}: ${NTI_GREP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GREP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-grep
nti-grep: ${NTI_GREP_INSTALLED}

ALL_NTI_TARGETS+= nti-grep

endif	# HAVE_GREP_CONFIG
