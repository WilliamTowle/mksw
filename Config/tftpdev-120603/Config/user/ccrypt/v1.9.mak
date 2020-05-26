# ccrypt v1.9 	   	   	[ since v1.9, c.2011-08-18 ]
# last mod WmT, 2011-08-18	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_CCRYPT_CONFIG},y)
HAVE_CCRYPT_CONFIG:=y

DESCRLIST+= "'nti-ccrypt' -- ccrypt"
DESCRLIST+= "'cui-ccrypt' -- ccrypt"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

CCRYPT_VER:=1.9
CCRYPT_SRC=${SRCDIR}/c/ccrypt_1.9.orig.tar.gz
CCRYPT_PATCHES=

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/c/ccrypt/ccrypt_1.9.orig.tar.gz

#CCRYPT_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_CCRYPT_TEMP=cui-ccrypt-${CCRYPT_VER}
CUI_CCRYPT_INSTTEMP=${EXTTEMP}/insttemp

CUI_CCRYPT_EXTRACTED=${EXTTEMP}/${CUI_CCRYPT_TEMP}/configure

.PHONY: cui-ccrypt-extracted

cui-ccrypt-extracted: ${CUI_CCRYPT_EXTRACTED}

${CUI_CCRYPT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_CCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_CCRYPT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CCRYPT_SRC}
ifneq (${CCRYPT_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CCRYPT_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CCRYPT_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/ccrypt-${CCRYPT_VER} ${EXTTEMP}/${CUI_CCRYPT_TEMP}

##

NTI_CCRYPT_TEMP=nti-ccrypt-${CCRYPT_VER}
#NTI_CCRYPT_INSTTEMP=${EXTTEMP}/insttemp

NTI_CCRYPT_EXTRACTED=${EXTTEMP}/${NTI_CCRYPT_TEMP}/configure

.PHONY: nti-ccrypt-extracted

nti-ccrypt-extracted: ${NTI_CCRYPT_EXTRACTED}

${NTI_CCRYPT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_CCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CCRYPT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CCRYPT_SRC}
ifneq (${CCRYPT_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CCRYPT_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CCRYPT_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/ccrypt-${CCRYPT_VER} ${EXTTEMP}/${NTI_CCRYPT_TEMP}


# ,-----
# |	Configure
# +-----

CUI_CCRYPT_CONFIGURED=${EXTTEMP}/${CUI_CCRYPT_TEMP}/config.status

.PHONY: cui-ccrypt-configured

cui-ccrypt-configured: cui-ccrypt-extracted ${CUI_CCRYPT_CONFIGURED}

${CUI_CCRYPT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_CCRYPT_TEMP} || exit 1 ;\
		CC=${CTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
	)

##

NTI_CCRYPT_CONFIGURED=${EXTTEMP}/${NTI_CCRYPT_TEMP}/config.status

.PHONY: nti-ccrypt-configured

nti-ccrypt-configured: nti-ccrypt-extracted ${NTI_CCRYPT_CONFIGURED}

${NTI_CCRYPT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			  --prefix=${NTI_TC_ROOT}/usr/ \
	)

# ,-----
# |	Build
# +-----

CUI_CCRYPT_BUILT=${EXTTEMP}/${CUI_CCRYPT_TEMP}/src/ccrypt

.PHONY: cui-ccrypt-built
cui-ccrypt-built: cui-ccrypt-configured ${CUI_CCRYPT_BUILT}

${CUI_CCRYPT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_CCRYPT_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1

##

NTI_CCRYPT_BUILT=${EXTTEMP}/${NTI_CCRYPT_TEMP}/src/ccrypt

.PHONY: nti-ccrypt-built
nti-ccrypt-built: nti-ccrypt-configured ${NTI_CCRYPT_BUILT}

${NTI_CCRYPT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----


CUI_CCRYPT_INSTALLED=${CUI_CCRYPT_INSTTEMP}/usr/bin/ccrypt

.PHONY: cui-ccrypt-installed

cui-ccrypt-installed: cui-ccrypt-built ${CUI_CCRYPT_INSTALLED}

${CUI_CCRYPT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_CCRYPT_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_CCRYPT_INSTTEMP} install || exit 1 \
	) || exit 1


.PHONY: cui-ccrypt
cui-ccrypt: cti-cross-gcc cui-uClibc-rt cui-ccrypt-installed

CTARGETS+= cui-ccrypt

##

NTI_CCRYPT_INSTALLED=${NTI_TC_ROOT}/usr/bin/ccrypt

.PHONY: nti-ccrypt-installed

nti-ccrypt-installed: nti-ccrypt-built ${NTI_CCRYPT_INSTALLED}

${NTI_CCRYPT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CCRYPT_TEMP} || exit 1 ;\
		make  install || exit 1 \
	) || exit 1


.PHONY: nti-ccrypt
nti-ccrypt: nti-ccrypt-installed

NTARGETS+= nti-ccrypt

endif	# HAVE_CCRYPT_CONFIG
