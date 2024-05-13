#!/usr/bin/make
# last mod WmT, 2023-11-02	[ (c) and GPLv2 1999-2023 ]


# ,-----
# |	Configuration

.PHONY: default help
default: help

USAGE_TEXT:=
MF_DIR_TOP:=$(shell pwd)

## MF_CONFIGDIR specifies the configuration tree. Modification is
## not normally needed but it can be set if necessary
MF_CONFIGDIR?=${MF_DIR_TOP}/Config

MF_HAVE_CONFIGDIR:=$(shell if [ -d "${MF_CONFIGDIR}" ] ; then echo y ; else echo n ; fi)

MF_COMPAT_MK=${MF_CONFIGDIR}/mksw-de-compat.mk
MF_HAVE_COMPAT_MK:=$(shell if [ -r "${MF_COMPAT_MK}" ] ; then echo y ; else echo n ; fi)
ifeq (${MF_HAVE_COMPAT_MK},y)
include ${MF_COMPAT_MK}
endif


## CONFIG specifies task-specific build rules.

MF_HAVE_CONFIG:=$(shell if [ -r "${CONFIG}" ] ; then echo y ; else echo n ; fi)
ifeq (${MF_HAVE_CONFIG},y)
include ${CONFIG}
endif


# ,-----
# |	Baseline rules and help


.PHONY: config-sanity
config-sanity::
	@[ ${MF_HAVE_CONFIGDIR} = 'y' ] || echo "ERROR: Check MF_CONFIGDIR ${MF_CONFIGDIR} is set and is directory" 1>&2
	@[ ${MF_HAVE_CONFIG} = 'y' ] || echo "ERROR: Suitable CONFIG= (readable file) needed" 1>&2


#| USAGE_TEXT+= "'distclean' - make fully clean"
#| 
#| distclean::


help:
	@printf '%s\n' \
		'Configuration status:' \
		"	MF_CONFIGDIR: ${MF_CONFIGDIR}" \
		"	MF_HAVE_CONFIGDIR: ${MF_HAVE_CONFIGDIR}" \
		"	CONFIG argument: ${CONFIG}" \
		"	MF_HAVE_CONFIG: ${MF_HAVE_CONFIG}" \
		"	MF_HAVE_COMPAT_MK (`basename ${MF_COMPAT_MK}`): ${MF_HAVE_COMPAT_MK}" \
		''
ifneq (${MF_HAVE_CONFIGDIR}${MF_HAVE_CONFIG},yy)
	@${MAKE} --quiet config-sanity
else
ifeq (${USAGE_TEXT},)
	@echo "INFO: USAGE_TEXT is empty and no rules were invoked" 1>&2
else
	@printf 'Usage information follows:\n'
	@for LINE in ${USAGE_TEXT} ; do printf '\t%s\n' "$${LINE}" ; done
endif
endif
