#!/usr/bin/make
# tftpdev (c) and GPLv2 Wm. Towle 1999-2010
# last mod WmT, 2011-01-04

#************************************************************
#*
#*  Open Source software - copyright and GPLv2 apply. Briefly:
#*   - No warranty/guarantee of fitness, use is at own risk
#*   - No restrictions on strictly-private use/copying/modification
#*   - No re-licensing this work under more restrictive terms
#*   - Redistributing? Include source or ensure supply chain exists
#*  Philosophy/full details at http://www.gnu.org/copyleft/gpl.html
#*
#************************************************************

## ,-----
## |	Initialisation
## +-----

.PHONY: default
default: help

## directories

TOPLEV:=$(shell pwd)
EXTTEMP=${TOPLEV}/exttemp
TC_ROOT=${TOPLEV}/toolchain
CFG_ROOT=${TOPLEV}/Config
#SRCDIR:=$(shell cd ../ && pwd)/source

##

DESCRLIST:=
TARGETS:=
USAGE_RULES:=
URLS:=
CLEAN_TARGETS:= ${EXTTEMP}
REALCLEAN_TARGETS:= ${HTC_ROOT}

#PATH:=${TC_ROOT}/bin:${TC_ROOT}/usr/bin:${PATH}

##

ifneq (${MAKELEVEL},0)

## Recursing -> Pull in platform spec and relevant include files

#include platform.mak

ifneq (${PKGDESC},)
HAVE_PKGDESC:=$(shell if [ -r ${PKGDESC} ] ; then echo y ; else echo n ; fi)
ifeq (${HAVE_PKGDESC},y)
include ${PKGDESC}
endif
endif

## Recursing -> Provide additional relevant targets

${EXTTEMP}:
	mkdir -p ${EXTTEMP}

${HTC_ROOT}:
	mkdir -p ${HTC_ROOT}


.PHONY: extract
extract: ${EXTTEMP}
	for ARCHIVE in ${ARCHIVES} ; do \
		[ -r $${ARCHIVE} ] || { echo "ARCHIVE $${ARCHIVE}: Not found" 1>&2 ; exit 1 ; } ;\
		case $${ARCHIVE} in \
		*.bz2) \
			echo "[bzunip method]" ;\
			bzip2 -dc $${ARCHIVE} | ( cd ${EXTTEMP} && tar xvf - ) \
		;; \
		*.gz|*.tgz) \
			echo "[gunzip method]" ;\
			gzip -dc $${ARCHIVE} | ( cd ${EXTTEMP} && tar xvf - ) \
		;; \
		*.zip) \
			echo "[pkunzip method]" ;\
			unzip $${ARCHIVE} -d ${EXTTEMP} \
		;; \
		*) \
			echo "'extract': Unrecognised ARCHIVE format" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
	done

##

endif

## ,-----
## |	Top level - supply build-instruction file
## +-----

USAGE_RULES+= "Usage: make <Makefile[s]> ACTION=[build|list|show-urls-c|show-urls-n]"


ifeq (${MAKELEVEL},0)
.PHONY: always
%.mak:: always
ifeq (${ACTION},)
	@echo "ERROR: $@: Need an ACTION=" 1>&2
	@${MAKE} --no-print-directory help
	exit 1
else
	@if [ "${ACTION}" = 'show-urls-n' ] ; then \
		${MAKE} --no-print-directory ${ACTION} ACTION=buildn PKGDESC=$@ ;\
	elif [ "${ACTION}" = 'show-urls-c' ] ; then \
		${MAKE} --no-print-directory ${ACTION} ACTION=buildc PKGDESC=$@ ;\
	else \
		${MAKE} ${ACTION} PKGDESC=$@ ;\
	fi
endif
endif

## ,-----
## |	Second level - execute ACTION for supplied file
## +-----


USAGE_RULES+= "'ACTION=buildn': build native targets in specified Makefile[s]"

.PHONY: buildn
buildn:
ifeq (${NTARGETS},)
	@echo "ERROR: $@: Nothing to build" 1>&2
	@${MAKE} --no-print-directory help
	exit 1
else
	@echo
	@echo '*** Building' ${NTARGETS}'... ***'
	@echo
	${MAKE} ${NTARGETS}
endif


USAGE_RULES+= "'ACTION=buildc': build cross targets in specified Makefile[s]"

.PHONY: buildc
buildc:
ifeq (${CTARGETS},)
	@echo "ERROR: $@: Nothing to build" 1>&2
	@${MAKE} --no-print-directory help
	exit 1
else
	@echo
	@echo '*** Building' ${CTARGETS}'... ***'
	@echo
	${MAKE} ${CTARGETS}
endif



USAGE_RULES+= "'ACTION=describe': list target/subtargets of specified Makefile[s]"

.PHONY: list
list:
ifeq (${DESCRLIST},)
	@echo "ERROR: $@: No DESCRIPTIONs" 1>&2
	@${MAKE} --no-print-directory help
	exit 1
else
	@echo
	@for DESC in ${DESCRLIST} ; do echo -e "\t$${DESC}" ; done
	@echo
endif


USAGE_RULES+= "'ACTION=show-urls-[n|c]': show source URLs for specified Makefile[s]"

.PHONY: show-urls-c show-urls-n
show-urls-c show-urls-n:
ifeq (${URLS},)
	@echo "ERROR: $@: No URLs" 1>&2
	exit 1
else
	@for URL in ${URLS} ; do echo -e "$${URL}" ; done | sort -u
endif


## ,-----
## |	Clean
## +-----

USAGE_RULES+= "'clean' -- removal of intermediate build files"
USAGE_RULES+= "'realclean' -- removal of all generated files"

.PHONY: clean realclean
clean:
	-rm -rf ${CLEAN_TARGETS}

realclean: clean
	-rm -rf ${REALCLEAN_TARGETS}


## ,-----
## |	Assistance
## +-----

.PHONY: help

help:
ifeq (${USAGE_RULES},)
	@echo "No USAGE_RULES. This 'Makefile' has rules for:"
	@grep '^[a-z][a-zA-Z0-9-]*:' Makefile | sed 's%^%	%'
else
	@for MSG in ${USAGE_RULES} ; do echo -e "\t$$MSG" ; done
endif
