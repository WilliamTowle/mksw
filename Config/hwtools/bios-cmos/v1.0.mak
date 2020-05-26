# bios-cmos v1.0		[ since v1.0, c.2004-02-06 ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_BIOS_CMOS_CONFIG},y)
HAVE_BIOS_CMOS_CONFIG:=y

#DESCRLIST+= "'nti-bios-cmos' -- bios-cmos"
#DESCRLIST+= "'cti-bios-cmos' -- bios-cmos"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${BIOS_CMOS_VERSION},)
BIOS_CMOS_VERSION=1.0
endif

BIOS_CMOS_SRC=${SOURCES}/b/bios-cmos-${BIOS_CMOS_VERSION}.tar.gz
URLS+= http://www.ibiblio.org/pub/Linux/system/hardware/bios-cmos-1.0.tar.gz

NTI_BIOS_CMOS_TEMP=nti-bios-cmos-${BIOS_CMOS_VERSION}

NTI_BIOS_CMOS_EXTRACTED=${EXTTEMP}/${NTI_BIOS_CMOS_TEMP}/Makefile
NTI_BIOS_CMOS_CONFIGURED=${EXTTEMP}/${NTI_BIOS_CMOS_TEMP}/Makefile.OLD
NTI_BIOS_CMOS_BUILT=${EXTTEMP}/${NTI_BIOS_CMOS_TEMP}/bin/cmosdump
NTI_BIOS_CMOS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/cmosdump


## ,-----
## |	Extract
## +-----

${NTI_BIOS_CMOS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bios-cmos-${BIOS_CMOS_VERSION} ] || rm -rf ${EXTTEMP}/bios-cmos-${BIOS_CMOS_VERSION}
	zcat ${BIOS_CMOS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP}
	mv ${EXTTEMP}/bios-cmos-${BIOS_CMOS_VERSION} ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BIOS_CMOS_CONFIGURED}: ${NTI_BIOS_CMOS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^DESTDIR/	{ s/DESTDIR/PREFIX/ ; s%/usr.*%'${NTI_TC_ROOT}'/usr% }' \
			| sed '/^	/	s%(DESTDIR)%(PREFIX)/sbin%' \
			| sed '/^	/	s%/usr%$$(PREFIX)%' \
			> Makefile || exit 1 ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CC[ 	]/		{ s/?// ; s%g*cc%'${NTI_GCC}'% }' \
			| sed '/^CFLAGS[ 	]/	{ s/-m386/-march=i386/ ; s/-malign-functions=/-falign-functions=/ ; s/-malign-loops=/-falign-loops=/ ; s/-malign-jumps=/-falign-jumps=/ }' \
			> src/Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BIOS_CMOS_BUILT}: ${NTI_BIOS_CMOS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BIOS_CMOS_INSTALLED}: ${NTI_BIOS_CMOS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BIOS_CMOS_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/x11.pc ${NTI_BIOS_CMOS_INSTALLED} \
	)

.PHONY: nti-bios-cmos
nti-bios-cmos: ${NTI_BIOS_CMOS_INSTALLED}

ALL_NTI_TARGETS+= nti-bios-cmos

endif	# HAVE_BIOS_CMOS_CONFIG
