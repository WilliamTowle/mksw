# uClibc v0.9.26		[ since v.0.9.9, 2002-10-26 ]
# last mod WmT, 2010-06-07	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_CUI_UCLIBC_RT_CONFIG},y)
HAVE_CUI_UCLIBC_RT_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/cross-gcc/v2.95.3.mak
include ${CFG_ROOT}/distrotools-legacy/uClibc-dev/v0.9.26.mak

DESCRLIST+= "'cui-uClibc-rt' -- uClibc runtime"

CUI_UCLIBC_RT_VER:=0.9.26
CUI_UCLIBC_RT_SRC=${SRCDIR}/u/uClibc-${CUI_UCLIBC_RT_VER}.tar.bz2
CUI_UCLIBC_RT_PATCHES=

#URLS+=http://uclibc.org/downloads/old-releases/uClibc-0.9.20.tar.bz2
URLS+=http://www.uclibc.org/downloads/uClibc-${CUI_UCLIBC_RT_VER}.tar.bz2

# TODO: are there Gentoo patches (general and uClibc-specific?)


# ,-----
# |	Extract
# +-----

CUI_UCLIBC_RT_TEMP=cui-uClibc-rt-${CUI_UCLIBC_RT_VER}
CUI_UCLIBC_RT_INSTTEMP=${EXTTEMP}/insttemp

CUI_UCLIBC_RT_EXTRACTED=${EXTTEMP}/${CUI_UCLIBC_RT_TEMP}/Makefile

.PHONY: cui-uClibc-rt-extracted

cui-uClibc-rt-extracted: ${CUI_UCLIBC_RT_EXTRACTED}

${CUI_UCLIBC_RT_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_UCLIBC_RT_SRC}
#ifneq (${CUI_UCLIBC_RT_PATCHES},)
#	( cd ${EXTTEMP} || exit 1 ;\
#		for PATCHSRC in ${CUI_UCLIBC_RT_PATCHES} ; do \
#			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
#		done ;\
#		for PF in uclibc-patches/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			patch --batch -d binutils-${CUI_UCLIBC_RT_VER} -Np1 < $${PF} ;\
#			rm -f $${PF} ;\
#		done ;\
#		for PF in patch/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			sed '/+++ / { s%avr-%% ; s%binutils[^/]*/%% ; s%src/%% }' $${PF} | patch --batch -d binutils-${CUI_UCLIBC_RT_VER} -Np0 ;\
#			rm -f $${PF} ;\
#		done \
#	)
#endif
	mv ${EXTTEMP}/uClibc-${CUI_UCLIBC_RT_VER} ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP}


# ,-----
# |	Configure
# +-----

CUI_UCLIBC_RT_CONFIGURED=${EXTTEMP}/${CUI_UCLIBC_RT_TEMP}/.config

.PHONY: cui-uClibc-rt-configured

cui-uClibc-rt-configured: cui-uClibc-rt-extracted ${CUI_UCLIBC_RT_CONFIGURED}

${CUI_UCLIBC_RT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP} || exit 1 ;\
		cp ${CTI_TC_ROOT}/etc/config-uClibc-${CUI_UCLIBC_RT_VER} .config || exit 1 ;\
		case ${CUI_UCLIBC_RT_VER} in \
		0.9.20) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD || exit 1 ;\
			cat Rules.mak.OLD \
				| sed	' /^CROSS/	s%=.*%= '${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-% ; /(CROSS)/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_GCC} | sed 's/gcc$$//'`'" ; fi)% ; /USE_CACHE/ s/#// ; /usr.bin.*awk/ s%/usr/bin/awk%'${AWK_EXE}'% ' > Rules.mak || exit 1 ;\
			[ -r ldso/util/Makefile.OLD ] || mv ldso/util/Makefile ldso/util/Makefile.OLD || exit 1 ;\
			cat ldso/util/Makefile.OLD \
				| sed 's%$$(HOSTCC)%'${NTI_GCC}'%' \
				> ldso/util/Makefile || exit 1 ;\
			[ -r ldso/util/bswap.h.OLD ] || mv ldso/util/bswap.h ldso/util/bswap.h.OLD || exit 1 ;\
			cat ldso/util/bswap.h.OLD \
				| sed 's%def __linux__%def __glibc_linux__ /* __linux__ */%' \
				| sed 's/<string.h>/"stdint.h"/' \
				> ldso/util/bswap.h || exit 1 \
		;; \
		0.9.26) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD || exit 1 ;\
			cat Rules.mak.OLD \
				| sed	' /^CROSS/	s%=.*%= '${CTI_TC_ROOT}'/usr/bin/'${CTI_MIN_SPEC}'-% ; /(CROSS)/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_GCC} | sed 's/gcc$$//'`'" ; fi)% ; /USE_CACHE/ s/#// ; /usr.bin.*awk/ s%/usr/bin/awk%'${AWK_EXE}'% ' > Rules.mak || exit 1 \
		;; \
		0.9.2[89]*) ;; \
		*)	echo "$0: do_configure 'Makefile's: Unexpected CUI_UCLIBC_RT_VER ${CUI_UCLIBC_RT_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		yes '' | make HOSTCC=${NTI_GCC} oldconfig || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_UCLIBC_RT_BUILT=${EXTTEMP}/${CUI_UCLIBC_RT_TEMP}/libc/libc.a

.PHONY: cui-uClibc-rt-built
cui-uClibc-rt-built: cui-uClibc-rt-configured ${CUI_UCLIBC_RT_BUILT}

${CUI_UCLIBC_RT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP} || exit 1 ;\
		${MAKE} || exit 1 \
	)


# ,-----
# |	Install
# +-----

CUI_UCLIBC_RT_INSTALLED=${CUI_UCLIBC_RT_INSTTEMP}/lib/libc.so.0

.PHONY: cui-uClibc-rt-installed

cui-uClibc-rt-installed: cui-uClibc-rt-built ${CUI_UCLIBC_RT_INSTALLED}

${CUI_UCLIBC_RT_INSTALLED}:
	( cd ${EXTTEMP}/${CUI_UCLIBC_RT_TEMP} || exit 1 ;\
		make RUNTIME_PREFIX=${CUI_UCLIBC_RT_INSTTEMP}/ install_runtime || exit 1 \
	) || exit 1


.PHONY: cui-uClibc-rt
cui-uClibc-rt: cti-cross-gcc cti-uClibc-dev cui-uClibc-rt-installed

TARGETS+= cui-uClibc-rt

endif	# HAVE_CUI_UCLIBC_RT_CONFIG
