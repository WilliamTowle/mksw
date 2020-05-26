# windwm v0.15			[ since v0.15, 2017-10-31 ]
# last mod WmT, 2017-10-31	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_WINDWM_CONFIG},y)
HAVE_WINDWM_CONFIG:=y

#DESCRLIST+= "'nti-windwm' -- windwm"

include ${CFG_ROOT}/ENV/buildtype.mak

# #include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
# include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${WINDWM_VERSION},)
WINDWM_VERSION=1.5
endif

WINDWM_SRC=${SOURCES}/w/wind-${WINDWM_VERSION}.tar.gz
URLS+= https://downloads.sourceforge.net/project/windwm/wind-${WINDWM_VERSION}.tar.gz


# #include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
# include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak

NTI_WINDWM_TEMP=nti-windwm-${WINDWM_VERSION}
NTI_WINDWM_EXTRACTED=${EXTTEMP}/${NTI_WINDWM_TEMP}/configure
NTI_WINDWM_CONFIGURED=${EXTTEMP}/${NTI_WINDWM_TEMP}/config.log
NTI_WINDWM_BUILT=${EXTTEMP}/${NTI_WINDWM_TEMP}/wind
NTI_WINDWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/wind


# ,-----
# |	Extract
# +-----

${NTI_WINDWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/windwm-${WINDWM_VERSION} ] || rm -rf ${EXTTEMP}/windwm-${WINDWM_VERSION}
	[ ! -d ${EXTTEMP}/wind-${WINDWM_VERSION} ] || rm -rf ${EXTTEMP}/wind-${WINDWM_VERSION}
	#bzcat ${WINDWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${WINDWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WINDWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WINDWM_TEMP}
	#mv ${EXTTEMP}/windwm-${WINDWM_VERSION} ${EXTTEMP}/${NTI_WINDWM_TEMP}
	mv ${EXTTEMP}/wind-${WINDWM_VERSION} ${EXTTEMP}/${NTI_WINDWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_WINDWM_CONFIGURED}: ${NTI_WINDWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_WINDWM_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
 	)


# ,-----
# |	Build
# +-----

${NTI_WINDWM_BUILT}: ${NTI_WINDWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_WINDWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_WINDWM_INSTALLED}: ${NTI_WINDWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_WINDWM_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-windwm
nti-windwm: \
	${NTI_WINDWM_INSTALLED}

ALL_NTI_TARGETS+= nti-windwm


endif	# HAVE_WINDWM_CONFIG
