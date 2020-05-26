# piewm v1.04			[ since v1.04, 2017-10-30 ]
# last mod WmT, 2017-10-30	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_PIEWM_CONFIG},y)
HAVE_PIEWM_CONFIG:=y

#DESCRLIST+= "'nti-piewm' -- piewm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${PIEWM_VERSION},)
PIEWM_VERSION=1.03
#PIEWM_VERSION=1.04
endif

PIEWM_SRC=${SOURCES}/p/piewm-${PIEWM_VERSION}.tar.gz
URLS+= http://www.crynwr.com/piewm/piewm-${PIEWM_VERSION}.tar.gz

#include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak

NTI_PIEWM_TEMP=nti-piewm-${PIEWM_VERSION}
NTI_PIEWM_EXTRACTED=${EXTTEMP}/${NTI_PIEWM_TEMP}/Makefile
NTI_PIEWM_CONFIGURED=${EXTTEMP}/${NTI_PIEWM_TEMP}/Makefile.OLD
NTI_PIEWM_BUILT=${EXTTEMP}/${NTI_PIEWM_TEMP}/piewm
NTI_PIEWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/piewm


# ,-----
# |	Extract
# +-----

${NTI_PIEWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/piewm-${PIEWM_VERSION} ] || rm -rf ${EXTTEMP}/piewm-${PIEWM_VERSION}
	#bzcat ${PIEWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${PIEWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PIEWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PIEWM_TEMP}
	mv ${EXTTEMP}/piewm-${PIEWM_VERSION} ${EXTTEMP}/${NTI_PIEWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_PIEWM_CONFIGURED}: ${NTI_PIEWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PIEWM_TEMP} || exit 1 ;\
		case ${PIEWM_VERSION} in \
		1.03|1.04) \
			[ -r iconmgr.c.OLD ] || mv iconmgr.c iconmgr.c.OLD ;\
	 		cat iconmgr.c.OLD \
				| sed '/int strcmp/	s/^/\/\//' \
				> iconmgr.c ;\
			[ -r icons.c.OLD ] || mv icons.c icons.c.OLD ;\
	 		cat icons.c.OLD \
				| sed '/static void/ s%static%/* static */%' \
				> icons.c ;\
		;; \
		*) \
			echo "Unexpected PIEWM_VERSION ${PIEWM_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/CDEBUGFLAGS =/		s/-m486//' \
			| sed '/CXXDEBUGFLAGS =/	s/-m486//' \
			| sed '/CFLAGS =/		s%$$%'"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags x11`"'%' \
			| sed '/EXTRA_LOAD_FLAGS =/	s%=.*%= '"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs x11`"'%' \
			| sed '/BINDIR =/		s%=.*%= '${NTI_TC_ROOT}'/usr/bin%' \
			| sed '/USRLIBDIR =/		s%=.*%= '${NTI_TC_ROOT}'/usr/lib%' \
			> Makefile ;\
		touch ${NTI_PIEWM_CONFIGURED} \
	)


# ,-----
# |	Build
# +-----

${NTI_PIEWM_BUILT}: ${NTI_PIEWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PIEWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_PIEWM_INSTALLED}: ${NTI_PIEWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PIEWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

# .PHONY: nti-piewm
# nti-piewm: nti-SDL nti-SDL_image nti-SDL_mixer \
# 	nti-libgl-mesa \
# 	nti-libXfixes nti-libXxf86vm \
# 	nti-smpeg \
# 	${NTI_PIEWM_INSTALLED}

.PHONY: nti-piewm
nti-piewm: \
	nti-pkg-config \
	nti-libXpm \
	${NTI_PIEWM_INSTALLED}

ALL_NTI_TARGETS+= nti-piewm


endif	# HAVE_PIEWM_CONFIG
