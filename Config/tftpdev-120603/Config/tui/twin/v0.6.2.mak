# twin v0.6.2			[ since v0.5.1, c. 2004-05-29 ]
# last mod WmT, 2010-10-25	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_TWIN_CONFIG},y)
HAVE_TWIN_CONFIG:=y

DESCRLIST+= "'nti-twin' -- twin"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

TWIN_VER:=0.6.2

TWIN_SRC=${SRCDIR}/t/twin-0.6.2.tar.gz

URLS+= http://linuz.sns.it/~max/twin/twin-0.6.2.tar.gz


# ,-----
# |	Extract
# +-----

CUI_TWIN_TEMP=cui-twin-${TWIN_VER}
CUI_TWIN_EXTRACTED=${EXTTEMP}/${CUI_TWIN_TEMP}/configure
CUI_TWIN_INSTROOT=${EXTTEMP}/insttemp

NTI_TWIN_TEMP=nti-twin-${TWIN_VER}
NTI_TWIN_EXTRACTED=${EXTTEMP}/${NTI_TWIN_TEMP}/configure
NTI_TWIN_INSTROOT=${NTI_TC_ROOT}

##

.PHONY: cui-twin-extracted

cui-twin-extracted: ${CUI_TWIN_EXTRACTED}

${CUI_TWIN_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_TWIN_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_TWIN_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${TWIN_SRC}
	mv ${EXTTEMP}/twin-${TWIN_VER} ${EXTTEMP}/${CUI_TWIN_TEMP}

##

.PHONY: nti-twin-extracted

nti-twin-extracted: ${NTI_TWIN_EXTRACTED}

${NTI_TWIN_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_TWIN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TWIN_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${TWIN_SRC}
	mv ${EXTTEMP}/twin-${TWIN_VER} ${EXTTEMP}/${NTI_TWIN_TEMP}


# ,-----
# |	Configure
# +-----

##

CUI_TWIN_CONFIGURED=${EXTTEMP}/${CUI_TWIN_TEMP}/config.status

.PHONY: cui-twin-configured

cui-twin-configured: cui-twin-extracted ${CUI_TWIN_CONFIGURED}

${CUI_TWIN_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_TWIN_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  ac_cv_file__dev_ptmx=no \
		./configure \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			--prefix=/usr \
			|| exit 1 \
	)


##

NTI_TWIN_CONFIGURED=${EXTTEMP}/${NTI_TWIN_TEMP}/config.status

.PHONY: nti-twin-configured

nti-twin-configured: nti-twin-extracted ${NTI_TWIN_CONFIGURED}

${NTI_TWIN_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TWIN_INSTROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_TWIN_BUILT=${EXTTEMP}/${CUI_TWIN_TEMP}/server/twin

.PHONY: cui-twin-built
cui-twin-built: cui-twin-configured ${CUI_TWIN_BUILT}

${CUI_TWIN_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_TWIN_TEMP} || exit 1 ;\
		make \
	)

##

NTI_TWIN_BUILT=${EXTTEMP}/${NTI_TWIN_TEMP}/server/twin

.PHONY: nti-twin-built
nti-twin-built: nti-twin-configured ${NTI_TWIN_BUILT}

${NTI_TWIN_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

CUI_TWIN_INSTALLED=${CUI_TC_ROOT}/usr/bin/twstart

.PHONY: cui-twin-installed

cui-twin-installed: cui-twin-built ${CUI_TWIN_INSTALLED}

${CUI_TWIN_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_TWIN_TEMP} || exit 1 ;\
		make install \
			DESTDIR=${CUI_TWIN_INSTROOT} \
	)

##

NTI_TWIN_INSTALLED=${NTI_TC_ROOT}/usr/bin/twstart

.PHONY: nti-twin-installed

nti-twin-installed: nti-twin-built ${NTI_TWIN_INSTALLED}

${NTI_TWIN_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cui-twin
cui-twin: cti-cross-gcc cui-uClibc-rt cui-twin-installed

CTARGETS+= cui-twin

##

.PHONY: nti-twin
nti-twin: nti-twin-installed

NTARGETS+= nti-twin

endif	# HAVE_TWIN_CONFIG
