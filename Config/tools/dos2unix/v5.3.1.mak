# dos2unix v5.3.1		[ since v5.2, c.2011-02-03 ]
# last mod WmT, 2011-08-10	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_DOS2UNIX_CONFIG},y)
HAVE_DOS2UNIX_CONFIG:=y

DESCRLIST+= "'nti-dos2unix' -- dos2unix"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

#DOS2UNIX_VER=5.2
#DOS2UNIX_VER=5.2.1
#DOS2UNIX_VER=5.3
DOS2UNIX_VER=5.3.1
DOS2UNIX_SRC=${SRCDIR}/d/dos2unix-${DOS2UNIX_VER}.tar.gz

#URLS+= http://www.xs4all.nl/~waterlan/dos2unix/dos2unix-${DOS2UNIX_VER}.tar.gz
URLS+= http://waterlan.home.xs4all.nl/dos2unix/dos2unix-5.3.1.tar.gz


## ,-----
## |	Extract
## +-----

NTI_DOS2UNIX_TEMP=nti-dos2unix-${DOS2UNIX_VER}

NTI_DOS2UNIX_EXTRACTED=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/Makefile

.PHONY: nti-dos2unix-extracted

nti-dos2unix-extracted: ${NTI_DOS2UNIX_EXTRACTED}

${NTI_DOS2UNIX_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DOS2UNIX_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${DOS2UNIX_SRC}
	mv ${EXTTEMP}/dos2unix-${DOS2UNIX_VER} ${EXTTEMP}/${NTI_DOS2UNIX_TEMP}


## ,-----
## |	Configure
## +-----

NTI_DOS2UNIX_CONFIGURED=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/Makefile.OLD

.PHONY: nti-dos2unix-configured

nti-dos2unix-configured: nti-dos2unix-extracted ${NTI_DOS2UNIX_CONFIGURED}

${NTI_DOS2UNIX_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^prefix/	s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CC[ 	]/	{ s/?// ; s%g*cc%'${NUI_CC_PREFIX}'cc% }' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_DOS2UNIX_BUILT=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/dos2unix

.PHONY: nti-dos2unix-built
nti-dos2unix-built: nti-dos2unix-configured ${NTI_DOS2UNIX_BUILT}

## [v5.2] default 'make' invocation implies 'ENABLE_NLS=1'
${NTI_DOS2UNIX_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_DOS2UNIX_INSTALLED=${NTI_TC_ROOT}/usr/bin/dos2unix

.PHONY: nti-dos2unix-installed

nti-dos2unix-installed: nti-dos2unix-built ${NTI_DOS2UNIX_INSTALLED}

${NTI_DOS2UNIX_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${NTI_TC_ROOT}/usr/sbin
	mkdir -p ${NTI_TC_ROOT}/usr/man/man8
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-dos2unix
nti-dos2unix: nti-dos2unix-installed

NTARGETS+= nti-dos2unix

endif	# HAVE_DOS2UNIX_CONFIG
