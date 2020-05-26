# twin v0.6.2			[ since v0.5.1, c. 2004-05-29 ]
# last mod WmT, 2015-06-18	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_TWIN_CONFIG},y)
HAVE_TWIN_CONFIG:=y

DESCRLIST+= "'nti-twin' -- twin"

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-twin' -- twin"

ifeq (${TWIN_VERSION},)
TWIN_VERSION:=0.6.2
endif

TWIN_SRC=${SOURCES}/t/twin-0.6.2.tar.gz

#URLS+= http://linuz.sns.it/~max/twin/twin-0.6.2.tar.gz
URLS+= http://downloads.sourceforge.net/project/twin/twin/0.6.2/twin-0.6.2.tar.gz?use_mirror=ignum

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

NTI_TWIN_TEMP=nti-twin-${TWIN_VERSION}

NTI_TWIN_EXTRACTED=${EXTTEMP}/${NTI_TWIN_TEMP}/INSTALL
NTI_TWIN_CONFIGURED=${EXTTEMP}/${NTI_TWIN_TEMP}/config.log
NTI_TWIN_BUILT=${EXTTEMP}/${NTI_TWIN_TEMP}/server/twin
NTI_TWIN_INSTALLED=${NTI_TC_ROOT}/usr/bin/twstart


## ,-----
## |	Extract
## +-----


${NTI_TWIN_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/twin-${TWIN_VERSION} ] || rm -rf ${EXTTEMP}/twin-${TWIN_VERSION}
	zcat ${TWIN_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TWIN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TWIN_TEMP}
	mv ${EXTTEMP}/twin-${TWIN_VERSION} ${EXTTEMP}/${NTI_TWIN_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_TWIN_CONFIGURED}: ${NTI_TWIN_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		ECHO_E=echo \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#	  ac_cv_file__dev_ptmx=no \


## ,-----
## |	Build
## +-----

${NTI_TWIN_BUILT}: ${NTI_TWIN_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TWIN_INSTALLED}: ${NTI_TWIN_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TWIN_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-twin
nti-twin: ${NTI_TWIN_INSTALLED}

ALL_NTI_TARGETS+= nti-twin

endif	# HAVE_TWIN_CONFIG
