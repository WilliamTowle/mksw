# dropbear v0.53.1		[ since v0.43, c.2004-10-16 ]
# last mod WmT, 2011-08-18	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_DROPBEAR_CONFIG},y)
HAVE_DROPBEAR_CONFIG:=y

DESCRLIST+= "'cui-dropbear' -- dropbear"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

include ${CFG_ROOT}/misc/zlib/v1.2.5.mak

#DROPBEAR_VER:=0.52
#DROPBEAR_VER:=0.53
DROPBEAR_VER:=0.53.1
DROPBEAR_SRC=${SRCDIR}/d/dropbear-${DROPBEAR_VER}.tar.bz2
DROPBEAR_PATCHES=

URLS+=http://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VER}.tar.bz2

#DROPBEAR_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_DROPBEAR_TEMP=cui-dropbear-${DROPBEAR_VER}
CUI_DROPBEAR_INSTTEMP=${EXTTEMP}/insttemp

CUI_DROPBEAR_EXTRACTED=${EXTTEMP}/${CUI_DROPBEAR_TEMP}/configure

.PHONY: cui-dropbear-extracted

cui-dropbear-extracted: ${CUI_DROPBEAR_EXTRACTED}

${CUI_DROPBEAR_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_DROPBEAR_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_DROPBEAR_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${DROPBEAR_SRC}
ifneq (${DROPBEAR_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${DROPBEAR_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${DROPBEAR_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/dropbear-${DROPBEAR_VER} ${EXTTEMP}/${CUI_DROPBEAR_TEMP}


# ,-----
# |	Configure
# +-----

CUI_DROPBEAR_CONFIGURED=${EXTTEMP}/${CUI_DROPBEAR_TEMP}/config.status

.PHONY: cui-dropbear-configured

cui-dropbear-configured: cui-dropbear-extracted ${CUI_DROPBEAR_CONFIGURED}

${CUI_DROPBEAR_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_DROPBEAR_TEMP} || exit 1 ;\
		CC=${CTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
	)


# ,-----
# |	Build
# +-----

CUI_DROPBEAR_BUILT=${EXTTEMP}/${CUI_DROPBEAR_TEMP}/dumpleases

.PHONY: cui-dropbear-built
cui-dropbear-built: cui-dropbear-configured ${CUI_DROPBEAR_BUILT}

${CUI_DROPBEAR_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_DROPBEAR_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1



# ,-----
# |	Install
# +-----

#CUI_DROPBEAR_INSTALLED=${CUI_DROPBEAR_INSTTEMP}/usr/bin/dumpleases
CUI_DROPBEAR_INSTALLED=${CUI_DROPBEAR_INSTTEMP}/usr/share/dropbearc/sample.renew

.PHONY: cui-dropbear-installed

cui-dropbear-installed: cui-dropbear-built ${CUI_DROPBEAR_INSTALLED}

${CUI_DROPBEAR_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_DROPBEAR_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_DROPBEAR_INSTTEMP} install || exit 1 ;\
		case ${DROPBEAR_VER} in \
		0.52) \
			for F in	/usr/share/dropbearc/default.renew \
					/usr/share/dropbearc/default.nak ; do \
				cp ${CUI_DROPBEAR_INSTTEMP}/$${F} ${CUI_DROPBEAR_INSTTEMP}/`echo $${F} | sed 's/default/sample/'` || exit 1 ;\
			done \
		;; \
		esac \
	) || exit 1


.PHONY: cui-dropbear
cui-dropbear: cti-cross-gcc cti-zlib cui-uClibc-rt cui-dropbear-installed

CTARGETS+= cui-dropbear

endif	# HAVE_DROPBEAR_CONFIG
