# busybox v1.23.2		[ earliest v?.??, c.????-??-?? ]
# last mod WmT, 2014-03-29	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_BUSYBOX_CONFIG},y)
HAVE_BUSYBOX_CONFIG:=y

#DESCRLIST+= "'nti-busybox' -- busybox"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${BUSYBOX_VERSION},)
#BUSYBOX_VERSION=1.21.1
#BUSYBOX_VERSION=1.22.1
BUSYBOX_VERSION=1.23.2
endif

BUSYBOX_SRC=${SOURCES}/b/busybox-${BUSYBOX_VERSION}.tar.bz2
URLS+= http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_BUSYBOX_TEMP=nti-busybox-${BUSYBOX_VERSION}

NTI_BUSYBOX_EXTRACTED=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/LICENSE
NTI_BUSYBOX_CONFIGURED=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/.config
NTI_BUSYBOX_BUILT=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/busybox.links
NTI_BUSYBOX_INSTALLED=${NTI_TC_ROOT}/usr/bin/busybox


## ,-----
## |	Extract
## +-----

${NTI_BUSYBOX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/busybox-${BUSYBOX_VERSION} ] || rm -rf ${EXTTEMP}/busybox-${BUSYBOX_VERSION}
	bzcat ${BUSYBOX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BUSYBOX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BUSYBOX_TEMP}
	mv ${EXTTEMP}/busybox-${BUSYBOX_VERSION} ${EXTTEMP}/${NTI_BUSYBOX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BUSYBOX_CONFIGURED}: ${NTI_BUSYBOX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		( \
		  echo 'USING_CROSS_COMPILER=n' ;\
		  echo 'CONFIG_PREFIX="'${NTI_TC_ROOT}'/usr"' ;\
		  echo 'CONFIG_BZIP2=y' ;\
		  echo 'CONFIG_GZIP=y' ;\
		  echo 'CONFIG_TAR=y' ;\
		  echo 'CONFIG_FEATURE_TAR_GZIP=y' \
		) > .config ;\
		yes '' | make oldconfig \
	)
#	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
#		( \
#		  echo 'USING_CROSS_COMPILER=n' ;\
#		  echo 'PREFIX='${NTI_TC_ROOT}'/usr' \
#		) > .config ;\
#		case ${BUSYBOX_VERSION} in \
#		1.22.1) \
#		;; \
#		*) \
#			echo "Unexpected BUSYBOX_VERSION ${BUSYBOX_VERSION}" 1>&2 ;\
#			exit 1 \
#		;; \
#		esac >> .config \
#	}


## ,-----
## |	Build
## +-----

${NTI_BUSYBOX_BUILT}: ${NTI_BUSYBOX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		case ${BUSYBOX_VERSION} in \
		1.1[6-9]*.*|1.2[012].?) \
			make KBUILD_VERBOSE=1 \
		;; \
		1.23.2) \
			make \
		;; \
		*) \
			echo "Unexpected BUSYBOX_VERSION ${BUSYBOX_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Install
## +-----

${NTI_BUSYBOX_INSTALLED}: ${NTI_BUSYBOX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-busybox
nti-busybox: ${NTI_BUSYBOX_INSTALLED}

ALL_NTI_TARGETS+= nti-busybox

endif	# HAVE_BUSYBOX_CONFIG
