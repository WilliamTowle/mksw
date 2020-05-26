#!/usr/bin/make
# last mod WmT, 2017-02-03	[ (c) and GPLv2 1999-2017 ]


# initialisation; append to these elsewhere
USAGE_RULES:=
ALL_TARGETS:=
CLEAN_TARGETS:=
REALCLEAN_TARGETS:=

.PHONY: default help
default: help


# ,-----
# |	Configuration
# +-----

# Specify the main set of rules
# NB. tcdev.mak makes further includes for customisation
#CONFIG:= tcdev.mak
CONFIG:= mksw.mak

MF_HAVE_CONFIG:=$(shell if [ -r ${CONFIG} ] ; then echo y ; else echo n ; fi)


TOPLEV:=$(shell pwd)
ifeq (${MF_HAVE_CONFIG},y)
include ${CONFIG}
endif

help:
ifneq (${MF_HAVE_CONFIG},y)
	@echo "WARNING - Configuration file CONFIG='${CONFIG}' is missing" 1>&2
endif
	@echo "Configuration in ${CONFIG} provides rules for:"
	@for R in ${USAGE_RULES} ; do /bin/echo -e "\t$$R" ; done


USAGE_RULES+= "all (build everything)"
all: $(ALL_TARGETS)
ifneq (${MF_HAVE_CONFIG},y)
	@echo "WARNING - Configuration file CONFIG='${CONFIG}' is missing" 1>&2
endif
ifeq ($(strip ${ALL_TARGETS}),)
	@echo "INFO: $@: No targets in ALL_TARGETS list" 1>&2
else
	@echo "INFO: $@: ALL_TARGETS list processed" 1>&2
endif


# ,-----
# |	Clean
# +-----

USAGE_RULES+= "'clean', 'realclean' - remove temporary files"

.PHONY: clean
clean:
ifneq (${MF_HAVE_CONFIG},y)
	@echo "WARNING: $@: Configuration file CONFIG='${CONFIG}' is missing" 1>&2
endif
	[ -z "${CLEAN_TARGETS}" ] || rm -rf ${CLEAN_TARGETS}

.PHONY: realclean
realclean:
ifneq (${MF_HAVE_CONFIG},y)
	@echo "WARNING: $@: Configuration file CONFIG='${CONFIG}' is missing" 1>&2
endif
	${MAKE} clean
	[ -z "${REALCLEAN_TARGETS}" ] || rm -rf ${REALCLEAN_TARGETS}
