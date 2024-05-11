# skatoswm v0.21pl2		[ since v0.21pl2, 2017-04-19 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SKATOSWM_CONFIG},y)
HAVE_SKATOSWM_CONFIG:=y

DESCRLIST+= "'nti-skatoswm' -- skatoswm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${SKATOSWM_VERSION},)
SKATOSWM_VERSION=1.0
endif

SKATOSWM_SRC=${SOURCES}/s/skatoswm-${SKATOSWM_VERSION}.tgz
URLS+= http://www.giannone.ch/skatoswm/skatoswm-1.0.tgz

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak


NTI_SKATOSWM_TEMP=nti-skatoswm-${SKATOSWM_VERSION}
NTI_SKATOSWM_EXTRACTED=${EXTTEMP}/${NTI_SKATOSWM_TEMP}/COPYING
NTI_SKATOSWM_CONFIGURED=${EXTTEMP}/${NTI_SKATOSWM_TEMP}/Makefile.OLD
NTI_SKATOSWM_BUILT=${EXTTEMP}/${NTI_SKATOSWM_TEMP}/skatoswm
NTI_SKATOSWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/skatoswm


# ,-----
# |	Extract
# +-----

${NTI_SKATOSWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/skatoswm-${SKATOSWM_VERSION} ] || rm -rf ${EXTTEMP}/skatoswm-${SKATOSWM_VERSION}
	[ ! -d ${EXTTEMP}/SkatOSWM-${SKATOSWM_VERSION} ] || rm -rf ${EXTTEMP}/SkatOSWM-${SKATOSWM_VERSION}
	#bzcat ${SKATOSWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${SKATOSWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SKATOSWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SKATOSWM_TEMP}
	#mv ${EXTTEMP}/SkatOSWM-${SKATOSWM_VERSION} ${EXTTEMP}/${NTI_SKATOSWM_TEMP}
	mv ${EXTTEMP}/SkatOSWM-${SKATOSWM_VERSION} ${EXTTEMP}/${NTI_SKATOSWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_SKATOSWM_CONFIGURED}: ${NTI_SKATOSWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SKATOSWM_TEMP} || exit 1 ;\
		${PKG_CONFIG_CONFIG_HOST_TOOL} --exists x11 || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^X11/		s%-I/usr/X11R6%'"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --variable=prefix x11 `"'%' \
			> Makefile \
	)


# ,-----
# |	Build
# +-----

${NTI_SKATOSWM_BUILT}: ${NTI_SKATOSWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SKATOSWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_SKATOSWM_INSTALLED}: ${NTI_SKATOSWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SKATOSWM_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-skatoswm
nti-skatoswm: \
	nti-pkg-config \
	nti-libX11 \
	${NTI_SKATOSWM_INSTALLED}

ALL_NTI_TARGETS+= nti-skatoswm

endif	# HAVE_SKATOSWM_CONFIG
