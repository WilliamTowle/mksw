# miscom v1.0			[ since v1.0, c.2016-01-17 ]
# last mod WmT, 2016-01-17	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_MISCOM_CONFIG},y)
HAVE_MISCOM_CONFIG:=y

#DESCRLIST+= "'nti-miscom' -- miscom"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MISCOM_VERSION},)
MISCOM_VERSION=1.0
endif

MISCOM_SRC=${SOURCES}/m/miscom.tar.gz
URLS+= http://ibiblio.org/pub/linux/games/arcade/miscom.tar.gz

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_MISCOM_TEMP=nti-miscom-${MISCOM_VERSION}

NTI_MISCOM_EXTRACTED=${EXTTEMP}/${NTI_MISCOM_TEMP}/miscom.6
NTI_MISCOM_CONFIGURED=${EXTTEMP}/${NTI_MISCOM_TEMP}/Makefile
NTI_MISCOM_BUILT=${EXTTEMP}/${NTI_MISCOM_TEMP}/miscom
NTI_MISCOM_INSTALLED=${NTI_TC_ROOT}/usr/games/miscom


## ,-----
## |	Extract
## +-----

${NTI_MISCOM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/miscom-${MISCOM_VERSION} ] || rm -rf ${EXTTEMP}/miscom-${MISCOM_VERSION}
	[ ! -d ${EXTTEMP}/miscom ] || rm -rf ${EXTTEMP}/miscom
	zcat ${MISCOM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MISCOM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MISCOM_TEMP}
	#mv ${EXTTEMP}/miscom-${MISCOM_VERSION} ${EXTTEMP}/${NTI_MISCOM_TEMP}
	mv ${EXTTEMP}/miscom ${EXTTEMP}/${NTI_MISCOM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MISCOM_CONFIGURED}: ${NTI_MISCOM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MISCOM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS=/	s%-I[^ ]*ncurses%'"`${NCURSES_CONFIG_TOOL} --cflags`"'%' \
			| sed '/^LIBS=/		s%^%LDFLAGS=-L'"`${NCURSES_CONFIG_TOOL} --libdir`"'\n%' \
			| sed '/^[A-Z]*DIR=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/	s%$$(LIBS)%$$(LDFLAGS) $$(LIBS)%' \
			| sed '/^	/	s%mkdir $$%mkdir -p $$%' \
			| sed '/^	/	s%chmod 555%chmod 755%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MISCOM_BUILT}: ${NTI_MISCOM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MISCOM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_MISCOM_INSTALLED}: ${NTI_MISCOM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MISCOM_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/games/lib ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man ;\
		make install \
	)
#		cp miscom ${NTI_TC_ROOT}/usr/bin \

.PHONY: nti-miscom
nti-miscom: nti-ncurses ${NTI_MISCOM_INSTALLED}

ALL_NTI_TARGETS+= nti-miscom

endif	# HAVE_MISCOM_CONFIG
