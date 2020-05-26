# bochs v2.4.6			[ since v?.?, c.????-??-?? ]
# last mod WmT, 2011-09-01	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_BOCHS_CONFIG},y)
HAVE_BOCHS_CONFIG:=y

DESCRLIST+= "'nti-bochs' -- bochs"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif

#BOCHS_VER=2.4.5
BOCHS_VER=2.4.6

BOCHS_SRC=${SRCDIR}/b/bochs-${BOCHS_VER}.tar.gz

#URLS+= http://downloads.sourceforge.net/project/bochs/bochs/2.4.6/bochs-2.4.5.tar.gz?use_mirror=surfnet
URLS+= 'http://downloads.sourceforge.net/project/bochs/bochs/2.4.6/bochs-2.4.6.tar.gz?r=&ts=1314877951&use_mirror=garr'


# ,-----
# |	Extract
# +-----

NTI_BOCHS_TEMP=nti-bochs-${BOCHS_VER}

NTI_BOCHS_EXTRACTED=${EXTTEMP}/${NTI_BOCHS_TEMP}/Makefile

.PHONY: nti-bochs-extracted

nti-bochs-extracted: ${NTI_BOCHS_EXTRACTED}

${NTI_BOCHS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_BOCHS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BOCHS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${BOCHS_SRC}
	mv ${EXTTEMP}/bochs-${BOCHS_VER} ${EXTTEMP}/${NTI_BOCHS_TEMP} \


# ,-----
# |	Configure
# +-----

NTI_BOCHS_CONFIGURED=${EXTTEMP}/${NTI_BOCHS_TEMP}/config.status

.PHONY: nti-bochs-configured

nti-bochs-configured: nti-bochs-extracted ${NTI_BOCHS_CONFIGURED}

${NTI_BOCHS_CONFIGURED}:
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

NTI_BOCHS_BUILT=${EXTTEMP}/${NTI_BOCHS_TEMP}/bochs

.PHONY: nti-bochs-built
nti-bochs-built: nti-bochs-configured ${NTI_BOCHS_BUILT}

${NTI_BOCHS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_BOCHS_INSTALLED=${NTI_TC_ROOT}/usr/bin/bochs

.PHONY: nti-bochs-installed

nti-bochs-installed: nti-bochs-built ${NTI_BOCHS_INSTALLED}

${NTI_BOCHS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BOCHS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-bochs
nti-bochs: nti-native-gcc nti-bochs-installed

NTARGETS+= nti-bochs

endif	# HAVE_BOCHS_CONFIG
