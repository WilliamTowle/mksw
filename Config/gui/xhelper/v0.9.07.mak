# xhelper v0.9.07		[ since v0.9.07, c.2017-04-21 ]
# last mod WmT, 2017-04-21	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XHELPER_CONFIG},y)
HAVE_XHELPER_CONFIG:=y

#DESCRLIST+= "'cui-xhelper' -- xhelper"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.12.mak
include ${CFG_ROOT}/buildtools/nasm/v2.13rc21.mak

ifeq (${XHELPER_VERSION},)
XHELPER_VERSION=0.9.07
endif

XHELPER_SRC=${SOURCES}/x/xhelper-${XHELPER_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/xhelper/xhelper/xhelper-0.9.07.tar.gz/xhelper-0.9.07.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fxhelper%2Ffiles%2Fxhelper%2Fxhelper-0.9.07.tar.gz%2F&ts=1492780876&use_mirror=ayera"


#include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak
#include ${CFG_ROOT}/x11-r7.5/libXxf86vm/v1.1.0.mak

NTI_XHELPER_TEMP=nti-xhelper-${XHELPER_VERSION}
NTI_XHELPER_EXTRACTED=${EXTTEMP}/${NTI_XHELPER_TEMP}/COPYING
NTI_XHELPER_CONFIGURED=${EXTTEMP}/${NTI_XHELPER_TEMP}/Makefile.OLD
NTI_XHELPER_BUILT=${EXTTEMP}/${NTI_XHELPER_TEMP}/xhelper
NTI_XHELPER_INSTALLED=${NTI_TC_ROOT}/usr/bin/xhelper


# ,-----
# |	Extract
# +-----

${NTI_XHELPER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/xhelper-${XHELPER_VERSION} ] || rm -rf ${EXTTEMP}/xhelper-${XHELPER_VERSION}
	[ ! -d ${EXTTEMP}/Xhelper ] || rm -rf ${EXTTEMP}/Xhelper
	#bzcat ${XHELPER_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${XHELPER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XHELPER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XHELPER_TEMP}
	#mv ${EXTTEMP}/xhelper-${XHELPER_VERSION} ${EXTTEMP}/${NTI_XHELPER_TEMP}
	mv ${EXTTEMP}/Xhelper ${EXTTEMP}/${NTI_XHELPER_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_XHELPER_CONFIGURED}: ${NTI_XHELPER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XHELPER_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^X11/		s%-I/usr/X11R6%/usr/%' \
			> Makefile \
	)
#/include%'"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags x11 `"'%' \



# ,-----
# |	Build
# +-----

${NTI_XHELPER_BUILT}: ${NTI_XHELPER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XHELPER_TEMP} || exit 1 ;\
		echo '`make`: with OP=LIB...' ;\
		make OP=LIB || exit 1 ;\
		echo '`make`: standard first target...' ;\
		make || exit 1 \
	)


# ,-----
# |	Install
# +-----

${NTI_XHELPER_INSTALLED}: ${NTI_XHELPER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XHELPER_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-xhelper
#nti-xhelper: nti-pkg-config \
#	nti-libXpm \
#	nti-libXxf86vm \
#	${NTI_XHELPER_INSTALLED}
nti-xhelper: nti-nasm \
	${NTI_XHELPER_INSTALLED}

ALL_NTI_TARGETS+= nti-xhelper

endif	# HAVE_XHELPER_CONFIG
