# swfdec v0.8.4			[ since v0.8.4, 2010-01-21 ]
# last mod WmT, 2010-01-21	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_SWFDEC_CONFIG},y)
HAVE_SWFDEC_CONFIG:=y

DESCRLIST+= "'htc-swfdec' -- swfdec"

SWFDEC_VER=0.8.4
SWFDEC_SRC=${SRCDIR}/s/swfdec-0.8.4.tar.gz

URLS+= http://swfdec.freedesktop.org/download/swfdec/0.8/swfdec-0.8.4.tar.gz

##	package extract

HTC_SWFDEC_TEMP=htc-swfdec-${SWFDEC_VER}

HTC_SWFDEC_EXTRACTED=${EXTTEMP}/${HTC_SWFDEC_TEMP}/configure

.PHONY: htc-swfdec-extracted

htc-swfdec-extracted: ${HTC_SWFDEC_EXTRACTED}

${HTC_SWFDEC_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${HTC_SWFDEC_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_SWFDEC_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${SWFDEC_SRC}
	mv ${EXTTEMP}/swfdec-${SWFDEC_VER} ${EXTTEMP}/${HTC_SWFDEC_TEMP}

##	package configure

HTC_SWFDEC_CONFIGURED=${EXTTEMP}/${HTC_SWFDEC_TEMP}/config.status

.PHONY: htc-swfdec-configured

htc-swfdec-configured: htc-swfdec-extracted ${HTC_SWFDEC_CONFIGURED}

${HTC_SWFDEC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${HTC_SWFDEC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

HTC_SWFDEC_BUILT=${EXTTEMP}/${HTC_SWFDEC_TEMP}/swfdec

.PHONY: htc-swfdec-built
htc-swfdec-built: htc-swfdec-configured ${HTC_SWFDEC_BUILT}

${HTC_SWFDEC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HTC_SWFDEC_TEMP} || exit 1 ;\
		make \
	)

##	package install

HTC_SWFDEC_INSTALLED=${HTC_ROOT}/usr/sbin/swfdec

.PHONY: htc-swfdec-installed

htc-swfdec-installed: htc-swfdec-built ${HTC_SWFDEC_INSTALLED}

${HTC_SWFDEC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${HTC_SWFDEC_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: htc-swfdec
htc-swfdec: htc-swfdec-installed

TARGETS+=htc-swfdec

endif	# HAVE_SWFDEC_CONFIG
