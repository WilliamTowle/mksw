# dos2unix v7.3.4		[ since v5.2, c.2011-02-03 ]
# last mod WmT, 2016-06-01	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_DOS2UNIX_CONFIG},y)
HAVE_DOS2UNIX_CONFIG:=y

#DESCRLIST+= "'nti-dos2unix' -- dos2unix"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DOS2UNIX_VERSION},)
#DOS2UNIX_VERSION=5.2.1
#DOS2UNIX_VERSION=5.3
#DOS2UNIX_VERSION=5.3.1
#DOS2UNIX_VERSION=7.1
#DOS2UNIX_VERSION=7.2.2
#DOS2UNIX_VERSION=7.2.3
#DOS2UNIX_VERSION=7.3.3
DOS2UNIX_VERSION=7.3.4
endif

DOS2UNIX_SRC=${SOURCES}/d/dos2unix-${DOS2UNIX_VERSION}.tar.gz
#URLS+= http://www.xs4all.nl/~waterlan/dos2unix/dos2unix-${DOS2UNIX_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/dos2unix/dos2unix/${DOS2UNIX_VERSION}/dos2unix-${DOS2UNIX_VERSION}.tar.gz?use_mirror=ignum

##

CUI_DOS2UNIX_TEMP=cui-dos2unix-${DOS2UNIX_VERSION}

CUI_DOS2UNIX_EXTRACTED=${EXTTEMP}/${CUI_DOS2UNIX_TEMP}/dos2unix.c
CUI_DOS2UNIX_CONFIGURED=${EXTTEMP}/${CUI_DOS2UNIX_TEMP}/Makefile.OLD
CUI_DOS2UNIX_BUILT=${EXTTEMP}/${CUI_DOS2UNIX_TEMP}/dos2unix
CUI_DOS2UNIX_INSTALLED=${INSTTEMP}/usr/bin/dos2unix


NTI_DOS2UNIX_TEMP=nti-dos2unix-${DOS2UNIX_VERSION}

NTI_DOS2UNIX_EXTRACTED=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/dos2unix.c
NTI_DOS2UNIX_CONFIGURED=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/Makefile.OLD
NTI_DOS2UNIX_BUILT=${EXTTEMP}/${NTI_DOS2UNIX_TEMP}/dos2unix
NTI_DOS2UNIX_INSTALLED=${NTI_TC_ROOT}/usr/bin/dos2unix


## ,-----
## |	Extract
## +-----

${CUI_DOS2UNIX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION} ] || rm -rf ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION}
	#bzcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_DOS2UNIX_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_DOS2UNIX_TEMP}
	mv ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION} ${EXTTEMP}/${CUI_DOS2UNIX_TEMP}

##

${NTI_DOS2UNIX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION} ] || rm -rf ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION}
	#bzcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${DOS2UNIX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DOS2UNIX_TEMP}
	mv ${EXTTEMP}/dos2unix-${DOS2UNIX_VERSION} ${EXTTEMP}/${NTI_DOS2UNIX_TEMP}


## ,-----
## |	Configure
## +-----

## [2014-10-07] Have 'ENABLE_NLS' undefined (need 'msgfmt' otherwise)

${CUI_DOS2UNIX_CONFIGURED}: ${CUI_DOS2UNIX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DOS2UNIX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ENABLE_NLS/	s/^/#/' \
			| sed '/^CC[ 	]/	{ s/?// ; s%g*cc%'${CUI_GCC}'% }' \
			> Makefile || exit 1 \
	)

##

${NTI_DOS2UNIX_CONFIGURED}: ${NTI_DOS2UNIX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ENABLE_NLS/	s/^/#/' \
			| sed '/^prefix/	s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CC[ 	]/	{ s/?// ; s%g*cc%'${NTI_GCC}'% }' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

## [v5.2] default 'make' invocation implies 'ENABLE_NLS=1'
${CUI_DOS2UNIX_BUILT}: ${CUI_DOS2UNIX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DOS2UNIX_TEMP} || exit 1 ;\
		make \
	)

##

## [v5.2] default 'make' invocation implies 'ENABLE_NLS=1'
${NTI_DOS2UNIX_BUILT}: ${NTI_DOS2UNIX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CUI_DOS2UNIX_INSTALLED}: ${CUI_DOS2UNIX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CUI_DOS2UNIX_TEMP} || exit 1 ;\
		make install DESTDIR=${INSTTEMP} \
	)

.PHONY: cui-dos2unix
cui-dos2unix: ${CUI_DOS2UNIX_INSTALLED}

ALL_CUI_TARGETS+= cui-dos2unix

##

${NTI_DOS2UNIX_INSTALLED}: ${NTI_DOS2UNIX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DOS2UNIX_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-dos2unix
nti-dos2unix: ${NTI_DOS2UNIX_INSTALLED}

ALL_NTI_TARGETS+= nti-dos2unix

endif	# HAVE_DOS2UNIX_CONFIG
