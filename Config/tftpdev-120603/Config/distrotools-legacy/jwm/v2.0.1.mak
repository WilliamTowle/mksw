# jwm v2.0.1			[ since v2.0.1, c.2011-08-12 ]
# last mod WmT, 2011-08-12	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_JWM_CONFIG},y)
HAVE_JWM_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'cui-jwm' -- jwm"

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

JWM_VER=2.0.1
JWM_SRC=${SRCDIR}/j/jwm-${JWM_VER}.tar.bz2

URLS+=http://joewing.net/programs/jwm/releases/jwm-2.0.1.tar.bz2


# ,-----
# |	Extract
# +-----

CUI_JWM_TEMP=cui-jwm-${JWM_VER}
CUI_JWM_INSTTEMP=${EXTTEMP}/insttemp

CUI_JWM_EXTRACTED=${EXTTEMP}/${CUI_JWM_TEMP}/configure

.PHONY: cui-jwm-extracted

cui-jwm-extracted: ${CUI_JWM_EXTRACTED}

${CUI_JWM_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_JWM_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_JWM_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${JWM_SRC}
	mv ${EXTTEMP}/jwm-${JWM_VER} ${EXTTEMP}/${CUI_JWM_TEMP}


# ,-----
# |	Configure
# +-----

CUI_JWM_CONFIGURED=${EXTTEMP}/${CUI_JWM_TEMP}/config.status

.PHONY: cui-jwm-configured

cui-jwm-configured: cui-jwm-extracted ${CUI_JWM_CONFIGURED}

${CUI_JWM_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
	  CC=${CUI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${CUI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_JWM_BUILT=${EXTTEMP}/${CUI_JWM_TEMP}/jwm

.PHONY: cui-jwm-built
cui-jwm-built: cui-jwm-configured ${CUI_JWM_BUILT}

${CUI_JWM_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

CUI_JWM_INSTALLED=${CUI_TC_ROOT}/usr/bin/jwm

.PHONY: cui-jwm-installed

cui-jwm-installed: cui-jwm-built ${CUI_JWM_INSTALLED}

${CUI_JWM_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_JWM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cui-jwm
cui-jwm: cti-cross-gcc cui-uClibc-rt cui-jwm-installed

CTARGETS+= cui-jwm

endif	# HAVE_JWM_CONFIG
