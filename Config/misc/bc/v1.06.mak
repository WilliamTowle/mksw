# bc  v0.37.1		[ since v0.37.1, 2013-04-14 ]
# last mod WmT, 2013-04-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_BC_CONFIG},y)
HAVE_BC_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-bc' -- bc"

ifeq (${BC_VERSION},)
BC_VERSION=1.06
endif

BC_SRC=${SOURCES}/b/bc-${BC_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/bc/bc-${BC_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_BC_TEMP=nti-bc-${BC_VERSION}

NTI_BC_EXTRACTED=${EXTTEMP}/${NTI_BC_TEMP}/README
NTI_BC_CONFIGURED=${EXTTEMP}/${NTI_BC_TEMP}/config.log
NTI_BC_BUILT=${EXTTEMP}/${NTI_BC_TEMP}/bc
NTI_BC_INSTALLED=${NTI_TC_ROOT}/usr/bin/bc


## ,-----
## |	Extract
## +-----

${NTI_BC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bc-${BC_VERSION} ] || rm -rf ${EXTTEMP}/bc-${BC_VERSION}
	zcat ${BC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BC_TEMP}
	mv ${EXTTEMP}/bc-${BC_VERSION} ${EXTTEMP}/${NTI_BC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BC_CONFIGURED}: ${NTI_BC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BC_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BC_BUILT}: ${NTI_BC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BC_INSTALLED}: ${NTI_BC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BC_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-bc
nti-bc: nti-flex ${NTI_BC_INSTALLED}

ALL_NTI_TARGETS+= nti-bc

endif	# HAVE_BC_CONFIG
