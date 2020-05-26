# cdebootstrap v0.5.7		[ since v0.5.7, c.2011-09-02 ]
# last mod WmT, 2011-09-02	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CDEBOOTSTRAP_CONFIG},y)
HAVE_CDEBOOTSTRAP_CONFIG:=y

DESCRLIST+= "'cui-cdebootstrap' -- debian bootstrap"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

CUI_CDEBOOTSTRAP_VER:=0.5.7
CUI_CDEBOOTSTRAP_SRC=${SRCDIR}/c/cdebootstrap_0.5.7ubuntu2.tar.gz
CUI_CDEBOOTSTRAP_PATCHES=

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/c/cdebootstrap/cdebootstrap_0.5.7ubuntu2.tar.gz

#CUI_CDEBOOTSTRAP_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_CDEBOOTSTRAP_TEMP=cui-cdebootstrap-${CUI_CDEBOOTSTRAP_VER}
CUI_CDEBOOTSTRAP_INSTTEMP=${EXTTEMP}/insttemp

CUI_CDEBOOTSTRAP_EXTRACTED=${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP}/configure

.PHONY: cui-cdebootstrap-extracted

cui-cdebootstrap-extracted: ${CUI_CDEBOOTSTRAP_EXTRACTED}

${CUI_CDEBOOTSTRAP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_CDEBOOTSTRAP_SRC}
ifneq (${CUI_CDEBOOTSTRAP_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_CDEBOOTSTRAP_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_CDEBOOTSTRAP_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/cdebootstrap-${CUI_CDEBOOTSTRAP_VER}ubuntu1 ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP}


# ,-----
# |	Configure
# +-----

CUI_CDEBOOTSTRAP_CONFIGURED=${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP}/config.status

.PHONY: cui-cdebootstrap-configured

cui-cdebootstrap-configured: cui-cdebootstrap-extracted ${CUI_CDEBOOTSTRAP_CONFIGURED}

${CUI_CDEBOOTSTRAP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP} || exit 1 ;\
		CC=${CTI_GCC} \
			./configure --prefix=/usr \
			  --build=${NTI_SPEC} \
			  --host=${CTI_SPEC} \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_CDEBOOTSTRAP_BUILT=${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP}/libdebootstrap.a

.PHONY: cui-cdebootstrap-built
cui-cdebootstrap-built: cui-cdebootstrap-configured ${CUI_CDEBOOTSTRAP_BUILT}

${CUI_CDEBOOTSTRAP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----

CUI_CDEBOOTSTRAP_INSTALLED=${CUI_CDEBOOTSTRAP_INSTTEMP}/usr/bin/debootstrap

.PHONY: cui-cdebootstrap-installed

cui-cdebootstrap-installed: cui-cdebootstrap-built ${CUI_CDEBOOTSTRAP_INSTALLED}

${CUI_CDEBOOTSTRAP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_CDEBOOTSTRAP_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_CDEBOOTSTRAP_INSTTEMP} install || exit 1 \
	) || exit 1


.PHONY: cui-cdebootstrap
cui-cdebootstrap: cti-cross-gcc cui-cdebootstrap-installed

CTARGETS+= cui-cdebootstrap

endif	# HAVE_CDEBOOTSTRAP_CONFIG
