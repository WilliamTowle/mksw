# udhcp v0.9.8			[ since v0.9.8, c.2003-02-17 ]
# last mod WmT, 2010-08-18	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_UDHCP_CONFIG},y)
HAVE_UDHCP_CONFIG:=y

DESCRLIST+= "'cui-udhcp' -- udhcp"
DESCRLIST+= "'nti-udhcp' -- udhcp"

## TODO: needs headers, libraries at runtime

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

CUI_UDHCP_VER:=0.9.8
CUI_UDHCP_SRC=${SRCDIR}/u/udhcp_0.9.8cvs20050303.orig.tar.gz
CUI_UDHCP_PATCHES=

NTI_UDHCP_VER:=0.9.8
NTI_UDHCP_SRC=${SRCDIR}/u/udhcp_0.9.8cvs20050303.orig.tar.gz
NTI_UDHCP_PATCHES=

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/u/udhcp/udhcp_0.9.8cvs20050303.orig.tar.gz

#CUI_UDHCP_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_UDHCP_TEMP=cui-udhcp-${CUI_UDHCP_VER}
CUI_UDHCP_INSTTEMP=${EXTTEMP}/insttemp

CUI_UDHCP_EXTRACTED=${EXTTEMP}/${CUI_UDHCP_TEMP}/Makefile

.PHONY: cui-udhcp-extracted

cui-udhcp-extracted: ${CUI_UDHCP_EXTRACTED}

${CUI_UDHCP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_UDHCP_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_UDHCP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_UDHCP_SRC}
ifneq (${CUI_UDHCP_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_UDHCP_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_UDHCP_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/udhcp ${EXTTEMP}/${CUI_UDHCP_TEMP}

##

NTI_UDHCP_TEMP=nti-udhcp-${NTI_UDHCP_VER}
NTI_UDHCP_INSTTEMP=${NTI_TC_ROOT}/

NTI_UDHCP_EXTRACTED=${EXTTEMP}/${NTI_UDHCP_TEMP}/Makefile

.PHONY: nti-udhcp-extracted

nti-udhcp-extracted: ${NTI_UDHCP_EXTRACTED}

${NTI_UDHCP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_UDHCP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UDHCP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${NTI_UDHCP_SRC}
ifneq (${NTI_UDHCP_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${NTI_UDHCP_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${NTI_UDHCP_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/udhcp ${EXTTEMP}/${NTI_UDHCP_TEMP}


# ,-----
# |	Configure
# +-----

CUI_UDHCP_CONFIGURED=${EXTTEMP}/${CUI_UDHCP_TEMP}/Makefile.OLD

.PHONY: cui-udhcp-configured

cui-udhcp-configured: cui-udhcp-extracted ${CUI_UDHCP_CONFIGURED}

${CUI_UDHCP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_UDHCP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[ 	]*/	s%=.*%= '${CTI_GCC}'%' \
			| sed '/^LD[ 	]*/	s%=.*%= '${CTI_GCC}'%' \
			| sed '/^#COMBINED_BINARY/ s/#//' \
			| sed '/^SBINDIR *=/	s%= /*%= $${DESTDIR}/$${prefix}/%' \
			> Makefile \
	)

##

NTI_UDHCP_CONFIGURED=${EXTTEMP}/${NTI_UDHCP_TEMP}/Makefile.OLD

.PHONY: nti-udhcp-configured

nti-udhcp-configured: nti-udhcp-extracted ${NTI_UDHCP_CONFIGURED}

${NTI_UDHCP_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UDHCP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^#COMBINED_BINARY/ s/#//' \
			| sed '/^SBINDIR *=/	s%= /*%= $${DESTDIR}/$${prefix}/%' \
			> Makefile \
	)



# ,-----
# |	Build
# +-----

CUI_UDHCP_BUILT=${EXTTEMP}/${CUI_UDHCP_TEMP}/dumpleases

.PHONY: cui-udhcp-built
cui-udhcp-built: cui-udhcp-configured ${CUI_UDHCP_BUILT}

${CUI_UDHCP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_UDHCP_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1

##

NTI_UDHCP_BUILT=${EXTTEMP}/${NTI_UDHCP_TEMP}/dumpleases

.PHONY: nti-udhcp-built
nti-udhcp-built: nti-udhcp-configured ${NTI_UDHCP_BUILT}

${NTI_UDHCP_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UDHCP_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1




# ,-----
# |	Install
# +-----

#CUI_UDHCP_INSTALLED=${CUI_UDHCP_INSTTEMP}/usr/bin/dumpleases
CUI_UDHCP_INSTALLED=${CUI_UDHCP_INSTTEMP}/usr/share/udhcpc/sample.renew

.PHONY: cui-udhcp-installed

cui-udhcp-installed: cui-udhcp-built ${CUI_UDHCP_INSTALLED}

${CUI_UDHCP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_UDHCP_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_UDHCP_INSTTEMP} install || exit 1 ;\
		for F in	/usr/share/udhcpc/default.renew \
				/usr/share/udhcpc/default.bound \
				/usr/share/udhcpc/default.deconfig \
				/usr/share/udhcpc/default.nak ; do \
			cp ${CUI_UDHCP_INSTTEMP}/$${F} ${CUI_UDHCP_INSTTEMP}/`echo $${F} | sed 's/default/sample/'` || exit 1 ;\
		done \
	) || exit 1

##

#NTI_UDHCP_INSTALLED=${NTI_UDHCP_INSTTEMP}/usr/bin/dumpleases
NTI_UDHCP_INSTALLED=${NTI_UDHCP_INSTTEMP}/usr/share/udhcpc/sample.renew

.PHONY: nti-udhcp-installed

nti-udhcp-installed: nti-udhcp-built ${NTI_UDHCP_INSTALLED}

${NTI_UDHCP_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UDHCP_TEMP} || exit 1 ;\
		make DESTDIR=${NTI_UDHCP_INSTTEMP} install || exit 1 ;\
		for F in	/usr/share/udhcpc/default.renew \
				/usr/share/udhcpc/default.bound \
				/usr/share/udhcpc/default.deconfig \
				/usr/share/udhcpc/default.nak ; do \
			cp ${NTI_UDHCP_INSTTEMP}/$${F} ${NTI_UDHCP_INSTTEMP}/`echo $${F} | sed 's/default/sample/'` || exit 1 ;\
		done \
	) || exit 1




.PHONY: cui-udhcp
cui-udhcp: cti-cross-gcc cui-uClibc-rt cui-udhcp-installed

.PHONY: nti-udhcp
nti-udhcp: nti-udhcp-installed

CTARGETS+= cui-udhcp

endif	# HAVE_UDHCP_CONFIG
