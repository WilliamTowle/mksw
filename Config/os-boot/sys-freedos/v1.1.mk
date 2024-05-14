# sys-freedos build rules	[ since v1.1, c.2009-01-13 ]
# last mod WmT, 2023-10-20	[ (c) and GPLv2 1999-2023 ]

ifneq (${HAVE_SYS_FREEDOS_CONFIG},y)
HAVE_SYS_FREEDOS_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${SYS_FREEDOS_VERSION},)
SYS_FREEDOS_VERSION=1.1
endif


# [2023-10-06] the source archive contains bootsecs/version.txt; this
# identifies the FreeDOS kernel number for the boot sectors used (2035)

SYS_FREEDOS_SRC=${DIR_DOWNLOADS}/s/sys-freedos-linux.zip
SYS_FREEDOS_URL=http://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/dos/kernel/sys-freedos-linux/sys-freedos-linux.zip

NTI_SYS_FREEDOS_TEMP=${DIR_EXTTEMP}/nti-sys-freedos-${SYS_FREEDOS_VERSION}

NTI_SYS_FREEDOS_EXTRACTED=${NTI_SYS_FREEDOS_TEMP}/bootsecs/version.txt 
#NTI_SYS_FREEDOS_CONFIGURED=
NTI_SYS_FREEDOS_BUILT=${NTI_SYS_FREEDOS_TEMP}/sys-freedos.pl
NTI_SYS_FREEDOS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/sys-freedos.pl


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-sys-freedos-uriurl:
	@echo "${SYS_FREEDOS_SRC} ${SYS_FREEDOS_URL}"

show-all-uriurl:: show-nti-sys-freedos-uriurl


${NTI_SYS_FREEDOS_EXTRACTED}: | nti-sanity ${SYS_FREEDOS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_SYS_FREEDOS_TEMP} ARCHIVES=${SYS_FREEDOS_SRC} EXTRACT_OPTS=''


#${NTI_SYS_FREEDOS_CONFIGURED}: ${NTI_SYS_FREEDOS_EXTRACTED}


#${NTI_SYS_FREEDOS_BUILT}: ${NTI_SYS_FREEDOS_CONFIGURED}


#${NTI_SYS_FREEDOS_INSTALLED}: ${NTI_SYS_FREEDOS_BUILT}
${NTI_SYS_FREEDOS_INSTALLED}: ${NTI_SYS_FREEDOS_EXTRACTED}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_SYS_FREEDOS_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/etc/bootsecs || exit 1 ;\
		cp -ar bootsecs/* ${DIR_NTI_TOOLCHAIN}/etc/bootsecs/ || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/bin || exit 1 ;\
		sed 's%/bootsecs/%/../../etc/bootsecs/%' sys-freedos.pl > ${DIR_NTI_TOOLCHAIN}/usr/bin/sys-freedos.pl || exit 1 ;\
		chmod a+x ${DIR_NTI_TOOLCHAIN}/usr/bin/sys-freedos.pl || exit 1 ;\
		)

#

USAGE_TEXT+= "'nti-sys-freedos' - build sys-freedos for NTI toolchain"

.PHONY: nti-sys-freedos
nti-sys-freedos: ${NTI_SYS_FREEDOS_INSTALLED}


all-nti-targets:: nti-sys-freedos


endif	## HAVE_SYS_FREEDOS_CONFIG
