# karmen v0.15			[ since v0.15, 2017-10-31 ]
# last mod WmT, 2017-10-31	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_KARMEN_CONFIG},y)
HAVE_KARMEN_CONFIG:=y

#DESCRLIST+= "'nti-karmen' -- karmen"

include ${CFG_ROOT}/ENV/buildtype.mak

# #include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
# include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${KARMEN_VERSION},)
KARMEN_VERSION=0.15
endif

KARMEN_SRC=${SOURCES}/k/karmen-${KARMEN_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/karmen/karmen-0.15.tar.gz

# #include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
# include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak

NTI_KARMEN_TEMP=nti-karmen-${KARMEN_VERSION}
NTI_KARMEN_EXTRACTED=${EXTTEMP}/${NTI_KARMEN_TEMP}/configure
NTI_KARMEN_CONFIGURED=${EXTTEMP}/${NTI_KARMEN_TEMP}/config.log
NTI_KARMEN_BUILT=${EXTTEMP}/${NTI_KARMEN_TEMP}/src/karmen
NTI_KARMEN_INSTALLED=${NTI_TC_ROOT}/usr/bin/karmen


# ,-----
# |	Extract
# +-----

${NTI_KARMEN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/karmen-${KARMEN_VERSION} ] || rm -rf ${EXTTEMP}/karmen-${KARMEN_VERSION}
	#bzcat ${KARMEN_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${KARMEN_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_KARMEN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_KARMEN_TEMP}
	mv ${EXTTEMP}/karmen-${KARMEN_VERSION} ${EXTTEMP}/${NTI_KARMEN_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_KARMEN_CONFIGURED}: ${NTI_KARMEN_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_KARMEN_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
 	)


# ,-----
# |	Build
# +-----

${NTI_KARMEN_BUILT}: ${NTI_KARMEN_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_KARMEN_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_KARMEN_INSTALLED}: ${NTI_KARMEN_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_KARMEN_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

# .PHONY: nti-karmen
# nti-karmen: \
# 	nti-pkg-config \
# 	nti-libXpm \
# 	${NTI_KARMEN_INSTALLED}

.PHONY: nti-karmen
nti-karmen: \
	${NTI_KARMEN_INSTALLED}

ALL_NTI_TARGETS+= nti-karmen


endif	# HAVE_KARMEN_CONFIG
