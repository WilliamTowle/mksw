# fMSX v4.8			[ EARLIEST v0.5.0, c.2012-12-25 ]
# last mod WmT, 2017-03-13	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_FMSX_CONFIG},y)
HAVE_FMSX_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-fmsx' -- fMSX"

include ${CFG_ROOT}/tools/unzip/v60.mak

ifeq (${FMSX_VERSION},)
#FMSX_VERSION=47
FMSX_VERSION=48
endif

FMSX_SRC=${SOURCES}/f/fMSX${FMSX_VERSION}.zip
URLS+= http://fms.komkon.org/fMSX/fMSX${FMSX_VERSION}.zip


NTI_FMSX_TEMP=nti-FMSX-${FMSX_VERSION}

NTI_FMSX_EXTRACTED=${EXTTEMP}/${NTI_FMSX_TEMP}/fMSX/Unix/Makefile
NTI_FMSX_CONFIGURED=${EXTTEMP}/${NTI_FMSX_TEMP}/config.log
NTI_FMSX_BUILT=${EXTTEMP}/${NTI_FMSX_TEMP}/fMSX/Unix/fmsx
NTI_FMSX_INSTALLED=${NTI_TC_ROOT}/usr/bin/fmsx


## ,-----
## |	Extract
## +-----

${NTI_FMSX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/fMSX-${FMSX_VERSION} ] || rm -rf ${EXTTEMP}/fMSX-${FMSX_VERSION}
	#zcat ${FMSX_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${FMSX_SRC} -d ${EXTTEMP}/fMSX-${FMSX_VERSION}
	[ ! -d ${EXTTEMP}/${NTI_FMSX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FMSX_TEMP}
	mv ${EXTTEMP}/fMSX-${FMSX_VERSION} ${EXTTEMP}/${NTI_FMSX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FMSX_CONFIGURED}: ${NTI_FMSX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		touch ${NTI_FMSX_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_FMSX_BUILT}: ${NTI_FMSX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		make -C fMSX/Unix/ \
	)


## ,-----
## |	Install
## +-----

${NTI_FMSX_INSTALLED}: ${NTI_FMSX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		echo '...cp fMSX/Unix/fmsx SOMEWHERE' 1>&2 ;\
		exit 1 \
	)

##

.PHONY: nti-fmsx
nti-fmsx: nti-unzip \
	${NTI_FMSX_INSTALLED}

ALL_NTI_TARGETS+= nti-fmsx

endif	# HAVE_FMSX_CONFIG
