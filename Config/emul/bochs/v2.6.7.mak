# bochs v2.6.7			[ since v?.?, c.????-??-?? ]
# last mod WmT, 2014-11-05	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_BOCHS_CONFIG},y)
HAVE_BOCHS_CONFIG:=y

DESCRLIST+= "'nti-bochs' -- bochs"

include ${CFG_ROOT}/ENV/buildtype.mak

#ifneq (${HAVE_NATIVE_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
#endif

ifeq (${BOCHS_VERSION},)
#BOCHS_VERSION=2.4.5
#BOCHS_VERSION=2.4.6
BOCHS_VERSION=2.6.7
endif

BOCHS_SRC=${SOURCES}/b/bochs-${BOCHS_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/bochs/bochs/2.4.6/bochs-2.4.5.tar.gz?use_mirror=surfnet
URLS+= http://fossies.org/linux/misc/bochs-${BOCHS_VERSION}.tar.gz


NTI_BOCHS_TEMP=nti-bochs-${BOCHS_VERSION}

NTI_BOCHS_EXTRACTED=${EXTTEMP}/${NTI_BOCHS_TEMP}/Makefile
NTI_BOCHS_CONFIGURED=${EXTTEMP}/${NTI_BOCHS_TEMP}/config.status
NTI_BOCHS_BUILT=${EXTTEMP}/${NTI_BOCHS_TEMP}/bochs
NTI_BOCHS_INSTALLED=${NTI_TC_ROOT}/usr/bin/bochs


## ,-----
## |	Extract
## +-----

${NTI_BOCHS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/make-${BOCHS_VERSION} ] || rm -rf ${EXTTEMP}/bochs-${BOCHS_VERSION}
	zcat ${BOCHS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BOCHS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BOCHS_TEMP}
	mv ${EXTTEMP}/bochs-${BOCHS_VERSION} ${EXTTEMP}/${NTI_BOCHS_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_BOCHS_CONFIGURED}: ${NTI_BOCHS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_BOCHS_BUILT}: ${NTI_BOCHS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_BOCHS_INSTALLED}: ${NTI_BOCHS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-bochs
#nti-bochs: nti-native-gcc nti-bochs-installed
nti-bochs: ${NTI_BOCHS_INSTALLED}

ALL_NTI_TARGETS+= nti-bochs

endif	# HAVE_BOCHS_CONFIG
