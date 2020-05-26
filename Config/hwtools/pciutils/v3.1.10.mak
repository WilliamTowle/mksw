#	# pciutils v3.1.7		[ since v2.1.11, c.2003-07-03 ]
#	# last mod WmT, 2010-07-19	[ (c) and GPLv2 1999-2010 ]
#	
#	ifneq (${HAVE_PCIUTILS_CONFIG},y)
#	HAVE_PCIUTILS_CONFIG:=y
#	
#	DESCRLIST+= "'cui-pciutils' -- pciutils"
#	
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	include ${CFG_ROOT}/ENV/native.mak
#	include ${CFG_ROOT}/ENV/target.mak
#	
#	PCIUTILS_VER:=3.1.7
#	PCIUTILS_SRC=${SRCDIR}/p/pciutils-3.1.7.tar.gz
#	PCIUTILS_PATCHES=
#	
#	
#	#PCIUTILS_PATCHES+=
#	#URLS+=
#	
#	
#	# ,-----
#	# |	Extract
#	# +-----
#	
#	CUI_PCIUTILS_TEMP=cui-pciutils-${PCIUTILS_VER}
#	CUI_PCIUTILS_INSTTEMP=${EXTTEMP}/insttemp
#	
#	CUI_PCIUTILS_EXTRACTED=${EXTTEMP}/${CUI_PCIUTILS_TEMP}/Makefile
#	
#	.PHONY: cui-pciutils-extracted
#	
#	cui-pciutils-extracted: ${CUI_PCIUTILS_EXTRACTED}
#	
#	${CUI_PCIUTILS_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${CUI_PCIUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_PCIUTILS_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${PCIUTILS_SRC}
#	ifneq (${PCIUTILS_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PATCHSRC in ${PCIUTILS_PATCHES} ; do \
#				make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
#			done ;\
#			for PF in patch/*patch ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d gcc-${PCIUTILS_VER} -Np1 < $${PF} ;\
#				rm -f $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/pciutils-${PCIUTILS_VER} ${EXTTEMP}/${CUI_PCIUTILS_TEMP}
#	
#	
#	# ,-----
#	# |	Configure
#	# +-----
#	
#	CUI_PCIUTILS_CONFIGURED=${EXTTEMP}/${CUI_PCIUTILS_TEMP}/Makefile.OLD
#	
#	.PHONY: cui-pciutils-configured
#	
#	cui-pciutils-configured: cui-pciutils-extracted ${CUI_PCIUTILS_CONFIGURED}
#	
#	${CUI_PCIUTILS_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CUI_PCIUTILS_TEMP} || exit 1 ;\
#		)
#	
#	
#	# ,-----
#	# |	Build
#	# +-----
#	
#	CUI_PCIUTILS_BUILT=${EXTTEMP}/${CUI_PCIUTILS_TEMP}/lspci.8
#	
#	.PHONY: cui-pciutils-built
#	cui-pciutils-built: cui-pciutils-configured ${CUI_PCIUTILS_BUILT}
#	
#	${CUI_PCIUTILS_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CUI_PCIUTILS_TEMP} || exit 1 ;\
#			make || exit 1 \
#		) || exit 1 
#	
#	
#	# ,-----
#	# |	Install
#	# +-----
#	
#	CUI_PCIUTILS_INSTALLED=${CUI_PCIUTILS_INSTTEMP}/usr/sbin/lspci
#	
#	.PHONY: cui-pciutils-installed
#	
#	cui-pciutils-installed: cui-pciutils-built ${CUI_PCIUTILS_INSTALLED}
#	
#	${CUI_PCIUTILS_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		( cd ${EXTTEMP}/${CUI_PCIUTILS_TEMP} || exit 1 ;\
#			make DESTDIR=${CUI_PCIUTILS_INSTTEMP} install \
#		) || exit 1
#	
#	
#	.PHONY: cui-pciutils
#	cui-pciutils: cti-cross-gcc cui-uClibc-rt cui-pciutils-installed
#	
#	TARGETS+= cui-pciutils
#	
#	endif	# HAVE_PCIUTILS_CONFIG


# pciutils v3.1.10		[ EARLIEST v?.?? ]
# last mod WmT, 2012-09-11	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_PCIUTILS_CONFIG},y)
HAVE_PCIUTILS_CONFIG:=y

#DESCRLIST+= "'nti-pciutils' -- pciutils"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${PCIUTILS_VERSION},)
PCIUTILS_VERSION=3.1.10
endif
PCIUTILS_SRC=${SOURCES}/p/pciutils-${PCIUTILS_VERSION}.tar.bz2

#URLS+= ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-3.1.7.tar.gz
URLS+= http://www.kernel.org/pub/software/utils/pciutils/pciutils-3.1.10.tar.bz2

NTI_PCIUTILS_TEMP=nti-pciutils-${PCIUTILS_VERSION}

NTI_PCIUTILS_EXTRACTED=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/COPYING
NTI_PCIUTILS_CONFIGURED=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/Makefile.OLD
NTI_PCIUTILS_BUILT=${EXTTEMP}/${NTI_PCIUTILS_TEMP}/lspci
NTI_PCIUTILS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/lspci


## ,-----
## |	Extract
## +-----

${NTI_PCIUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pciutils-${PCIUTILS_VERSION} ] || rm -rf ${EXTTEMP}/pciutils-${PCIUTILS_VERSION}
	bzcat ${PCIUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PCIUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PCIUTILS_TEMP}
	mv ${EXTTEMP}/pciutils-${PCIUTILS_VERSION} ${EXTTEMP}/${NTI_PCIUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PCIUTILS_CONFIGURED}: ${NTI_PCIUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^PREFIX=/		s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^ZLIB=/			s/=.*/=no/' \
			> Makefile \
	)
#			| sed '/^CROSS_COMPILE=/	s%=.*%='${CTI_SPEC}'-%'


## ,-----
## |	Build
## +-----

# [2012-11-12] DNS=[yes|no]: requires -lresolv

${NTI_PCIUTILS_BUILT}: ${NTI_PCIUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		make DNS=no \
	)


## ,-----
## |	Install
## +-----

${NTI_PCIUTILS_INSTALLED}: ${NTI_PCIUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PCIUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-pciutils
nti-pciutils: ${NTI_PCIUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-pciutils

endif	# HAVE_PCIUTILS_CONFIG
