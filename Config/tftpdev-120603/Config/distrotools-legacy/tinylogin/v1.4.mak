# tinylogin v1.4		[ since v1.4, c.2011-08-23 ]
# last mod WmT, 2011-08-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_TINYLOGIN_CONFIG},y)
HAVE_TINYLOGIN_CONFIG:=y

DESCRLIST+= "'cui-tinylogin' -- tinylogin"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif


TINYLOGIN_VER:=1.4
TINYLOGIN_SRC=${SRCDIR}/t/tinylogin-1.4.tar.bz2
TINYLOGIN_PATCHES=

URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/tinylogin-1.4.tar.bz2

#TINYLOGIN_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_TINYLOGIN_TEMP=cui-tinylogin-${TINYLOGIN_VER}
CUI_TINYLOGIN_INSTTEMP=${EXTTEMP}/insttemp

CUI_TINYLOGIN_EXTRACTED=${EXTTEMP}/${CUI_TINYLOGIN_TEMP}/Makefile


NTI_TINYLOGIN_TEMP=nti-tinylogin-${TINYLOGIN_VER}
NTI_TINYLOGIN_INSTTEMP=${NTI_TC_ROOT}

NTI_TINYLOGIN_EXTRACTED=${EXTTEMP}/${NTI_TINYLOGIN_TEMP}/Makefile

##

.PHONY: cui-tinylogin-extracted

cui-tinylogin-extracted: ${CUI_TINYLOGIN_EXTRACTED}

${CUI_TINYLOGIN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_TINYLOGIN_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_TINYLOGIN_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${TINYLOGIN_SRC}
ifneq (${TINYLOGIN_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${TINYLOGIN_PATCHES} ; do \
			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${TINYLOGIN_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/tinylogin-${TINYLOGIN_VER} ${EXTTEMP}/${CUI_TINYLOGIN_TEMP}


##

.PHONY: nti-tinylogin-extracted

nti-tinylogin-extracted: ${NTI_TINYLOGIN_EXTRACTED}

${NTI_TINYLOGIN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_TINYLOGIN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TINYLOGIN_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${TINYLOGIN_SRC}
ifneq (${TINYLOGIN_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${TINYLOGIN_PATCHES} ; do \
			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${TINYLOGIN_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/tinylogin-${TINYLOGIN_VER} ${EXTTEMP}/${NTI_TINYLOGIN_TEMP}


# ,-----
# |	Configure
# +-----

CUI_TINYLOGIN_CONFIGURED=${EXTTEMP}/${CUI_TINYLOGIN_TEMP}/.config.old

.PHONY: cui-tinylogin-configured

cui-tinylogin-configured: cui-tinylogin-extracted ${CUI_TINYLOGIN_CONFIGURED}

${CUI_TINYLOGIN_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_TINYLOGIN_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CROSS/		s%=.*%='`echo ${CTI_GCC} | sed 's/gcc$$//'`'%' \
			> Makefile || exit 1 \
	)	|| exit 1

##


NTI_TINYLOGIN_CONFIGURED=${EXTTEMP}/${NTI_TINYLOGIN_TEMP}/Makefile.OLD

.PHONY: nti-tinylogin-configured

nti-tinylogin-configured: nti-tinylogin-extracted ${NTI_TINYLOGIN_CONFIGURED}

${NTI_TINYLOGIN_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TINYLOGIN_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CROSS/		s%=.*%='`echo ${NTI_GCC} | sed 's/gcc$$//'`'%' \
			> Makefile || exit 1 \
	)	|| exit 1



# ,-----
# |	Build
# +-----

CUI_TINYLOGIN_BUILT=${EXTTEMP}/${CUI_TINYLOGIN_TEMP}/tinylogin

.PHONY: cui-tinylogin-built
cui-tinylogin-built: cui-tinylogin-configured ${CUI_TINYLOGIN_BUILT}

${CUI_TINYLOGIN_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_TINYLOGIN_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1

##

NTI_TINYLOGIN_BUILT=${EXTTEMP}/${NTI_TINYLOGIN_TEMP}/tinylogin

.PHONY: nti-tinylogin-built
nti-tinylogin-built: nti-tinylogin-configured ${NTI_TINYLOGIN_BUILT}

${NTI_TINYLOGIN_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TINYLOGIN_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1




# ,-----
# |	Install
# +-----

CUI_TINYLOGIN_INSTALLED=${CUI_TINYLOGIN_INSTTEMP}/bin/tinylogin

.PHONY: cui-tinylogin-installed

cui-tinylogin-installed: cui-tinylogin-built ${CUI_TINYLOGIN_INSTALLED}

${CUI_TINYLOGIN_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_TINYLOGIN_INSTTEMP}
	( cd ${EXTTEMP}/${CUI_TINYLOGIN_TEMP} || exit 1 ;\
		cat install.sh \
			| sed '/id -u/,/fi/ s/^/#/' \
			| sed 's/--[a-z]*=root//g' \
			> unpriv-install.sh ;\
		sh unpriv-install.sh ${CUI_TINYLOGIN_INSTTEMP} \
	) || exit 1

##

NTI_TINYLOGIN_INSTALLED=${NTI_TINYLOGIN_INSTTEMP}/bin/tinylogin

.PHONY: nti-tinylogin-installed

nti-tinylogin-installed: nti-tinylogin-built ${NTI_TINYLOGIN_INSTALLED}

${NTI_TINYLOGIN_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${NTI_TINYLOGIN_INSTTEMP}
	( cd ${EXTTEMP}/${NTI_TINYLOGIN_TEMP} || exit 1 ;\
		cat install.sh \
			| sed '/id -u/,/fi/ s/^/#/' \
			| sed 's/--[a-z]*=root//g' \
			> unpriv-install.sh ;\
		sh unpriv-install.sh ${NTI_TC_ROOT} \
	) || exit 1

##

.PHONY: cui-tinylogin
cui-tinylogin: cti-cross-gcc cui-uClibc-rt cui-tinylogin-installed

CTARGETS+= cui-tinylogin

.PHONY: nti-tinylogin
nti-tinylogin: nti-native-gcc nti-tinylogin-installed

NTARGETS+= nti-tinylogin

endif	# HAVE_TINYLOGIN_CONFIG
