# xmp v3.2.0			[ since v3.2.0, c.2010-06-01 ]
# last mod WmT, 2010-06-01	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_XMP_CONFIG},y)
HAVE_XMP_CONFIG:=y

DESCRLIST+= "'htc-xmp' -- xmp"

XMP_VER=3.2.0
XMP_SRC=${SRCDIR}/x/xmp-3.2.0.tar.gz

URLS+= http://downloads.sourceforge.net/project/xmp/xmp/3.2.0/xmp-3.2.0.tar.gz?use_mirror=freefr

##	package extract

HTC_XMP_TEMP=htc-xmp-${XMP_VER}

HTC_XMP_EXTRACTED=${EXTTEMP}/${HTC_XMP_TEMP}/configure

.PHONY: htc-xmp-extracted

htc-xmp-extracted: ${HTC_XMP_EXTRACTED}

${HTC_XMP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${HTC_XMP_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_XMP_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${XMP_SRC}
	mv ${EXTTEMP}/xmp-${XMP_VER} ${EXTTEMP}/${HTC_XMP_TEMP}

##	package configure

HTC_XMP_CONFIGURED=${EXTTEMP}/${HTC_XMP_TEMP}/config.status

.PHONY: htc-xmp-configured

htc-xmp-configured: htc-xmp-extracted ${HTC_XMP_CONFIGURED}

${HTC_XMP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${HTC_XMP_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT}/usr \
			|| exit 1 \
	)

##	package build

HTC_XMP_BUILT=${EXTTEMP}/${HTC_XMP_TEMP}/xmp

.PHONY: htc-xmp-built
htc-xmp-built: htc-xmp-configured ${HTC_XMP_BUILT}

${HTC_XMP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HTC_XMP_TEMP} || exit 1 ;\
		make \
	)

##	package install

HTC_XMP_INSTALLED=${HTC_ROOT}/usr/sbin/xmp

.PHONY: htc-xmp-installed

htc-xmp-installed: htc-xmp-built ${HTC_XMP_INSTALLED}

${HTC_XMP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${HTC_XMP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: htc-xmp
htc-xmp: htc-xmp-installed

TARGETS+=htc-xmp

endif	# HAVE_XMP_CONFIG
