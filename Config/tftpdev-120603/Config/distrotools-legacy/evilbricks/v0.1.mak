# evilbricks v1.4.3		[ EARLIEST v0.1, c.2005-01-20 ]
# last mod WmT, 2010-09-10	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_EVILBRICKS_CONFIG},y)
HAVE_EVILBRICKS_CONFIG:=y

DESCRLIST+= "'cui-evilbricks' -- evilbricks"

include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak

EVILBRICKS_VER:=0.1
EVILBRICKS_SRC=${SRCDIR}/e/evilbricks-0.1.tgz
EVILBRICKS_PATCHES=

URLS+= http://users.tmok.com/~gauze/stuff/evilbricks-0.1.tgz

#EVILBRICKS_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_EVILBRICKS_TEMP=cui-evilbricks-${EVILBRICKS_VER}
CUI_EVILBRICKS_INSTTEMP=${EXTTEMP}/insttemp

CUI_EVILBRICKS_EXTRACTED=${EXTTEMP}/${CUI_EVILBRICKS_TEMP}/Makefile


.PHONY: cui-evilbricks-extracted

cui-evilbricks-extracted: ${CUI_EVILBRICKS_EXTRACTED}

${CUI_EVILBRICKS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_EVILBRICKS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_EVILBRICKS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${EVILBRICKS_SRC}
ifneq (${EVILBRICKS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${EVILBRICKS_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d evilbricks-${EVILBRICKS_VER} -Np1 < $${PF} ;\
		done \
	)
endif
#	mv ${EXTTEMP}/evilbricks-${EVILBRICKS_VER} ${EXTTEMP}/${CUI_EVILBRICKS_TEMP}
	mv ${EXTTEMP}/evilbricks ${EXTTEMP}/${CUI_EVILBRICKS_TEMP}


# ,-----
# |	Configure
# +-----

CUI_EVILBRICKS_CONFIGURED=${EXTTEMP}/${CUI_EVILBRICKS_TEMP}/Makefile.OLD

.PHONY: cui-evilbricks-configured

cui-evilbricks-configured: cui-evilbricks-extracted ${CUI_EVILBRICKS_CONFIGURED}

${CUI_EVILBRICKS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_EVILBRICKS_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^	/ s%gcc%'${CTI_GCC}'%' \
				| sed '/^	/ s/ -g//' \
				| sed '/^	/ s%/usr%$${DESTDIR}/usr%' \
				| sed '/^install/ s/evilbricks//' \
				| sed '/^	chown/ s/^/#/' \
				> $${MF} || exit 1 ;\
		done || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_EVILBRICKS_BUILT=${EXTTEMP}/${CUI_EVILBRICKS_TEMP}/evilbricks

.PHONY: cui-evilbricks-built
cui-evilbricks-built: cui-evilbricks-configured ${CUI_EVILBRICKS_BUILT}

${CUI_EVILBRICKS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_EVILBRICKS_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_EVILBRICKS_INSTALLED=${CUI_EVILBRICKS_INSTTEMP}/usr/local/bin/evilbricks

.PHONY: cui-evilbricks-installed

cui-evilbricks-installed: cui-evilbricks-built ${CUI_EVILBRICKS_INSTALLED}

${CUI_EVILBRICKS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_EVILBRICKS_INSTTEMP}/usr/local/bin
	( cd ${EXTTEMP}/${CUI_EVILBRICKS_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_EVILBRICKS_INSTTEMP} || exit 1 ;\
	) || exit 1


##

.PHONY: cui-evilbricks

cui-evilbricks: cti-cross-gcc cti-svgalib cui-uClibc-rt cui-svgalib cui-evilbricks-installed

CTARGETS+= cui-evilbricks

endif	# HAVE_EVILBRICKS_CONFIG
