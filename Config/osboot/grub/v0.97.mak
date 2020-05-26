# grub v0.97			[ since v0.93, c.2003-06-04 ]
# last mod WmT, 2012-10-22	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_GRUB_CONFIG},y)
HAVE_GRUB_CONFIG:=y

#DESCRLIST+= "'nti-grub' -- GNU GrUB"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GRUB_VERSION},)
GRUB_VERSION=0.97
endif

#include ${CFG_ROOT}/buildtools/binutils/v2.22.mak

GRUB_SRC=${SOURCES}/g/grub-${GRUB_VERSION}.tar.gz
URLS+=http://www.mirrorservice.org/sites/alpha.gnu.org/gnu/grub/grub-${GRUB_VERSION}.tar.gz

NTI_GRUB_TEMP=nti-grub-${GRUB_VERSION}
NTI_GRUB_EXTRACTED=${EXTTEMP}/${NTI_GRUB_TEMP}/configure
NTI_GRUB_CONFIGURED=${EXTTEMP}/${NTI_GRUB_TEMP}/config.log
NTI_GRUB_BUILT=${EXTTEMP}/${NTI_GRUB_TEMP}/grub
NTI_GRUB_INSTALLED=${NTI_TC_ROOT}/usr/sbin/grub


## ,-----
## |	Extract
## +-----

${NTI_GRUB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_GRUB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GRUB_TEMP}
	zcat ${GRUB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GRUB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GRUB_TEMP}
	mv ${EXTTEMP}/grub-${GRUB_VERSION} ${EXTTEMP}/${NTI_GRUB_TEMP}


## ,-----
## |	Configure
## +-----

## binutils >= ~2.17/18: ld needs '--build-id=none'
${NTI_GRUB_CONFIGURED}: ${NTI_GRUB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GRUB_TEMP} || exit 1 ;\
	  CFLAGS='-Wl,--build-id=none' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_GRUB_BUILT}: ${NTI_GRUB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GRUB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_GRUB_INSTALLED}: ${NTI_GRUB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GRUB_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-grub
nti-grub: ${NTI_GRUB_INSTALLED}
#nti-grub: nti-binutils ${NTI_GRUB_INSTALLED}

ALL_NTI_TARGETS+= nti-grub

endif	# HAVE_GRUB_CONFIG
