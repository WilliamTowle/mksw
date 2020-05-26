# file v5.09			[ since v4.07, c.2004-01-22 ]
# last mod WmT, 2012-12-25	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_FILE_CONFIG},y)
HAVE_FILE_CONFIG:=y

#DESCRLIST+= "'nti-file' -- file"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${FILE_VERSION},)
#FILE_VERSION=4.24
FILE_VERSION=5.09
endif
FILE_SRC=${SOURCES}/f/file-${FILE_VERSION}.tar.gz

URLS+= ftp://ftp.astron.com/pub/file/file-${FILE_VERSION}.tar.gz

NTI_FILE_TEMP=nti-file-${FILE_VERSION}

NTI_FILE_EXTRACTED=${EXTTEMP}/${NTI_FILE_TEMP}/README
NTI_FILE_CONFIGURED=${EXTTEMP}/${NTI_FILE_TEMP}/config.status
NTI_FILE_BUILT=${EXTTEMP}/${NTI_FILE_TEMP}/src/file
NTI_FILE_INSTALLED=${NTI_TC_ROOT}/usr/bin/file


## ,-----
## |	Extract
## +-----

${NTI_FILE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/file-${FILE_VERSION} ] || rm -rf ${EXTTEMP}/file-${FILE_VERSION}
	zcat ${FILE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FILE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FILE_TEMP}
	mv ${EXTTEMP}/file-${FILE_VERSION} ${EXTTEMP}/${NTI_FILE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FILE_CONFIGURED}: ${NTI_FILE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FILE_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FILE_BUILT}: ${NTI_FILE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FILE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FILE_INSTALLED}: ${NTI_FILE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FILE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-file
nti-file: ${NTI_FILE_INSTALLED}

ALL_NTI_TARGETS+= nti-file

endif	# HAVE_FILE_CONFIG
