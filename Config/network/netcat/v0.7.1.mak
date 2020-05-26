# netcat v0.7.1			[ EARLIEST v?.?? ]
# last mod WmT, 2012-12-17	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_NETCAT_CONFIG},y)
HAVE_NETCAT_CONFIG:=y

##DESCRLIST+= "'nti-netcat' -- netcat"
##
##include ${CFG_ROOT}/ENV/ifbuild.env
##include ${CFG_ROOT}/ENV/native.mak
###include ${CFG_ROOT}/ENV/target.mak
#include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${NETCAT_VERSION},)
NETCAT_VERSION=0.7.1
endif

NETCAT_SRC=${SOURCES}/n/netcat-${NETCAT_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.gz?r=&ts=1355741775&use_mirror=ignum'

NTI_NETCAT_TEMP=nti-netcat-${NETCAT_VERSION}

NTI_NETCAT_EXTRACTED=${EXTTEMP}/${NTI_NETCAT_TEMP}/COPYING
NTI_NETCAT_CONFIGURED=${EXTTEMP}/${NTI_NETCAT_TEMP}/config.status
NTI_NETCAT_BUILT=${EXTTEMP}/${NTI_NETCAT_TEMP}/src/netcat
NTI_NETCAT_INSTALLED=${NTI_TC_ROOT}/usr/bin/netcat


## ,-----
## |	Extract
## +-----

${NTI_NETCAT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/netcat-${NETCAT_VERSION} ] || rm -rf ${EXTTEMP}/netcat-${NETCAT_VERSION}
	zcat ${NETCAT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NETCAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NETCAT_TEMP}
	mv ${EXTTEMP}/netcat-${NETCAT_VERSION} ${EXTTEMP}/${NTI_NETCAT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_NETCAT_CONFIGURED}: ${NTI_NETCAT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NETCAT_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_NETCAT_BUILT}: ${NTI_NETCAT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NETCAT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_NETCAT_INSTALLED}: ${NTI_NETCAT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NETCAT_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-netcat
nti-netcat: ${NTI_NETCAT_INSTALLED}

ALL_NTI_TARGETS+= nti-netcat

endif	# HAVE_NETCAT_CONFIG
