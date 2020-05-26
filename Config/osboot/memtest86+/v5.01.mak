#!usr/bin/make
# memtest86+ v5.01		[ since v4.00, c.????-??-?? ]
# last mod WmT, 2015-12-23	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_MEMTEST86PLUS_CONFIG},y)
HAVE_MEMTEST86PLUS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MEMTEST86PLUS_VERSION},)
#MEMTEST86PLUS_VERSION=4.00
#MEMTEST86PLUS_VERSION=4.10
#MEMTEST86PLUS_VERSION=4.20
MEMTEST86PLUS_VERSION=5.01
endif

MEMTEST86PLUS_SRC= ${SOURCES}/m/memtest86+-${MEMTEST86PLUS_VERSION}.tar.gz
URLS+= http://www.memtest.org/download/${MEMTEST86PLUS_VERSION}/memtest86+-${MEMTEST86PLUS_VERSION}.tar.gz

NTI_MEMTEST86PLUS_TEMP=		nti-memtest86+-${MEMTEST86PLUS_VERSION}

NTI_MEMTEST86PLUS_EXTRACTED=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/Makefile
NTI_MEMTEST86PLUS_CONFIGURED=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/Makefile.OLD
NTI_MEMTEST86PLUS_BUILT=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/memtest.bin
NTI_MEMTEST86PLUS_INSTALLED=	${NTI_TC_ROOT}/usr/lib/memtest86+/memtest.bin


## ,-----
## |	Extract
## +-----

${NTI_MEMTEST86PLUS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/linux-${MEMTEST86PLUS_VERSION} ] || rm -rf ${EXTTEMP}/linux-${MEMTEST86PLUS_VERSION}
	zcat ${MEMTEST86PLUS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}
	mv ${EXTTEMP}/memtest86+-${MEMTEST86PLUS_VERSION} ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}



## ,-----
## |	Configure
## +-----

## [2016-10-26] need '-fgnu89-inline' to link reboot() under gcc 5
# * debian also:
# - have s/extern/static/ on memtest86+-5.01/io.h __out##s macro
# - have s/extern/static/ on memtest86+-5.01/io.h __in##s macro
# - fixes 2x controller.c sizeof() bugs in setup_{nhm|nhm32}:
# 	| -	for(i = 0; i < sizeof(possible_nhm_bus); i++) {
# 	| +	for(i = 0; i < sizeof(possible_nhm_bus) / sizeof(possible_nhm_bus[0]); i++) {

${NTI_MEMTEST86PLUS_CONFIGURED}: ${NTI_MEMTEST86PLUS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} || exit 1 ;\
		case ${MEMTEST86PLUS_VERSION} in \
		4.10|4.20|5.01--trial--working) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^AS[ 	]*=/	s%g*as%'`dirname ${NTI_GCC}`'/as%' \
				| sed '/^CC[ 	]*=/	s%g*cc%'${NTI_GCC}'%' \
				| sed '/^CC[ 	]*=/	s%$$%\nLD='`dirname ${NTI_GCC}`'/ld%' \
				| sed '/^LD[ 	]*=/	s%$$%\nOBJCOPY='`dirname ${NTI_GCC}`'/objcopy%' \
				| sed '/^	/	s%objcopy%$$(OBJCOPY)%' \
				| sed '/^	/	s% \&\& \\$$%%' \
				| sed '/^	/	s%-static%-static -z muldefs%' \
				| sed '/^	/	s%-shared%-shared -z muldefs%' \
				> Makefile \
		;; \
		5.01) \
			[ -r controller.c.OLD ] || mv controller.c controller.c.OLD ;\
			cat controller.c.OLD \
				| sed '/sizeof/ s%sizeof(possible_nhm_bus);%sizeof(possible_nhm_bus) / sizeof(possible_nhm_bus[0]);%' \
				> controller.c ;\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
			cat Makefile.OLD \
				| sed '/^CFLAGS/,+2	s/ $$/ -fgnu89-inline/' \
				> Makefile \
		;; \
		5.01--no-muldevs|*) \
		cp Makefile Makefile.OLD \
		;; \
		esac \
	)
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			| sed '/^CC=/		s%g*cc%'${NTI_GCC}'%' \
#			| sed '/^CC=/		s%$$%\nLD='$(shell echo ${NTI_GCC} | sed 's/gcc$$/ld/')'%' \
#			| sed '/^CFLAGS=/	s/-m32 //' \
#			| sed '/^AS=/		s%as%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/as/')'%' \
#			| sed '/^	/	s%objcopy%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/objcopy/')'%' \
#			> Makefile \


## ,-----
## |	Build
## +-----

${NTI_MEMTEST86PLUS_BUILT}: ${NTI_MEMTEST86PLUS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} || exit 1 ;\
		make memtest.bin \
	)


## ,-----
## |	Install
## +-----

${NTI_MEMTEST86PLUS_INSTALLED}: ${NTI_MEMTEST86PLUS_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/memtest86+ || exit 1 ;\
		cp memtest.bin ${NTI_TC_ROOT}/usr/lib/memtest86+/ \
	)

.PHONY: nti-memtest86plus
nti-memtest86plus: ${NTI_MEMTEST86PLUS_INSTALLED}

ALL_NTI_TARGETS+= nti-memtest86plus

endif	# HAVE_MEMTEST86PLUS_CONFIG

