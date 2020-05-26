# nterm v0.0.2			[ since v0.2, c.2017-10-25 ]
# last mod WmT, 2017-10-25	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_NTERM_CONFIG},y)
HAVE_NTERM_CONFIG:=y

DESCRLIST+= "'nti-nterm' -- nterm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${NTERM_VERSION},)
NTERM_VERSION=0.2
endif

NTERM_SRC=${SOURCES}/n/nanoterm-${NTERM_VERSION}.tar.bz2
URLS+= http://downloads.sourceforge.net/project/nterm/nanoterm/${NTERM_VERSION}/nanoterm-${NTERM_VERSION}.tar.bz2?use_mirror=ignum

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_NTERM_TEMP=nti-nterm-${NTERM_VERSION}
NTI_NTERM_EXTRACTED=${EXTTEMP}/${NTI_NTERM_TEMP}/INSTALL.nanonote
NTI_NTERM_CONFIGURED=${EXTTEMP}/${NTI_NTERM_TEMP}/config.log
NTI_NTERM_BUILT=${EXTTEMP}/${NTI_NTERM_TEMP}/src/nanoterm
NTI_NTERM_INSTALLED=${NTI_TC_ROOT}/usr/bin/nanoterm


# ,-----
# |	Extract
# +-----

${NTI_NTERM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/nanoterm-${NTERM_VERSION} ] || rm -rf ${EXTTEMP}/nanoterm-${NTERM_VERSION}
	bzcat ${NTERM_SRC} | tar xvf - -C ${EXTTEMP}
	#xzcat ${NTERM_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${NTERM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NTERM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NTERM_TEMP}
	mv ${EXTTEMP}/nanoterm-${NTERM_VERSION} ${EXTTEMP}/${NTI_NTERM_TEMP}



# ,-----
# |	Configure
# +-----

${NTI_NTERM_CONFIGURED}: ${NTI_NTERM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NTERM_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)



# ,-----
# |	Build
# +-----

${NTI_NTERM_BUILT}: ${NTI_NTERM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NTERM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_NTERM_INSTALLED}: ${NTI_NTERM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NTERM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-nterm
nti-nterm: \
	${NTI_NTERM_INSTALLED}

ALL_NTI_TARGETS+= nti-nterm

endif	# HAVE_NTERM_CONFIG
