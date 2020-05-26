# genext2fs 1.4.1		[ since v1.4.1, 2009-01-22 ]
# last mod WmT, 2011-08-29	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_GENEXT2FS_CONFIG},y)
HAVE_GENEXT2FS_CONFIG:=y

#DESCRLIST+= "'nti-genext2fs' -- genext2fs"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${GENEXT2FS_VERSION},)
GENEXT2FS_VERSION=1.4.1
endif

GENEXT2FS_SRC=${SOURCES}/g/genext2fs-${GENEXT2FS_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/genext2fs/genext2fs/1.4.1/genext2fs-1.4.1.tar.gz?use_mirror=ignum

NTI_GENEXT2FS_TEMP=nti-genext2fs-${GENEXT2FS_VERSION}

NTI_GENEXT2FS_EXTRACTED=${EXTTEMP}/${NTI_GENEXT2FS_TEMP}/configure
NTI_GENEXT2FS_CONFIGURED=${EXTTEMP}/${NTI_GENEXT2FS_TEMP}/config.status
NTI_GENEXT2FS_BUILT=${EXTTEMP}/${NTI_GENEXT2FS_TEMP}/genext2fs
NTI_GENEXT2FS_INSTALLED=${NTI_TC_ROOT}/usr/bin/genext2fs


## ,-----
## |	Extract
## +-----

${NTI_GENEXT2FS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/genext2fs-${GENEXT2FS_VERSION} ] || rm -rf ${EXTTEMP}/genext2fs-${GENEXT2FS_VERSION}
	zcat ${GENEXT2FS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GENEXT2FS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GENEXT2FS_TEMP}
	mv ${EXTTEMP}/genext2fs-${GENEXT2FS_VERSION} ${EXTTEMP}/${NTI_GENEXT2FS_TEMP}



# ,-----
# |	Configure
# +-----

${NTI_GENEXT2FS_CONFIGURED}: ${NTI_GENEXT2FS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GENEXT2FS_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_GENEXT2FS_BUILT}: ${NTI_GENEXT2FS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GENEXT2FS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_GENEXT2FS_INSTALLED}: ${NTI_GENEXT2FS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GENEXT2FS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-genext2fs
nti-genext2fs: ${NTI_GENEXT2FS_INSTALLED}

ALL_NTI_TARGETS+= nti-genext2fs

endif	# HAVE_GENEXT2FS_CONFIG
