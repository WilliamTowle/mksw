# 'META' specifies the desired package or package list
#CONFIG_CUSTOM?= custom.mak
META?= custom.mak

# Configure directories
CFG_ROOT= ${TOPLEV}/Config
SOURCES= ${TOPLEV}/src
EXTTEMP= ${TOPLEV}/exttemp
INSTTEMP= ${TOPLEV}/insttemp
NTI_TC_ROOT= ${TOPLEV}/toolchain
CTI_TC_ROOT= ${TOPLEV}/toolchain

# Initialisation
ALL_NUI_TARGETS:=
ALL_NTI_TARGETS:=
ALL_CTI_TARGETS:=
ALL_CUI_TARGETS:=

MF_HAVE_CONFIG_CUSTOM:=$(shell if [ -r ${META} ] ; then echo y ; else echo n ; fi)
ifeq (${MF_HAVE_CONFIG_CUSTOM},y)
-include ${META}
endif

ifeq (${NTI_TC_ROOT},${CTI_TC_ROOT})
export PATH:=$(shell echo ${NTI_TC_ROOT}/usr/bin:${PATH})
else
export PATH:=$(shell echo ${NTI_TC_ROOT}/usr/bin:${CTI_TC_ROOT}/usr/bin:${PATH})
endif


ifneq (${EXTTEMP},)
CLEAN_TARGETS+= ${EXTTEMP}/*
endif
ifneq (${INSTTEMP},)
REALCLEAN_TARGETS+= ${INSTTEMP}/*
endif
ifneq (${NTI_TC_ROOT},)
REALCLEAN_TARGETS+= ${NTI_TC_ROOT}/*
endif
ifneq (${CTI_TC_ROOT},)
ifneq (${CTI_TC_ROOT},${NTI_TC_ROOT})
REALCLEAN_TARGETS+= ${CTI_TC_ROOT}/*
endif
endif

##

# sanity checks

.PHONY: config-sanity
config-sanity:
ifeq (${MF_HAVE_CONFIG_CUSTOM},n)
ifeq (${META},)
	@echo "WARNING: $@: Missing configuration file (unset META=)" 1>&2
else
	@echo "WARNING: $@: Missing configuration file (no file in META=${META})" 1>&2
endif
endif


USAGE_RULES+= "show-urls - show download URLs"
.PHONY: show-urls
ifeq (${URLS},)
show-urls: config-sanity
	@echo "INFO: $@: No URLs" 1>&2
else
show-urls:
	@for URL in ${URLS} ; do echo $${URL} ; done
endif

##

USAGE_RULES+= "all-nui - build 'NUI' targets"

.PHONY: all-nui
all-nui: config-sanity ${ALL_NUI_TARGETS}
ifeq (${ALL_NUI_TARGETS},)
	@echo "INFO: $@: ALL_NUI_TARGETS list is empty" 1>&2
ifeq (${MF_HAVE_CONFIG_CUSTOM},n)
	@echo "WARNING: $@: Empty target list due to bad 'META' configuration?" 1>&2
endif
endif
ALL_TARGETS+= all-nui


USAGE_RULES+= "all-nti - build 'NTI' targets"

.PHONY: all-nti
all-nti: config-sanity ${ALL_NTI_TARGETS}
ifeq (${ALL_NTI_TARGETS},)
	@echo "INFO: $@: ALL_NTI_TARGETS list is empty" 1>&2
ifeq (${MF_HAVE_CONFIG_CUSTOM},n)
	@echo "WARNING: $@: Empty target list due to bad 'META' configuration?" 1>&2
endif
endif
ALL_TARGETS+= all-nti


USAGE_RULES+= "all-cti - build 'CTI' targets"

.PHONY: all-cti
all-cti: config-sanity ${ALL_CTI_TARGETS}
ifeq (${ALL_CTI_TARGETS},)
	@echo "INFO: $@: ALL_CTI_TARGETS list is empty" 1>&2
ifeq (${MF_HAVE_CONFIG_CUSTOM},n)
	@echo "WARNING: $@: Empty target list due to bad 'META' configuration?" 1>&2
endif
endif
ALL_TARGETS+= all-cti


USAGE_RULES+= "all-cui - build 'CUI' targets"

.PHONY: all-cui
all-cui: config-sanity ${ALL_CUI_TARGETS}
ifeq (${ALL_CUI_TARGETS},)
	@echo "INFO: $@: ALL_CUI_TARGETS list is empty" 1>&2
ifeq (${MF_HAVE_CONFIG_CUSTOM},n)
	@echo "WARNING: $@: Empty target list due to bad 'META' configuration?" 1>&2
endif
endif
ALL_TARGETS+= all-cui
