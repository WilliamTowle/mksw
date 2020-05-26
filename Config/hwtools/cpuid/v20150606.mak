# cpuid v20150505		[ since v20150505, c.2015-06-10 ]
# last mod WmT, 2015-06-10	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_CPUID_CONFIG},y)
HAVE_CPUID_CONFIG:=y

#DESCRLIST+= "'nti-cpuid' -- cpuid"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CPUID_VERSION},)
CPUID_VERSION=20150606
endif
CPUID_SRC=${SOURCES}/c/cpuid-20150606.src.tar.gz

URLS+= http://etallen.com/cpuid/cpuid-20150606.src.tar.gz

NTI_CPUID_TEMP=nti-cpuid-${CPUID_VERSION}

NTI_CPUID_EXTRACTED=${EXTTEMP}/${NTI_CPUID_TEMP}/LICENSE
NTI_CPUID_CONFIGURED=${EXTTEMP}/${NTI_CPUID_TEMP}/Makefile.OLD
NTI_CPUID_BUILT=${EXTTEMP}/${NTI_CPUID_TEMP}/cpuid
NTI_CPUID_INSTALLED=${NTI_TC_ROOT}/usr/bin/cpuid


## ,-----
## |	Extract
## +-----

${NTI_CPUID_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cpuid-${CPUID_VERSION} ] || rm -rf ${EXTTEMP}/cpuid-${CPUID_VERSION}
	zcat ${CPUID_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CPUID_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CPUID_TEMP}
	mv ${EXTTEMP}/cpuid-${CPUID_VERSION} ${EXTTEMP}/${NTI_CPUID_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CPUID_CONFIGURED}: ${NTI_CPUID_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CPUID_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC=gcc\n%' \
			| sed '/^BUILDROOT/	{ s/BUILDROOT/DESTDIR/ ; s%$$%\nPREFIX='${NTI_TC_ROOT}'/usr\n% }' \
			| sed '/^	/	s%$$(BUILDROOT)/usr%$$(DESTDIR)/$$(PREFIX)%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_CPUID_BUILT}: ${NTI_CPUID_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CPUID_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CPUID_INSTALLED}: ${NTI_CPUID_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CPUID_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-cpuid
nti-cpuid: ${NTI_CPUID_INSTALLED}

ALL_NTI_TARGETS+= nti-cpuid

endif	# HAVE_CPUID_CONFIG
