# debootstrap v1.0.20		[ since v1.0.20, c.2010-08-10 ]
# last mod WmT, 2010-08-10	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_DEBOOTSTRAP_CONFIG},y)
HAVE_DEBOOTSTRAP_CONFIG:=y

DESCRLIST+= "'htc-debootstrap' -- debootstrap"

DEBOOTSTRAP_VER=1.0.20
DEBOOTSTRAP_SRC=${SRCDIR}/d/debootstrap_1.0.20.tar.gz

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.20.tar.gz

##	package extract

HTC_DEBOOTSTRAP_TEMP=htc-debootstrap-${DEBOOTSTRAP_VER}

HTC_DEBOOTSTRAP_EXTRACTED=${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}/Makefile

.PHONY: htc-debootstrap-extracted
htc-debootstrap-extracted: ${HTC_DEBOOTSTRAP_EXTRACTED}

${HTC_DEBOOTSTRAP_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${DEBOOTSTRAP_SRC}
#	mv ${EXTTEMP}/debootstrap-${DEBOOTSTRAP_VER} ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}
	mv ${EXTTEMP}/debootstrap ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}

##	package configure

HTC_DEBOOTSTRAP_CONFIGURED=${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}/Makefile.OLD

.PHONY: htc-debootstrap-configured
htc-debootstrap-configured: htc-debootstrap-extracted ${HTC_DEBOOTSTRAP_CONFIGURED}

${HTC_DEBOOTSTRAP_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cp Makefile.OLD Makefile || exit 1 \
	)

##	package build

HTC_DEBOOTSTRAP_BUILT=${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP}/debootstrap

.PHONY: htc-debootstrap-built
htc-debootstrap-built: htc-debootstrap-configured ${HTC_DEBOOTSTRAP_BUILT}

${HTC_DEBOOTSTRAP_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP} || exit 1 ;\
		sudo make devices.tar.gz \
	)

##	package install

HTC_DEBOOTSTRAP_INSTALLED=${HTC_ROOT}/usr/bin/debootstrap

.PHONY: htc-debootstrap-installed
htc-debootstrap-installed: htc-debootstrap-built ${HTC_DEBOOTSTRAP_INSTALLED}

${HTC_DEBOOTSTRAP_INSTALLED}: ${HTC_DEBOOTSTRAP_BUILT} ${HTC_ROOT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${HTC_DEBOOTSTRAP_TEMP} || exit 1 ;\
		make install DESTDIR=${HTC_ROOT} || exit 1 \
	)

.PHONY: htc-debootstrap
htc-debootstrap: htc-debootstrap-installed

TARGETS+= htc-debootstrap

endif	# HAVE_DEBOOTSTRAP_CONFIG
