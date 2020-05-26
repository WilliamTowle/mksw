# tcc v0.9.26			[ since v0.9.19, c.2003-06-05 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

#ifneq (${HAVE_TCC_CONFIG},y)
#HAVE_TCC_CONFIG:=y
#
#DESCRLIST+= "'cui-tcc' -- tcc (Tiny C Compiler)"
#
### TODO: needs headers, libraries at runtime
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak
#

##CUI_TCC_PATCHES+=
##URLS+=
#
#
## ,-----
## |	Extract
## +-----
#
#CUI_TCC_TEMP=cui-tcc-${CUI_TCC_VER}
#CUI_TCC_INSTTEMP=${EXTTEMP}/insttemp
#
#CUI_TCC_EXTRACTED=${EXTTEMP}/${CUI_TCC_TEMP}/Makefile
#
#.PHONY: cui-tcc-extracted
#
#cui-tcc-extracted: ${CUI_TCC_EXTRACTED}
#
#${CUI_TCC_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${CUI_TCC_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_TCC_TEMP}
#	make -C ${TOPLEV} extract ARCHIVE=${CUI_TCC_SRC}
#ifneq (${CUI_TCC_PATCHES},)
#	( cd ${EXTTEMP} || exit 1 ;\
#		for PATCHSRC in ${CUI_TCC_PATCHES} ; do \
#			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
#		done ;\
#		for PF in patch/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			patch --batch -d gcc-${CUI_TCC_VER} -Np1 < $${PF} ;\
#			rm -f $${PF} ;\
#		done \
#	)
#endif
#	mv ${EXTTEMP}/tcc-${CUI_TCC_VER} ${EXTTEMP}/${CUI_TCC_TEMP}
#
#
## ,-----
## |	Configure
## +-----
#
#.PHONY: cui-tcc-configured
#
#cui-tcc-configured: cui-tcc-extracted ${CUI_TCC_CONFIGURED}
#
#${CUI_TCC_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
#		bigendian=no \
#			./configure --prefix=/usr --cc=${CTI_GCC} || exit 1 ;\
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			| sed 's/LIBS=.*/LIBS=-ldl -lm/' \
#			| sed 's/ -ldl/ $$(LIBS)/' \
#			> Makefile || exit 1 ;\
#		[ -r config.mak.OLD ] || mv config.mak config.mak.OLD || exit 1 ;\
#		cat config.mak.OLD \
#			| sed '/^[a-z]*=/ s%/usr%$${DESTDIR}/usr%' \
#			> config.mak || exit 1 \
#	)
#
#
## ,-----
## |	Build
## +-----
#
#.PHONY: cui-tcc-built
#cui-tcc-built: cui-tcc-configured ${CUI_TCC_BUILT}
#
#${CUI_TCC_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
#		make || exit 1 \
#	) || exit 1
#
#
#
## ,-----
## |	Install
## +-----
#
#.PHONY: cui-tcc-installed
#
#cui-tcc-installed: cui-tcc-built ${CUI_TCC_INSTALLED}
#
#${CUI_TCC_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	for DIR in /usr/bin /usr/include /usr/man/man1 /usr/man/man8 ; do \
#		mkdir -p ${CUI_TCC_INSTTEMP}/$${DIR} || exit 1 ;\
#	done
#	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
#		make DESTDIR=${CUI_TCC_INSTTEMP} install || exit 1 \
#	) || exit 1
#
#
#.PHONY: cui-tcc
#cui-tcc: cti-cross-gcc cui-uClibc-rt cui-tcc-installed
#
#TARGETS+= cui-tcc
#
#endif	# HAVE_TCC_CONFIG


# tcc v2.12		[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_TCC_CONFIG},y)
HAVE_TCC_CONFIG:=y

#DESCRLIST+= "'nti-tcc' -- tcc"
#DESCRLIST+= "'cti-tcc' -- tcc"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#
#include ${CFG_ROOT}/gui/libXdmcp/v1.0.3.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.5.mak
##include ${CFG_ROOT}/gui/libXau/v1.0.6.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
##include ${CFG_ROOT}/gui/libXt/v1.0.9.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
##include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.0.mak
##include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.1.mak
#include ${CFG_ROOT}/gui/x11proto-input/v2.0.mak
##include ${CFG_ROOT}/gui/x11proto-input/v2.0.1.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.4.mak
##include ${CFG_ROOT}/gui/x11proto-kb/v1.0.5.mak
#include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.0.mak
##include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.1.mak

ifeq (${TCC_VERSION},)
#TCC_VERSION:=0.9.25
TCC_VERSION:=0.9.26
endif

TCC_SRC=${SOURCES}/t/tcc-${TCC_VERSION}.tar.bz2
URLS+= http://download.savannah.gnu.org/releases/tinycc/tcc-${TCC_VERSION}.tar.bz2
#
NTI_TCC_TEMP=nti-tcc-${TCC_VERSION}

NTI_TCC_EXTRACTED=${EXTTEMP}/${NTI_TCC_TEMP}/README
NTI_TCC_CONFIGURED=${EXTTEMP}/${NTI_TCC_TEMP}/Makefile.OLD
NTI_TCC_BUILT=${EXTTEMP}/${NTI_TCC_TEMP}/libtcc.a
NTI_TCC_INSTALLED=${NTI_TC_ROOT}/usr/bin/tcc


## ,-----
## |	Extract
## +-----

${NTI_TCC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/tcc-${TCC_VERSION} ] || rm -rf ${EXTTEMP}/tcc-${TCC_VERSION}
	bzcat ${TCC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TCC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TCC_TEMP}
	mv ${EXTTEMP}/tcc-${TCC_VERSION} ${EXTTEMP}/${NTI_TCC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TCC_CONFIGURED}: ${NTI_TCC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TCC_TEMP} || exit 1 ;\
		bigendian=no \
			./configure --prefix=${NTI_TC_ROOT}/usr --cc=${NTI_GCC} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed 's/LIBS=.*/LIBS=-ldl -lm/' \
			| sed 's/ -ldl/ $$(LIBS)/' \
			> Makefile || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_TCC_BUILT}: ${NTI_TCC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TCC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TCC_INSTALLED}: ${NTI_TCC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TCC_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-tcc
nti-tcc: ${NTI_TCC_INSTALLED}

ALL_NTI_TARGETS+= nti-tcc

endif	# HAVE_TCC_CONFIG
