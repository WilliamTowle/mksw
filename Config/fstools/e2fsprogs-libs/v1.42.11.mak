# e2fsprogs-libs 1.42.11	[ since v1.38, 2007-03-13 ]
# last mod WmT, 2014-07-17	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_E2FSPROGS_LIBS_CONFIG},y)
HAVE_E2FSPROGS_LIBS_CONFIG:=y

DESCRLIST+= "'nti-e2fsprogs' -- e2fsprogs"

ifeq (${E2FSPROGS_VERSION},)
E2FSPROGS_LIBS_VERSION=1.42.11
endif

E2FSPROGS_LIBS_SRC=${SOURCES}/e/e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION}.tar.gz
URLS+= https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.11/e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION}.tar.gz

NTI_E2FSPROGS_LIBS_TEMP=nti-e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION}

NTI_E2FSPROGS_LIBS_EXTRACTED=${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP}/configure
NTI_E2FSPROGS_LIBS_CONFIGURED=${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP}/config.log
NTI_E2FSPROGS_LIBS_BUILT=${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP}/resize/resize2fs
NTI_E2FSPROGS_LIBS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/resize2fs


## ,-----
## |	Extract
## +-----

${NTI_E2FSPROGS_LIBS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION} ] || rm -rf ${EXTTEMP}/e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION}
	zcat ${E2FSPROGS_LIBS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP}
	mv ${EXTTEMP}/e2fsprogs-libs-${E2FSPROGS_LIBS_VERSION} ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_E2FSPROGS_LIBS_CONFIGURED}: ${NTI_E2FSPROGS_LIBS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_E2FSPROGS_LIBS_BUILT}: ${NTI_E2FSPROGS_LIBS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_E2FSPROGS_LIBS_INSTALLED}: ${NTI_E2FSPROGS_LIBS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_LIBS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-e2fsprogs
nti-e2fsprogs: ${NTI_E2FSPROGS_LIBS_INSTALLED}

ALL_NTI_TARGETS+= nti-e2fsprogs

endif	# HAVE_E2FSPROGS_LIBS_CONFIG
