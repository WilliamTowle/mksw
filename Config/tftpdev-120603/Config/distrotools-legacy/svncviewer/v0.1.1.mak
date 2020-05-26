# svncviewer v0.1.1		[ EARLIEST v0.1.1, c.2005-01-20 ]
# last mod WmT, 2011-05-04	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SVNCVIEWER_CONFIG},y)
HAVE_SVNCVIEWER_CONFIG:=y

DESCRLIST+= "'cui-svncviewer' -- svncviewer"

include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak

include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak
include ${CFG_ROOT}/distrotools-legacy/jpegsrc/v8b.mak

SVNCVIEWER_VER:=0.1.1
SVNCVIEWER_SRC=${SRCDIR}/s/svncviewer_0.1.1.orig.tar.gz
SVNCVIEWER_PATCHES=

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/s/svncviewer/svncviewer_0.1.1.orig.tar.gz

#SVNCVIEWER_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_SVNCVIEWER_TEMP=cui-svncviewer-${SVNCVIEWER_VER}
CUI_SVNCVIEWER_INSTTEMP=${EXTTEMP}/insttemp

CUI_SVNCVIEWER_EXTRACTED=${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}/makefile

.PHONY: cui-svncviewer-extracted

cui-svncviewer-extracted: ${CUI_SVNCVIEWER_EXTRACTED}

${CUI_SVNCVIEWER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SVNCVIEWER_SRC}
ifneq (${SVNCVIEWER_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${SVNCVIEWER_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d svncviewer-${SVNCVIEWER_VER} -Np1 < $${PF} ;\
		done \
	)
endif
#	mv ${EXTTEMP}/svncviewer-${SVNCVIEWER_VER} ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}
	mv ${EXTTEMP}/svncviewer-${SVNCVIEWER_VER}.orig ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}


# ,-----
# |	Configure
# +-----

CUI_SVNCVIEWER_CONFIGURED=${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}/Makefile.OLD

.PHONY: cui-svncviewer-configured

cui-svncviewer-configured: cui-svncviewer-extracted ${CUI_SVNCVIEWER_CONFIGURED}

${CUI_SVNCVIEWER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^SRCS/		s%^%CC='${CTI_GCC}'\n\n%' \
			| sed '/^	/	s/gcc/$${CC}/' \
			> Makefile || exit 1 ;\
		rm -f svncviewer \
	)


# ,-----
# |	Build
# +-----

CUI_SVNCVIEWER_BUILT=${EXTTEMP}/${CUI_SVNCVIEWER_TEMP}/svncviewer

.PHONY: cui-svncviewer-built
cui-svncviewer-built: cui-svncviewer-configured ${CUI_SVNCVIEWER_BUILT}

${CUI_SVNCVIEWER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_SVNCVIEWER_INSTALLED=${CUI_SVNCVIEWER_INSTTEMP}/usr/local/bin/svncviewer

.PHONY: cui-svncviewer-installed

cui-svncviewer-installed: cui-svncviewer-built ${CUI_SVNCVIEWER_INSTALLED}

${CUI_SVNCVIEWER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_SVNCVIEWER_INSTTEMP}/usr/local/bin
	( cd ${EXTTEMP}/${CUI_SVNCVIEWER_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_SVNCVIEWER_INSTTEMP} || exit 1 ;\
	) || exit 1


##

.PHONY: cui-svncviewer

cui-svncviewer: cti-cross-gcc cti-svgalib cti-jpegsrc cui-uClibc-rt cui-svgalib cui-jpegsrc cui-svncviewer-installed

CTARGETS+= cui-svncviewer

endif	# HAVE_SVNCVIEWER_CONFIG
