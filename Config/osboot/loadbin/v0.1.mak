# loadbin v0.1			[ since v0.1, c.2015-12-23 ]
# last mod WmT, 2015-12-23	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_LOADBIN_CONFIG},y)
HAVE_LOADBIN_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LOADBIN_VERSION},)
LOADBIN_VERSION=0.1
endif

LOADBIN_SRC= ${SOURCES}/l/loadbin-0.1-src-2008-03-01.zip
URLS+= http://download.gna.org/grubutil/loadbin-0.1-src-2008-03-01.zip

NTI_LOADBIN_TEMP=		nti-loadbin-${LOADBIN_VERSION}

NTI_LOADBIN_EXTRACTED=	${EXTTEMP}/${NTI_LOADBIN_TEMP}/Makefile
NTI_LOADBIN_CONFIGURED=	${EXTTEMP}/${NTI_LOADBIN_TEMP}/Makefile.OLD
NTI_LOADBIN_BUILT=	${EXTTEMP}/${NTI_LOADBIN_TEMP}/loadbin
NTI_LOADBIN_INSTALLED=	${NTI_TC_ROOT}/usr/lib/loadbin/loadbin


## ,-----
## |	Extract
## +-----

${NTI_LOADBIN_EXTRACTED}:
	[ ! -d ${EXTTEMP}/loadbin-${LOADBIN_VERSION} ] || rm -rf ${EXTTEMP}/loadbin-${LOADBIN_VERSION}
	( mkdir ${EXTTEMP}/loadbin-${LOADBIN_VERSION} && unzip -d ${EXTTEMP}/loadbin-${LOADBIN_VERSION} ${LOADBIN_SRC} )
	[ ! -d ${EXTTEMP}/${NTI_LOADBIN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LOADBIN_TEMP}
	mv ${EXTTEMP}/loadbin-${LOADBIN_VERSION} ${EXTTEMP}/${NTI_LOADBIN_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LOADBIN_CONFIGURED}: ${NTI_LOADBIN_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LOADBIN_TEMP} || exit 1 ;\
		cp Makefile Makefile.OLD \
	)


## ,-----
## |	Build
## +-----

${NTI_LOADBIN_BUILT}: ${NTI_LOADBIN_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LOADBIN_TEMP} || exit 1 ;\
		make ldgrub.bin ldgrub2.bin ldntldr.bin \
	)


## ,-----
## |	Install
## +-----

${NTI_LOADBIN_INSTALLED}: ${NTI_LOADBIN_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LOADBIN_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/loadbin || exit 1 ;\
		cp ldgrub.bin ldgrub2.bin ldntldr.bin ${NTI_TC_ROOT}/usr/lib/loadbin/ \
	)

.PHONY: nti-loadbin
nti-loadbin: ${NTI_LOADBIN_INSTALLED}

ALL_NTI_TARGETS+= nti-loadbin

endif	# HAVE_LOADBIN_CONFIG
