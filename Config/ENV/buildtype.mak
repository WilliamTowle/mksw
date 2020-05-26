ifneq (${HAVE_BUILD_CFG},y)
HAVE_BUILD_CFG:= y

SOURCES:= ${TOPLEV}/src
EXTTEMP:= ${TOPLEV}/exttemp
INSTTEMP:= ${TOPLEV}/insttemp

NTI_TC_ROOT:= ${TOPLEV}/toolchain
CTI_TC_ROOT:= ${TOPLEV}/toolchain
CFG_ROOT:= ${TOPLEV}/Config

# 'native' configuration
HOSTCPU:=$(shell uname -m)
HOSTSPEC:=${HOSTCPU}-provider-linux-gnu
NTI_GCC:=/usr/bin/gcc
# TODO: NUI_GCC, too

# cross compilation configuration
TARGCPU?=i386
TARGSPEC?=${TARGCPU}-homebrew-linux-uclibc
CUI_GCC=${TARGSPEC}-gcc
endif
