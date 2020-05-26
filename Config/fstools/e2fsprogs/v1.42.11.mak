# e2fsprogs 1.42.11		[ since v1.38, 2007-03-13 ]
# last mod WmT, 2014-07-17	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_E2FSPROGS_CONFIG},y)
HAVE_E2FSPROGS_CONFIG:=y

DESCRLIST+= "'nti-e2fsprogs' -- e2fsprogs"

ifeq (${E2FSPROGS_VERSION},)
#E2FSPROGS_VERSION=1.41.12
#E2FSPROGS_VERSION=1.41.14
#E2FSPROGS_VERSION=1.42.5
E2FSPROGS_VERSION=1.42.11
endif

E2FSPROGS_SRC=${SOURCES}/e/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz
#URLS+= http://garr.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz
URLS+= https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.11/e2fsprogs-1.42.11.tar.gz

NTI_E2FSPROGS_TEMP=nti-e2fsprogs-${E2FSPROGS_VERSION}

NTI_E2FSPROGS_EXTRACTED=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/configure
NTI_E2FSPROGS_CONFIGURED=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/config.log
NTI_E2FSPROGS_BUILT=${EXTTEMP}/${NTI_E2FSPROGS_TEMP}/resize/resize2fs
NTI_E2FSPROGS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/resize2fs


## ,-----
## |	Extract
## +-----

${NTI_E2FSPROGS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/e2fsprogs-${E2FSPROGS_VERSION} ] || rm -rf ${EXTTEMP}/e2fsprogs-${E2FSPROGS_VERSION}
	zcat ${E2FSPROGS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_E2FSPROGS_TEMP}
	mv ${EXTTEMP}/e2fsprogs-${E2FSPROGS_VERSION} ${EXTTEMP}/${NTI_E2FSPROGS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_E2FSPROGS_CONFIGURED}: ${NTI_E2FSPROGS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_E2FSPROGS_BUILT}: ${NTI_E2FSPROGS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_E2FSPROGS_INSTALLED}: ${NTI_E2FSPROGS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_E2FSPROGS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-e2fsprogs
nti-e2fsprogs: ${NTI_E2FSPROGS_INSTALLED}

ALL_NTI_TARGETS+= nti-e2fsprogs

endif	# HAVE_E2FSPROGS_CONFIG
