# pipepanic v0.1.3		[ EARLIEST v0.1.3, c.2017-03-20 ]
# last mod WmT, 2013-03-20	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_PIPEPANIC_CONFIG},y)
HAVE_PIPEPANIC_CONFIG:=y

DESCRLIST+= "'nti-pipepanic' -- pipepanic"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PIPEPANIC_VERSION},)
PIPEPANIC_VERSION=0.1.3
endif

PIPEPANIC_SRC=${SOURCES}/p/pipepanic-${PIPEPANIC_VERSION}-source.tar.gz
URLS+= http://www.users.waitrose.com/~thunor/pipepanic/dload/pipepanic-0.1.3-source.tar.gz


include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak


NTI_PIPEPANIC_TEMP=nti-pipepanic-${PIPEPANIC_VERSION}

NTI_PIPEPANIC_EXTRACTED=${EXTTEMP}/${NTI_PIPEPANIC_TEMP}/TODO
NTI_PIPEPANIC_CONFIGURED=${EXTTEMP}/${NTI_PIPEPANIC_TEMP}/main.h.OLD
NTI_PIPEPANIC_BUILT=${EXTTEMP}/${NTI_PIPEPANIC_TEMP}/pipepanic
NTI_PIPEPANIC_INSTALLED=${NTI_TC_ROOT}/usr/bin/pipepanic


## ,-----
## |	Extract
## +-----

${NTI_PIPEPANIC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/pipepanic-${PIPEPANIC_VERSION} ] || rm -rf ${EXTTEMP}/pipepanic-${PIPEPANIC_VERSION}
	[ ! -d ${EXTTEMP}/pipepanic-${PIPEPANIC_VERSION}-source ] || rm -rf ${EXTTEMP}/pipepanic-${PIPEPANIC_VERSION}-source
	zcat ${PIPEPANIC_SRC} | tar xvf - -C ${EXTTEMP}
	#[ ! -d ${EXTTEMP}/${NTI_PIPEPANIC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PIPEPANIC_TEMP}
	[ ! -d ${EXTTEMP}/${NTI_PIPEPANIC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PIPEPANIC_TEMP}
	mv ${EXTTEMP}/pipepanic-${PIPEPANIC_VERSION}-source ${EXTTEMP}/${NTI_PIPEPANIC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PIPEPANIC_CONFIGURED}: ${NTI_PIPEPANIC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PIPEPANIC_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	{ s%sdl-config%'${SDL_CONFIG_TOOL}'% ; s%--cflags%--cflags | sed s,include/SDL,include,% } ' \
			| sed '/^LIBS/		s%sdl-config%'${SDL_CONFIG_TOOL}'%' \
			> Makefile || exit 1 ;\
		[ -r main.h.OLD ] || mv main.h main.h.OLD || exit 1 ;\
		cat main.h.OLD \
			| sed '/define DATADIR/	s%".*"%"'${NTI_TC_ROOT}'/usr/share/pipepanic/"%' \
			> main.h \
	)


## ,-----
## |	Build
## +-----

${NTI_PIPEPANIC_BUILT}: ${NTI_PIPEPANIC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PIPEPANIC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PIPEPANIC_INSTALLED}: ${NTI_PIPEPANIC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PIPEPANIC_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin/ || exit 1 ;\
		cp pipepanic ${NTI_PIPEPANIC_INSTALLED} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/share/pipepanic ;\
		cp ascii*bmp digits*bmp tiles*bmp ${NTI_TC_ROOT}/usr/share/pipepanic \
	)
#		make install

##

.PHONY: nti-pipepanic
nti-pipepanic: nti-SDL ${NTI_PIPEPANIC_INSTALLED}

ALL_NTI_TARGETS+= nti-pipepanic

endif	# HAVE_PIPEPANIC_CONFIG
