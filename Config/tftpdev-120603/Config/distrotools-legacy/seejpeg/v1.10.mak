# seejpeg v1.10			[ EARLIEST v1.10, c.2005-01-24 ]
# last mod WmT, 2011-05-04	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SEEJPEG_CONFIG},y)
HAVE_SEEJPEG_CONFIG:=y

DESCRLIST+= "'cui-seejpeg' -- seejpeg"

include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak

include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak
include ${CFG_ROOT}/distrotools-legacy/jpegsrc/v8c.mak

SEEJPEG_VER:=1.10
SEEJPEG_SRC=${SRCDIR}/s/seejpeg-1.10.tgz
SEEJPEG_PATCHES=

URLS+= ftp://sunsite.unc.edu/pub/Linux/apps/graphics/viewers/svga/seejpeg-1.10.tgz

#SEEJPEG_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_SEEJPEG_TEMP=cui-seejpeg-${SEEJPEG_VER}
CUI_SEEJPEG_INSTTEMP=${EXTTEMP}/insttemp

CUI_SEEJPEG_EXTRACTED=${EXTTEMP}/${CUI_SEEJPEG_TEMP}/Makefile


.PHONY: cui-seejpeg-extracted

cui-seejpeg-extracted: ${CUI_SEEJPEG_EXTRACTED}

${CUI_SEEJPEG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_SEEJPEG_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SEEJPEG_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SEEJPEG_SRC}
ifneq (${SEEJPEG_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${SEEJPEG_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d seejpeg-${SEEJPEG_VER} -Np1 < $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/seejpeg-${SEEJPEG_VER} ${EXTTEMP}/${CUI_SEEJPEG_TEMP}


# ,-----
# |	Configure
# +-----

CUI_SEEJPEG_CONFIGURED=${EXTTEMP}/${CUI_SEEJPEG_TEMP}/Makefile.OLD

.PHONY: cui-seejpeg-configured

cui-seejpeg-configured: cui-seejpeg-extracted ${CUI_SEEJPEG_CONFIGURED}

${CUI_SEEJPEG_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_SEEJPEG_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed	' /^CC/	s%gcc%'${CTI_GCC}'% \
					; /^JPEG_/ s%/usr/local%'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'% \
					; /^	/ s%$$(BIN)%$${DESTDIR}/$${BIN}% \
					; /^	/ s%$$(MAN)%$${DESTDIR}/$${MAN}% \
					; /^	/ s/-o root// \
					; /^	/ s/-g bin// \
					; /^	/ s/-g root// \
					' > $${MF} || exit 1 ;\
		done || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_SEEJPEG_BUILT=${EXTTEMP}/${CUI_SEEJPEG_TEMP}/seejpeg

.PHONY: cui-seejpeg-built
cui-seejpeg-built: cui-seejpeg-configured ${CUI_SEEJPEG_BUILT}

${CUI_SEEJPEG_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_SEEJPEG_TEMP} || exit 1 ;\
		make seejpeg || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_SEEJPEG_INSTALLED=${CUI_SEEJPEG_INSTTEMP}/usr/local/bin/seejpeg

.PHONY: cui-seejpeg-installed

cui-seejpeg-installed: cui-seejpeg-built ${CUI_SEEJPEG_INSTALLED}

${CUI_SEEJPEG_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_SEEJPEG_INSTTEMP}/usr/local/bin
	mkdir -p ${CUI_SEEJPEG_INSTTEMP}/usr/local/man
	( cd ${EXTTEMP}/${CUI_SEEJPEG_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_SEEJPEG_INSTTEMP} || exit 1 ;\
	) || exit 1


##

.PHONY: cui-seejpeg

cui-seejpeg: cti-cross-gcc cti-svgalib cti-jpegsrc cui-uClibc-rt cui-svgalib cui-jpegsrc cui-seejpeg-installed

CTARGETS+= cui-seejpeg

endif	# HAVE_SEEJPEG_CONFIG
