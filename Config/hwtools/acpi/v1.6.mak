# acpi v1.6			[ since v1.6, 2015-01-24 ]
# last mod WmT, 2015-01-24	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_ACPI_CONFIG},y)
HAVE_ACPI_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-acpi' -- acpi"

ifeq (${ACPI_VERSION},)
ACPI_VERSION=1.6
endif

ACPI_SRC=${SOURCES}/a/acpi_${ACPI_VERSION}.orig.tar.gz
URLS+= http://ftp.de.debian.org/debian/pool/main/a/acpi/acpi_1.6.orig.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.16.2.mak

NTI_ACPI_TEMP=nti-acpi-${ACPI_VERSION}

NTI_ACPI_EXTRACTED=${EXTTEMP}/${NTI_ACPI_TEMP}/configure
NTI_ACPI_CONFIGURED=${EXTTEMP}/${NTI_ACPI_TEMP}/config.log
NTI_ACPI_BUILT=${EXTTEMP}/${NTI_ACPI_TEMP}/acpi
NTI_ACPI_INSTALLED=${NTI_TC_ROOT}/usr/bin/acpi


## ,-----
## |	Extract
## +-----

${NTI_ACPI_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/acpi-${ACPI_VERSION} ] || rm -rf ${EXTTEMP}/acpi-${ACPI_VERSION}
	zcat ${ACPI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ACPI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ACPI_TEMP}
	mv ${EXTTEMP}/acpi-${ACPI_VERSION} ${EXTTEMP}/${NTI_ACPI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ACPI_CONFIGURED}: ${NTI_ACPI_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ACPI_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ACPI_BUILT}: ${NTI_ACPI_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ACPI_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ACPI_INSTALLED}: ${NTI_ACPI_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ACPI_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-acpi
nti-acpi: ${NTI_ACPI_INSTALLED}

ALL_NTI_TARGETS+= nti-acpi

endif	# HAVE_ACPI_CONFIG
