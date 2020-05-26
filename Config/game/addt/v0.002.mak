# addtraction v0.002		[ EARLIEST v?.?? ]
# last mod WmT, 2013-02-09	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_ADDTRACTION_CONFIG},y)
HAVE_ADDTRACTION_CONFIG:=y

#DESCRLIST+= "'nti-addtraction' -- addtraction"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

ifeq (${ADDTRACTION_VERSION},)
ADDTRACTION_VERSION=0.002
endif
ADDTRACTION_SRC=${SOURCES}/a/addt-${ADDTRACTION_VERSION}.tar.gz

URLS+= http://klack.sourceforge.net/addt/addt-0.002.tar.gz

NTI_ADDTRACTION_TEMP=nti-addtraction-${ADDTRACTION_VERSION}

NTI_ADDTRACTION_EXTRACTED=${EXTTEMP}/${NTI_ADDTRACTION_TEMP}/README
NTI_ADDTRACTION_CONFIGURED=${EXTTEMP}/${NTI_ADDTRACTION_TEMP}/addt.c.OLD
NTI_ADDTRACTION_BUILT=${EXTTEMP}/${NTI_ADDTRACTION_TEMP}/addt
NTI_ADDTRACTION_INSTALLED=${NTI_TC_ROOT}/usr/bin/addt


## ,-----
## |	Extract
## +-----

${NTI_ADDTRACTION_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/addt ] || rm -rf ${EXTTEMP}/addt
	zcat ${ADDTRACTION_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ADDTRACTION_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ADDTRACTION_TEMP}
	mv ${EXTTEMP}/addt ${EXTTEMP}/${NTI_ADDTRACTION_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ADDTRACTION_CONFIGURED}: ${NTI_ADDTRACTION_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ADDTRACTION_TEMP} || exit 1 ;\
		rm -f addt ;\
		[ -r Makefile.OLD ] || cp Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/see README/	s%$$%\n\nCC= gcc\n%' \
			| sed '/^CC=/		s%$$%\nCFLAGS= `${NTI_TC_ROOT}/usr/bin/sdl-config --cflags`%' \
			| sed '/^CFLAGS=/	s%$$%\nLDFLAGS= `${NTI_TC_ROOT}/usr/bin/sdl-config --libs`%' \
			| sed '/^BITMAP_PATH/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^INSTALL_PATH/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	gcc/ 	{ s%gcc%$${CC} $${CFLAGS} $${LDFLAGS}% }'\
			> Makefile ;\
		[ -r addt.c.OLD ] || cp addt.c addt.c.OLD || exit 1 ;\
		cat addt.c.OLD \
			| sed '/^#include/	s/"stdio.h"/<stdio.h>/' \
			| sed '/^#include/	s%SDL/%%' \
			> addt.c \
)


## ,-----
## |	Build
## +-----

${NTI_ADDTRACTION_BUILT}: ${NTI_ADDTRACTION_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ADDTRACTION_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ADDTRACTION_INSTALLED}: ${NTI_ADDTRACTION_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ADDTRACTION_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-addtraction
nti-addtraction: nti-SDL ${NTI_ADDTRACTION_INSTALLED}

ALL_NTI_TARGETS+= nti-addtraction

endif	# HAVE_ADDTRACTION_CONFIG
