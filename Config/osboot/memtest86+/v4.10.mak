#!usr/bin/make
# memtest86+ v4.10		[ since v3.0, c.2003-07-05 ]
# last mod WmT, 2012-08-11	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_MEMTEST86PLUS_CONFIG},y)
HAVE_MEMTEST86PLUS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MEMTEST86PLUS_VERSION},)
#MEMTEST86PLUS_VERSION=4.00
MEMTEST86PLUS_VERSION=4.10
endif

MEMTEST86PLUS_SRC= ${SOURCES}/m/memtest86+-${MEMTEST86PLUS_VERSION}.tar.gz
URLS+=http://www.memtest.org/download/${MEMTEST86PLUS_VERSION}/memtest86+-${MEMTEST86PLUS_VERSION}.tar.gz

NTI_MEMTEST86PLUS_TEMP=		nti-memtest86+-${MEMTEST86PLUS_VERSION}

NTI_MEMTEST86PLUS_EXTRACTED=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/Makefile
NTI_MEMTEST86PLUS_CONFIGURED=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/Makefile.OLD
NTI_MEMTEST86PLUS_BUILT=	${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}/memtest.bin
NTI_MEMTEST86PLUS_INSTALLED=	${NTI_TC_ROOT}/usr/lib/memtest86+/memtest.bin


## ,-----
## |	Extract
## +-----

${NTI_MEMTEST86PLUS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/memtest86+-${MEMTEST86PLUS_VERSION} ] || rm -rf ${EXTTEMP}/memtest86+-${MEMTEST86PLUS_VERSION}
	#bzcat ${MEMTEST86PLUS_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${MEMTEST86PLUS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}
	mv ${EXTTEMP}/memtest86+-${MEMTEST86PLUS_VERSION} ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP}


## ,-----
## |	Configure
## +-----

## [2015-02-15] -z muldefs fixes "multiply defined" compile errors

${NTI_MEMTEST86PLUS_CONFIGURED}: ${NTI_MEMTEST86PLUS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86PLUS_TEMP} || exit 1 ;\
		case ${MEMTEST86PLUS_VERSION} in \
		4.10) \
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
		*) \
			echo "Unexpected MEMTEST86PLUS_VERSION ${MEMTEST86PLUS_VERSION}" 1>&2 ;\
			exit 1 \
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

