# linuxlogo v4.20110913		[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LINUXLOGO_CONFIG},y)
HAVE_LINUXLOGO_CONFIG:=y

#DESCRLIST+= "'nti-linuxlogo' -- linuxlogo"
#DESCRLIST+= "'cti-linuxlogo' -- linuxlogo"

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/autoconf/v2.65.mak
#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak

ifeq (${LINUXLOGO_VERSION},)
LINUXLOGO_VERSION=4.20110913
endif

LINUXLOGO_SRC=${SOURCES}/l/linuxlogo-${LINUXLOGO_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/linuxlogo/linuxlogo/linuxlogo-4.20110913/linuxlogo-4.20110913.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flinuxlogo%2Ffiles%2Flinuxlogo%2Flinuxlogo-4.20110913%2F&ts=1316075922&use_mirror=netcologne'

include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_LINUXLOGO_TEMP=nti-linuxlogo-${LINUXLOGO_VERSION}

NTI_LINUXLOGO_EXTRACTED=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/configure
NTI_LINUXLOGO_CONFIGURED=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/config.status
NTI_LINUXLOGO_BUILT=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/linuxlogo
NTI_LINUXLOGO_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/linuxlogo


## ,-----
## |	Extract
## +-----

${NTI_LINUXLOGO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION} ] || rm -rf ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION}
	zcat ${LINUXLOGO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}
	mv ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION} ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LINUXLOGO_CONFIGURED}: ${NTI_LINUXLOGO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2 -I'${NTI_TC_ROOT}'/opt/microwindows/include/' \
	  LDFLAGS='-L'${NTI_TC_ROOT}'/opt/microwindows/lib/' \
	  LIBS='-lNX11 -lnano-X' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			|| exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_LINUXLOGO_BUILT}: ${NTI_LINUXLOGO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LINUXLOGO_INSTALLED}: ${NTI_LINUXLOGO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-linuxlogo
#nti-linuxlogo: nti-autoconf nti-automake \
#	${NTI_LINUXLOGO_INSTALLED}
nti-linuxlogo: nti-nxlib \
	${NTI_LINUXLOGO_INSTALLED}

ALL_NTI_TARGETS+= nti-linuxlogo

endif	# HAVE_LINUXLOGO_CONFIG
