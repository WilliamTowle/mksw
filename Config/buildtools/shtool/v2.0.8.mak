# shtool v2.0.8			[ EARLIEST v2.0.8, c.2013-05-14 ]
# last mod WmT, 2013-05-14	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_SHTOOL_CONFIG},y)
HAVE_SHTOOL_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-shtool' -- shtool"

ifeq (${SHTOOL_VERSION},)
SHTOOL_VERSION=2.0.8
endif
SHTOOL_SRC=${SOURCES}/s/shtool-${SHTOOL_VERSION}.tar.gz

URLS+= http://mirrorservice.org/sites/ftp.gnu.org/gnu/shtool/shtool-${SHTOOL_VERSION}.tar.gz

NTI_SHTOOL_TEMP=nti-shtool-${SHTOOL_VERSION}

NTI_SHTOOL_EXTRACTED=${EXTTEMP}/${NTI_SHTOOL_TEMP}/README
NTI_SHTOOL_CONFIGURED=${EXTTEMP}/${NTI_SHTOOL_TEMP}/config.status
NTI_SHTOOL_BUILT=${EXTTEMP}/${NTI_SHTOOL_TEMP}/shtool
NTI_SHTOOL_INSTALLED=${NTI_TC_ROOT}/usr/bin/shtool

## ,-----
## |	Extract
## +-----

${NTI_SHTOOL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/shtool-${SHTOOL_VERSION} ] || rm -rf ${EXTTEMP}/shtool-${SHTOOL_VERSION}
	zcat ${SHTOOL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SHTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SHTOOL_TEMP}
	mv ${EXTTEMP}/shtool-${SHTOOL_VERSION} ${EXTTEMP}/${NTI_SHTOOL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SHTOOL_CONFIGURED}: ${NTI_SHTOOL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SHTOOL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SHTOOL_BUILT}: ${NTI_SHTOOL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SHTOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SHTOOL_INSTALLED}: ${NTI_SHTOOL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SHTOOL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-shtool
nti-shtool: ${NTI_SHTOOL_INSTALLED}

ALL_NTI_TARGETS+= nti-shtool

endif	# HAVE_SHTOOL_CONFIG
