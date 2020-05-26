# debootstrap v1.0.36		[ since v1.0.36, c.2011-09-02 ]
# last mod WmT, 2011-09-02	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_DEBOOTSTRAP_CONFIG},y)
HAVE_DEBOOTSTRAP_CONFIG:=y

DESCRLIST+= "'cui-debootstrap' -- debian bootstrap"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

CUI_DEBOOTSTRAP_VER:=1.0.36
CUI_DEBOOTSTRAP_SRC=${SRCDIR}/d/debootstrap_1.0.36.tar.gz
CUI_DEBOOTSTRAP_PATCHES=

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.36.tar.gz

#CUI_DEBOOTSTRAP_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_DEBOOTSTRAP_TEMP=cui-debootstrap-${CUI_DEBOOTSTRAP_VER}
CUI_DEBOOTSTRAP_INSTTEMP=${EXTTEMP}/insttemp

CUI_DEBOOTSTRAP_EXTRACTED=${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}/configure

.PHONY: cui-debootstrap-extracted

cui-debootstrap-extracted: ${CUI_DEBOOTSTRAP_EXTRACTED}

${CUI_DEBOOTSTRAP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_DEBOOTSTRAP_SRC}
ifneq (${CUI_DEBOOTSTRAP_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_DEBOOTSTRAP_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_DEBOOTSTRAP_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/debootstrap ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}
	#mv ${EXTTEMP}/debootstrap-${CUI_DEBOOTSTRAP_VER} ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}


# ,-----
# |	Configure
# +-----

CUI_DEBOOTSTRAP_CONFIGURED=${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}/Makefile.OLD

.PHONY: cui-debootstrap-configured

cui-debootstrap-configured: cui-debootstrap-extracted ${CUI_DEBOOTSTRAP_CONFIGURED}

${CUI_DEBOOTSTRAP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cp Makefile.OLD Makefile || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_DEBOOTSTRAP_BUILT=${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP}/libdebootstrap.a

.PHONY: cui-debootstrap-built
cui-debootstrap-built: cui-debootstrap-configured ${CUI_DEBOOTSTRAP_BUILT}

${CUI_DEBOOTSTRAP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1



# ,-----
# |	Install
# +-----

CUI_DEBOOTSTRAP_INSTALLED=${CUI_DEBOOTSTRAP_INSTTEMP}/usr/bin/debootstrap

.PHONY: cui-debootstrap-installed

cui-debootstrap-installed: cui-debootstrap-built ${CUI_DEBOOTSTRAP_INSTALLED}

${CUI_DEBOOTSTRAP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_DEBOOTSTRAP_INSTTEMP} install || exit 1 \
	) || exit 1


.PHONY: cui-debootstrap
cui-debootstrap: cti-cross-gcc cui-debootstrap-installed

CTARGETS+= cui-debootstrap

endif	# HAVE_DEBOOTSTRAP_CONFIG
