# screen v4.0.3			[ since v4.0.2, c. 2010-12-22 ]
# last mod WmT, 2015-01-23	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_SCREEN_CONFIG},y)
HAVE_SCREEN_CONFIG:=y

#DESCRLIST+= "'nti-screen' -- screen"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SCREEN_VERSION},)
#SCREEN_VERSION=4.0.2
SCREEN_VERSION=4.0.3
endif

SCREEN_SRC=${SOURCES}/s/screen-${SCREEN_VERSION}.tar.gz
URLS+= http://ftp.gnu.org/gnu/screen/screen-4.0.3.tar.gz
SCREEN_PATCHES=

SCREEN_PATCHES+= ${CFG_ROOT}/tui/screen/sched.patch
URLS+= https://raw.githubusercontent.com/SIFTeam/openembedded/master/recipes/screen/screen-4.0.3/sched.patch
SCREEN_PATCHES+= ${CFG_ROOT}/tui/screen/no-stropts.patch
URLS+= https://raw.githubusercontent.com/SIFTeam/openembedded/master/recipes/screen/screen-4.0.3/no-stropts.patch

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_SCREEN_TEMP=nti-screen-${SCREEN_VERSION}

NTI_SCREEN_EXTRACTED=${EXTTEMP}/${NTI_SCREEN_TEMP}/configure
NTI_SCREEN_CONFIGURED=${EXTTEMP}/${NTI_SCREEN_TEMP}/config.h.OLD
NTI_SCREEN_BUILT=${EXTTEMP}/${NTI_SCREEN_TEMP}/screen
NTI_SCREEN_INSTALLED=${NTI_TC_ROOT}/usr/bin/screen


## ,-----
## |	Extract
## +-----

${NTI_SCREEN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/screen-${SCREEN_VERSION} ] || rm -rf ${EXTTEMP}/screen-${SCREEN_VERSION}
	zcat ${SCREEN_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${SCREEN_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${SCREEN_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			patch --batch -d screen-${SCREEN_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_SCREEN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SCREEN_TEMP}
	mv ${EXTTEMP}/screen-${SCREEN_VERSION} ${EXTTEMP}/${NTI_SCREEN_TEMP}


## ,-----
## |	Configure
## +-----

# [v4.0.3] sys/stropts.h needed by SVR4 and HAVE_SVR4_PTYS

${NTI_SCREEN_CONFIGURED}: ${NTI_SCREEN_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SCREEN_TEMP} || exit 1 ;\
		CFLAGS='-I'` ${NCURSES_CONFIG_TOOL} --cflags ` \
		LDFLAGS='-L'` ${NCURSES_CONFIG_TOOL} --libdir ` \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 ;\
		case ${SCREEN_VERSION} in \
		NOSVR-FOR-4.0.3) \
		[ -r config.h.OLD ] || mv config.h config.h.OLD ;\
		cat config.h.OLD \
			| sed '/define SVR4 1/ { s%^%/* % ; s%$$% */% }' \
			| sed '/define HAVE_SVR4_PTYS 1/ { s%^%/* % ; s%$$% */% }' \
			> config.h \
		;;	\
		*)	touch config.h.OLD ;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_SCREEN_BUILT}: ${NTI_SCREEN_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SCREEN_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SCREEN_INSTALLED}: ${NTI_SCREEN_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SCREEN_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-screen
nti-screen: nti-ncurses ${NTI_SCREEN_INSTALLED}

ALL_NTI_TARGETS+= nti-screen

endif	# HAVE_SCREEN_CONFIG
