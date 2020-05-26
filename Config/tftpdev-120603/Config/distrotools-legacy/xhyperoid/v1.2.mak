# xhyperoid v1.4.3		[ EARLIEST v1.2, c.2005-01-20 ]
# last mod WmT, 2010-09-10	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_XHYPEROID_CONFIG},y)
HAVE_XHYPEROID_CONFIG:=y

DESCRLIST+= "'cui-xhyperoid' -- xhyperoid"

include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak

XHYPEROID_VER:=1.2
XHYPEROID_SRC=${SRCDIR}/x/xhyperoid-1.2.tar.gz
XHYPEROID_PATCHES=

URLS+= http://www.svgalib.org/rus/xhyperoid/xhyperoid-1.2.tar.gz

#XHYPEROID_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_XHYPEROID_TEMP=cui-xhyperoid-${XHYPEROID_VER}
CUI_XHYPEROID_INSTTEMP=${EXTTEMP}/insttemp

CUI_XHYPEROID_EXTRACTED=${EXTTEMP}/${CUI_XHYPEROID_TEMP}/Makefile


.PHONY: cui-xhyperoid-extracted

cui-xhyperoid-extracted: ${CUI_XHYPEROID_EXTRACTED}

${CUI_XHYPEROID_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_XHYPEROID_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_XHYPEROID_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${XHYPEROID_SRC}
ifneq (${XHYPEROID_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${XHYPEROID_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d xhyperoid-${XHYPEROID_VER} -Np1 < $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/xhyperoid-${XHYPEROID_VER} ${EXTTEMP}/${CUI_XHYPEROID_TEMP}


# ,-----
# |	Configure
# +-----

CUI_XHYPEROID_CONFIGURED=${EXTTEMP}/${CUI_XHYPEROID_TEMP}/Makefile.OLD

.PHONY: cui-xhyperoid-configured

cui-xhyperoid-configured: cui-xhyperoid-extracted ${CUI_XHYPEROID_CONFIGURED}

${CUI_XHYPEROID_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_XHYPEROID_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed 	' /^CC=/	s%gcc%'${CTI_GCC}'% \
					; /^BINDIR=/	s/games/bin/ \
					; /^	/ s/$$(BINDIR)/$${DESTDIR}$${BINDIR}/g \
					; /^	/ s/$$(XBINDIR)/$${DESTDIR}$${XBINDIR}/g \
					; /^	/ s/$$(MANDIR)/$${DESTDIR}$${MANDIR}/g \
					; /^	/ s/$$(SOUNDSDIR)/$${DESTDIR}$${SOUNDSDIR}/g \
					; /^	chmod/ s/555/777/ \
					' > $${MF} || exit 1 ;\
		done || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_XHYPEROID_BUILT=${EXTTEMP}/${CUI_XHYPEROID_TEMP}/vhyperoid

.PHONY: cui-xhyperoid-built
cui-xhyperoid-built: cui-xhyperoid-configured ${CUI_XHYPEROID_BUILT}

${CUI_XHYPEROID_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_XHYPEROID_TEMP} || exit 1 ;\
		make vga || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_XHYPEROID_INSTALLED=${CUI_XHYPEROID_INSTTEMP}/usr/local/bin/vhyperoid

.PHONY: cui-xhyperoid-installed

cui-xhyperoid-installed: cui-xhyperoid-built ${CUI_XHYPEROID_INSTALLED}

${CUI_XHYPEROID_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_XHYPEROID_INSTTEMP}/usr/local/bin
	( cd ${EXTTEMP}/${CUI_XHYPEROID_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_XHYPEROID_INSTTEMP} || exit 1 ;\
	) || exit 1


##

.PHONY: cui-xhyperoid

cui-xhyperoid: cti-cross-gcc cti-svgalib cui-uClibc-rt cui-svgalib cui-xhyperoid-installed

CTARGETS+= cui-xhyperoid

endif	# HAVE_XHYPEROID_CONFIG
