# m4 v1.4.16			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2014-12-27	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_M4_CONFIG},y)
HAVE_M4_CONFIG:=y

#DESCRLIST+= "'nti-m4' -- m4"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${M4_VERSION},)
#M4_VERSION=1.4.12
M4_VERSION=1.4.16
endif

M4_SRC=${SOURCES}/m/m4-${M4_VERSION}.tar.bz2
URLS+= http://mirrorservice.org/sites/ftp.gnu.org/gnu/m4/m4-${M4_VERSION}.tar.bz2

NTI_M4_TEMP=nti-m4-${M4_VERSION}

NTI_M4_EXTRACTED=${EXTTEMP}/${NTI_M4_TEMP}/README
NTI_M4_CONFIGURED=${EXTTEMP}/${NTI_M4_TEMP}/config.status
NTI_M4_BUILT=${EXTTEMP}/${NTI_M4_TEMP}/src/m4
NTI_M4_INSTALLED=${NTI_TC_ROOT}/usr/bin/m4

## ,-----
## |	Extract
## +-----

${NTI_M4_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/m4-${M4_VERSION} ] || rm -rf ${EXTTEMP}/m4-${M4_VERSION}
	bzcat ${M4_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_M4_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_M4_TEMP}
	mv ${EXTTEMP}/m4-${M4_VERSION} ${EXTTEMP}/${NTI_M4_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_M4_CONFIGURED}: ${NTI_M4_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_M4_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_M4_BUILT}: ${NTI_M4_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_M4_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_M4_INSTALLED}: ${NTI_M4_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_M4_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-m4
nti-m4: ${NTI_M4_INSTALLED}

ALL_NTI_TARGETS+= nti-m4

endif	# HAVE_M4_CONFIG
