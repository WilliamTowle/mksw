# mcrypt v2.6.8 	      	[ since v2.6.8, c.2011-08-18 ]
# last mod WmT, 2011-08-18	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MCRYPT_CONFIG},y)
HAVE_MCRYPT_CONFIG:=y

DESCRLIST+= "'nti-mcrypt' -- mcrypt"
DESCRLIST+= "'cui-mcrypt' -- mcrypt"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

MCRYPT_VER:=2.6.8
MCRYPT_SRC=${SRCDIR}/m/mcrypt_2.6.8.orig.tar.gz
MCRYPT_PATCHES=

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/m/mcrypt/mcrypt_2.6.8.orig.tar.gz

#MCRYPT_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

#CUI_MCRYPT_TEMP=cui-mcrypt-${MCRYPT_VER}
#CUI_MCRYPT_INSTTEMP=${EXTTEMP}/insttemp
#
#CUI_MCRYPT_EXTRACTED=${EXTTEMP}/${CUI_MCRYPT_TEMP}/configure
#
#.PHONY: cui-mcrypt-extracted
#
#cui-mcrypt-extracted: ${CUI_MCRYPT_EXTRACTED}
#
#${CUI_MCRYPT_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${CUI_MCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_MCRYPT_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${MCRYPT_SRC}
#ifneq (${MCRYPT_PATCHES},)
#	( cd ${EXTTEMP} || exit 1 ;\
#		for PATCHSRC in ${MCRYPT_PATCHES} ; do \
#			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
#		done ;\
#		for PF in patch/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			patch --batch -d gcc-${MCRYPT_VER} -Np1 < $${PF} ;\
#			rm -f $${PF} ;\
#		done \
#	)
#endif
#	mv ${EXTTEMP}/mcrypt-${MCRYPT_VER} ${EXTTEMP}/${CUI_MCRYPT_TEMP}
#


NTI_MCRYPT_TEMP=nti-mcrypt-${MCRYPT_VER}
#NTI_MCRYPT_INSTTEMP=${EXTTEMP}/insttemp

NTI_MCRYPT_EXTRACTED=${EXTTEMP}/${NTI_MCRYPT_TEMP}/configure

.PHONY: nti-mcrypt-extracted

nti-mcrypt-extracted: ${NTI_MCRYPT_EXTRACTED}

${NTI_MCRYPT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_MCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MCRYPT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MCRYPT_SRC}
ifneq (${MCRYPT_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${MCRYPT_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${MCRYPT_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/mcrypt-${MCRYPT_VER} ${EXTTEMP}/${NTI_MCRYPT_TEMP}


# ,-----
# |	Configure
# +-----

#CUI_MCRYPT_CONFIGURED=${EXTTEMP}/${CUI_MCRYPT_TEMP}/config.status
#
#.PHONY: cui-mcrypt-configured
#
#cui-mcrypt-configured: cui-mcrypt-extracted ${CUI_MCRYPT_CONFIGURED}
#
#${CUI_MCRYPT_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_MCRYPT_TEMP} || exit 1 ;\
#		CC=${CTI_GCC} \
#		  CFLAGS='-O2' \
#		  ./configure \
#			--prefix=/usr \
#			--build=${NTI_SPEC} \
#			--host=${CTI_SPEC} \
#	)

NTI_MCRYPT_CONFIGURED=${EXTTEMP}/${NTI_MCRYPT_TEMP}/config.status

.PHONY: nti-mcrypt-configured

nti-mcrypt-configured: nti-mcrypt-extracted ${NTI_MCRYPT_CONFIGURED}

${NTI_MCRYPT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			  --prefix=${NTI_TC_ROOT}/usr/ \
	)

# ,-----
# |	Build
# +-----

#CUI_MCRYPT_BUILT=${EXTTEMP}/${CUI_MCRYPT_TEMP}/dumpleases
#
#.PHONY: cui-mcrypt-built
#cui-mcrypt-built: cui-mcrypt-configured ${CUI_MCRYPT_BUILT}
#
#${CUI_MCRYPT_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_MCRYPT_TEMP} || exit 1 ;\
#		make || exit 1 \
#	) || exit 1
#
#

NTI_MCRYPT_BUILT=${EXTTEMP}/${NTI_MCRYPT_TEMP}/WIWIALDJDS

.PHONY: nti-mcrypt-built
nti-mcrypt-built: nti-mcrypt-configured ${NTI_MCRYPT_BUILT}

${NTI_MCRYPT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1


# ,-----
# |	Install
# +-----


##CUI_MCRYPT_INSTALLED=${CUI_MCRYPT_INSTTEMP}/usr/bin/dumpleases
#CUI_MCRYPT_INSTALLED=${CUI_MCRYPT_INSTTEMP}/usr/share/mcrypt/sample.renew
#
#.PHONY: cui-mcrypt-installed
#
#cui-mcrypt-installed: cui-mcrypt-built ${CUI_MCRYPT_INSTALLED}
#
#${CUI_MCRYPT_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CUI_MCRYPT_TEMP} || exit 1 ;\
#		make DESTDIR=${CUI_MCRYPT_INSTTEMP} install || exit 1 ;\
#		case ${MCRYPT_VER} in \
#		0.52) \
#			for F in	/usr/share/mcrypt/default.renew \
#					/usr/share/mcrypt/default.nak ; do \
#				cp ${CUI_MCRYPT_INSTTEMP}/$${F} ${CUI_MCRYPT_INSTTEMP}/`echo $${F} | sed 's/default/sample/'` || exit 1 ;\
#			done \
#		;; \
#		esac \
#	) || exit 1
#
#
#.PHONY: cui-mcrypt
#cui-mcrypt: cti-cross-gcc cui-uClibc-rt cui-mcrypt-installed
#
#CTARGETS+= cui-mcrypt

NTI_MCRYPT_INSTALLED=${NTI_MCRYPT_INSTTEMP}/WIBLBE

.PHONY: nti-mcrypt-installed

nti-mcrypt-installed: nti-mcrypt-built ${NTI_MCRYPT_INSTALLED}

${NTI_MCRYPT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MCRYPT_TEMP} || exit 1 ;\
		make  install || exit 1 \
	) || exit 1


.PHONY: nti-mcrypt
nti-mcrypt: nti-mcrypt-installed

NTARGETS+= nti-mcrypt

endif	# HAVE_MCRYPT_CONFIG
