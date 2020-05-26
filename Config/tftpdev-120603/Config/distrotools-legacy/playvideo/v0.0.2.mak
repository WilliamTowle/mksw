# playvideo v1.4.3		[ EARLIEST: v0.0.2, c.2005-01-18 ]
# last mod WmT, 2011-05-04	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_PLAYVIDEO_CONFIG},y)
HAVE_PLAYVIDEO_CONFIG:=y

DESCRLIST+= "'cui-playvideo' -- playvideo"

include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak

include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak
include ${CFG_ROOT}/distrotools-legacy/jpegsrc/v8c.mak

PLAYVIDEO_VER:=0.0.2
PLAYVIDEO_SRC=${SRCDIR}/p/playvideo-0.0.2.tar.gz
PLAYVIDEO_PATCHES=

URLS+= http://www.arava.co.il/matan/svgalib/video/playvideo-0.0.2.tar.gz

PLAYVIDEO_PATCHES+=
URLS+=


# ,-----
# |	Extract
# +-----

CUI_PLAYVIDEO_TEMP=cui-playvideo-${PLAYVIDEO_VER}
CUI_PLAYVIDEO_INSTTEMP=${EXTTEMP}/insttemp

CUI_PLAYVIDEO_EXTRACTED=${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}/Makefile


.PHONY: cui-playvideo-extracted

cui-playvideo-extracted: ${CUI_PLAYVIDEO_EXTRACTED}

${CUI_PLAYVIDEO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${PLAYVIDEO_SRC}
ifneq (${PLAYVIDEO_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${PLAYVIDEO_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d playvideo-${PLAYVIDEO_VER} -Np1 < $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/playvideo ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}
#	mv ${EXTTEMP}/playvideo-${PLAYVIDEO_VER} ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}


# ,-----
# |	Configure
# +-----

CUI_PLAYVIDEO_CONFIGURED=${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}/Makefile.OLD

.PHONY: cui-playvideo-configured

cui-playvideo-configured: cui-playvideo-extracted ${CUI_PLAYVIDEO_CONFIGURED}

${CUI_PLAYVIDEO_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed	' /^CFLAGS/	s/-march=i686// \
					; /^GCC/	s/gcc.*/'${CTI_GCC}'/ \
					; /^OBJS/	s/qt_file.o// \
					; /^LIBS/	s/-lquicktime// \
					; /^OBJS/	s/mpeg_file.o// \
					; /^LIBS/	s/-lmpeg3// \
					; /^OBJS/	s/vidplay.o// \
					; /^LIBS/	s/-pthread// \
					' > $${MF} || exit 1 ;\
		done || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_PLAYVIDEO_BUILT=${EXTTEMP}/${CUI_PLAYVIDEO_TEMP}/threeDKit/plane

.PHONY: cui-playvideo-built
cui-playvideo-built: cui-playvideo-configured ${CUI_PLAYVIDEO_BUILT}

${CUI_PLAYVIDEO_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_PLAYVIDEO_INSTALLED=${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin/plane

.PHONY: cui-playvideo-installed

cui-playvideo-installed: cui-playvideo-built ${CUI_PLAYVIDEO_INSTALLED}

${CUI_PLAYVIDEO_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin
	( cd ${EXTTEMP}/${CUI_PLAYVIDEO_TEMP} || exit 1 ;\
		case ${PLAYVIDEO_VER} in \
		1.4.3)	\
			cp demos/fun ${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin || exit 1 ;\
			[ -r demos/testgl ] && cp demos/testgl ${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin || exit 1 ;\
			cp threeDKit/plane ${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin || exit 1 ;\
			cp threeDKit/wrapdemo ${CUI_PLAYVIDEO_INSTTEMP}/usr/local/bin || exit 1 \
		;; \
		*) \
			echo "INSTALL: Unexpected PLAYVIDEO_VER ${PLAYVIDEO_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	) || exit 1


##

.PHONY: cui-playvideo

cui-playvideo: cti-cross-gcc cti-svgalib cti-jpegsrc cui-uClibc-rt cui-svgalib cui-playvideo-installed

CTARGETS+= cui-playvideo

endif	# HAVE_PLAYVIDEO_CONFIG
