# swftools v0.9.0/devel		[ since v0.9.0 2010-01-21 ]
# last mod WmT, 2010-01-21	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_SWFTOOLS_CONFIG},y)
HAVE_SWFTOOLS_CONFIG:=y

DESCRLIST+= "'htc-swftools' -- swftools"

SWFTOOLS_VER=2009-08-24-2042
SWFTOOLS_SRC=${SRCDIR}/s/swftools-2009-08-24-2042.tar.gz

URLS+= http://www.swftools.org/swftools-2009-08-24-2042.tar.gz

##	package extract

HTC_SWFTOOLS_TEMP=htc-swftools-${SWFTOOLS_VER}

HTC_SWFTOOLS_EXTRACTED=${EXTTEMP}/${HTC_SWFTOOLS_TEMP}/configure

.PHONY: htc-swftools-extracted

htc-swftools-extracted: ${HTC_SWFTOOLS_EXTRACTED}

${HTC_SWFTOOLS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${HTC_SWFTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_SWFTOOLS_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${SWFTOOLS_SRC}
	mv ${EXTTEMP}/swftools-${SWFTOOLS_VER} ${EXTTEMP}/${HTC_SWFTOOLS_TEMP}

##	package configure

HTC_SWFTOOLS_CONFIGURED=${EXTTEMP}/${HTC_SWFTOOLS_TEMP}/config.status

.PHONY: htc-swftools-configured

htc-swftools-configured: htc-swftools-extracted ${HTC_SWFTOOLS_CONFIGURED}

${HTC_SWFTOOLS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${HTC_SWFTOOLS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

HTC_SWFTOOLS_BUILT=${EXTTEMP}/${HTC_SWFTOOLS_TEMP}/swftools

.PHONY: htc-swftools-built
htc-swftools-built: htc-swftools-configured ${HTC_SWFTOOLS_BUILT}

${HTC_SWFTOOLS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HTC_SWFTOOLS_TEMP} || exit 1 ;\
		make \
	)

##	package install

HTC_SWFTOOLS_INSTALLED=${HTC_ROOT}/usr/sbin/swftools

.PHONY: htc-swftools-installed

htc-swftools-installed: htc-swftools-built ${HTC_SWFTOOLS_INSTALLED}

${HTC_SWFTOOLS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${HTC_SWFTOOLS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: htc-swftools
htc-swftools: htc-swftools-installed

TARGETS+=htc-swftools

endif	# HAVE_SWFTOOLS_CONFIG
