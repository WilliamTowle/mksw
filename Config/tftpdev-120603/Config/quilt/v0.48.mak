# quilt v0.48			[ since v0.48, c.2009-09-23 ]
# last mod WmT, 2009-09-23	[ (c) and GPLv2 1999-2009 ]

ifneq (${HAVE_QUILT_CONFIG},y)
HAVE_QUILT_CONFIG:=y

include ${CFG_ROOT}/diffstat/v1.47.mak

DESCRLIST+= "'htc-quilt' -- quilt"

QUILT_VER=0.48
QUILT_SRC=${SRCDIR}/q/quilt-0.48.tar.gz

URLS+=http://mirrors.aixtools.net/sv/quilt/quilt-0.48.tar.gz

##	package extract

HTC_QUILT_TEMP=htc-quilt-${QUILT_VER}

HTC_QUILT_EXTRACTED=${EXTTEMP}/${HTC_QUILT_TEMP}/configure

.PHONY: htc-quilt-extracted
htc-quilt-extracted: ${HTC_QUILT_EXTRACTED}

${HTC_QUILT_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${HTC_QUILT_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_QUILT_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${QUILT_SRC}
	mv ${EXTTEMP}/quilt-${QUILT_VER} ${EXTTEMP}/${HTC_QUILT_TEMP}

##	package configure

HTC_QUILT_CONFIGURED=${EXTTEMP}/${HTC_QUILT_TEMP}/config.status

.PHONY: htc-quilt-configured
htc-quilt-configured: htc-quilt-extracted ${HTC_QUILT_CONFIGURED}

${HTC_QUILT_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${HTC_QUILT_TEMP} || exit 1 ;\
	  ./configure \
	  	--prefix=${HTC_ROOT}/usr \
		|| exit 1 \
	)

##	package build

HTC_QUILT_BUILT=${EXTTEMP}/${HTC_QUILT_TEMP}/bin/quilt

.PHONY: htc-quilt-built
htc-quilt-built: htc-quilt-configured ${HTC_QUILT_BUILT}

${HTC_QUILT_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${HTC_QUILT_TEMP} || exit 1 ;\
		make \
	)

##	package install

HTC_QUILT_INSTALLED=${HTC_ROOT}/usr/bin/quilt

.PHONY: htc-quilt-installed
htc-quilt-installed: htc-quilt-built ${HTC_QUILT_INSTALLED}

${HTC_QUILT_INSTALLED}: ${HTC_QUILT_BUILT} ${HTC_ROOT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${HTC_QUILT_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: htc-quilt
htc-quilt: htc-diffstat htc-quilt-installed

TARGETS+= htc-quilt

endif	# HAVE_QUILT_CONFIG
