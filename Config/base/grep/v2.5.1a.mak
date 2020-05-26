# grep v2.5.1a			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2010-05-04	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_GREP_CONFIG},y)
HAVE_GREP_CONFIG:=y

DESCRLIST+= "'htc-grep' -- host-toolchain grep"

include ${CFG_ROOT}/diffutils/v2.8.7.mak

GREP_VER=2.5.1a
GREP_SRC=${SRCDIR}/g/grep-${GREP_VER}.tar.bz2

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/grep/grep-2.5.1a.tar.bz2

HTC_GREP_TEMP=htc-grep-${GREP_VER}


## ,-----
## |	package extract
## +-----

HTC_GREP_EXTRACTED=${EXTTEMP}/${HTC_GREP_TEMP}/Makefile.am

.PHONY: htc-grep-extracted
htc-grep-extracted: ${HTC_GREP_EXTRACTED}

${HTC_GREP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	make -C ${TOPLEV} extract ARCHIVE=${GREP_SRC}
	mv ${EXTTEMP}/grep-${GREP_VER} ${EXTTEMP}/${HTC_GREP_TEMP}


## ,-----
## |	package configure
## +-----

HTC_GREP_CONFIGURED=${EXTTEMP}/${HTC_GREP_TEMP}/config.status

.PHONY: htc-grep-configured
htc-grep-configured: htc-grep-extracted ${HTC_GREP_CONFIGURED}

${HTC_GREP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
	  ./configure \
	  	--prefix=${HTC_ROOT} \
		|| exit 1 \
	)


## ,-----
## |	package built
## +-----

HTC_GREP_BUILT=${EXTTEMP}/${HTC_GREP_TEMP}/src/grep

.PHONY: htc-grep-built
htc-grep-built: htc-grep-configured ${HTC_GREP_BUILT}

${HTC_GREP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
		make \
	)

##	package install

HTC_GREP_INSTALLED=${HTC_ROOT}/bin/grep

.PHONY: htc-grep-installed
htc-grep-installed: htc-grep-built ${HTC_GREP_INSTALLED}

${HTC_GREP_INSTALLED}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HTC_GREP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: htc-grep
htc-grep: htc-diffutils htc-grep-installed

endif	# HAVE_GREP_CONFIG
