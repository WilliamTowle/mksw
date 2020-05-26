# grep v2.18			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-04	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_GREP_CONFIG},y)
HAVE_GREP_CONFIG:=y

#DESCRLIST+= "'nti-grep' -- grep"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GREP_VERSION},)
#GREP_VER=2.5.1a
GREP_VERSION=2.18
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
			--prefix=${NTI_TC_ROOT} \
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

#ifneq (${HAVE_GREP_CONFIG},y)
#HAVE_GREP_CONFIG:=y
#
#DESCRLIST+= "'htc-grep' -- host-toolchain grep"
#
#include ${CFG_ROOT}/diffutils/v2.8.7.mak
#
#GREP_VER=2.5.1a
#GREP_VER=2.18
#GREP_SRC=${SRCDIR}/g/grep-${GREP_VER}.tar.bz2
#
#URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/grep/grep-2.5.1a.tar.bz2
#
#HTC_GREP_TEMP=htc-grep-${GREP_VER}
#
#
### ,-----
### |	package extract
### +-----
#
#HTC_GREP_EXTRACTED=${EXTTEMP}/${HTC_GREP_TEMP}/Makefile.am
#
#.PHONY: htc-grep-extracted
#htc-grep-extracted: ${HTC_GREP_EXTRACTED}
#
#${HTC_GREP_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	make -C ${TOPLEV} extract ARCHIVE=${GREP_SRC}
#	mv ${EXTTEMP}/grep-${GREP_VER} ${EXTTEMP}/${HTC_GREP_TEMP}
#
#
### ,-----
### |	package configure
### +-----
#
#HTC_GREP_CONFIGURED=${EXTTEMP}/${HTC_GREP_TEMP}/config.status
#
#.PHONY: htc-grep-configured
#htc-grep-configured: htc-grep-extracted ${HTC_GREP_CONFIGURED}
#
#${HTC_GREP_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
#	  ./configure \
#	  	--prefix=${HTC_ROOT} \
#		|| exit 1 \
#	)
#
#
### ,-----
### |	package built
### +-----
#
#HTC_GREP_BUILT=${EXTTEMP}/${HTC_GREP_TEMP}/src/grep
#
#.PHONY: htc-grep-built
#htc-grep-built: htc-grep-configured ${HTC_GREP_BUILT}
#
#${HTC_GREP_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
#		make \
#	)
#
###	package install
#
#HTC_GREP_INSTALLED=${HTC_ROOT}/bin/grep
#
#.PHONY: htc-grep-installed
#htc-grep-installed: htc-grep-built ${HTC_GREP_INSTALLED}
#
#${HTC_GREP_INSTALLED}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: htc-grep
#htc-grep: htc-diffutils htc-grep-installed
#
#endif	# HAVE_GREP_CONFIG
