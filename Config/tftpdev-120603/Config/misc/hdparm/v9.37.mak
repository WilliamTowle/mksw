# hdparm v9.37			[ since v5.2, c.2002-11-08 ]
# last mod WmT, 2011-01-26	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_HDPARM_CONFIG},y)
HAVE_HDPARM_CONFIG:=y

DESCRLIST+= "'nti-hdparm' -- hdparm"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

#HDPARM_VER=9.36
HDPARM_VER=9.37
HDPARM_SRC=${SRCDIR}/h/hdparm-${HDPARM_VER}.tar.gz

URLS+= http://downloads.sourceforge.net/project/hdparm/hdparm/hdparm-${HDPARM_VER}.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fhdparm%2F&ts=1289903569&use_mirror=ovh


## ,-----
## |	Extract
## +-----

NTI_HDPARM_TEMP=nti-hdparm-${HDPARM_VER}

NTI_HDPARM_EXTRACTED=${EXTTEMP}/${NTI_HDPARM_TEMP}/Makefile

.PHONY: nti-hdparm-extracted

nti-hdparm-extracted: ${NTI_HDPARM_EXTRACTED}

${NTI_HDPARM_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_HDPARM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_HDPARM_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${HDPARM_SRC}
	mv ${EXTTEMP}/hdparm-${HDPARM_VER} ${EXTTEMP}/${NTI_HDPARM_TEMP}


## ,-----
## |	Configure
## +-----

NTI_HDPARM_CONFIGURED=${EXTTEMP}/${NTI_HDPARM_TEMP}/Makefile.OLD

.PHONY: nti-hdparm-configured

nti-hdparm-configured: nti-hdparm-extracted ${NTI_HDPARM_CONFIGURED}

${NTI_HDPARM_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_HDPARM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[ 	]/		{ s/?// ; s%g*cc%'${NUI_CC_PREFIX}'cc% }' \
			| sed '/^binprefix[ 	]/	s%[^=]*$$%'${NTI_TC_ROOT}'%' \
			| sed '/^manprefix[ 	]/	s%[^=]*$$%'${NTI_TC_ROOT}'%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_HDPARM_BUILT=${EXTTEMP}/${NTI_HDPARM_TEMP}/hdparm

.PHONY: nti-hdparm-built
nti-hdparm-built: nti-hdparm-configured ${NTI_HDPARM_BUILT}

${NTI_HDPARM_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_HDPARM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_HDPARM_INSTALLED=${NTI_TC_ROOT}/sbin/hdparm

.PHONY: nti-hdparm-installed

nti-hdparm-installed: nti-hdparm-built ${NTI_HDPARM_INSTALLED}

${NTI_HDPARM_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_HDPARM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-hdparm
nti-hdparm: nti-hdparm-installed

NTARGETS+= nti-hdparm

endif	# HAVE_HDPARM_CONFIG
