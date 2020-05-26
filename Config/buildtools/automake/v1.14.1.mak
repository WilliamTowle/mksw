# automake v1.14.1		[ EARLIEST v?.?, c.????-??-?? ]
# last mod WmT, 2014-04-01	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_AUTOMAKE_CONFIG},y)
HAVE_AUTOMAKE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-automake' -- automake"

ifeq (${AUTOMAKE_VERSION},)
#AUTOMAKE_VERSION=1.9.1
#AUTOMAKE_VERSION=1.13.1
AUTOMAKE_VERSION=1.14.1
endif

#AUTOMAKE_SRC=${SOURCES}/a/automake-${AUTOMAKE_VERSION}.tar.bz2
AUTOMAKE_SRC=${SOURCES}/a/automake-${AUTOMAKE_VERSION}.tar.gz
URLS+= http://ftp.gnu.org/gnu/automake/automake-${AUTOMAKE_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak

NTI_AUTOMAKE_TEMP=nti-automake-${AUTOMAKE_VERSION}

NTI_AUTOMAKE_EXTRACTED=${EXTTEMP}/${NTI_AUTOMAKE_TEMP}/README
NTI_AUTOMAKE_CONFIGURED=${EXTTEMP}/${NTI_AUTOMAKE_TEMP}/config.status
NTI_AUTOMAKE_BUILT=${EXTTEMP}/${NTI_AUTOMAKE_TEMP}/bin/automake
NTI_AUTOMAKE_INSTALLED=${NTI_TC_ROOT}/usr/bin/automake

AUTOMAKE_SHAREDIR=${NTI_TC_ROOT}/usr/share/automake-1.14


## ,-----
## |	Extract
## +-----

${NTI_AUTOMAKE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/automake-${AUTOMAKE_VERSION} ] || rm -rf ${EXTTEMP}/automake-${AUTOMAKE_VERSION}
	zcat ${AUTOMAKE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AUTOMAKE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AUTOMAKE_TEMP}
	mv ${EXTTEMP}/automake-${AUTOMAKE_VERSION} ${EXTTEMP}/${NTI_AUTOMAKE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_AUTOMAKE_CONFIGURED}: ${NTI_AUTOMAKE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_AUTOMAKE_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_AUTOMAKE_BUILT}: ${NTI_AUTOMAKE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_AUTOMAKE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_AUTOMAKE_INSTALLED}: ${NTI_AUTOMAKE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_AUTOMAKE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-automake
nti-automake: nti-autoconf ${NTI_AUTOMAKE_INSTALLED}

ALL_NTI_TARGETS+= nti-automake

endif	# HAVE_AUTOMAKE_CONFIG
