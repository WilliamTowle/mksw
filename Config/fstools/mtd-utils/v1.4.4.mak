# mtd_utils v1.4.4		[ since v1.4.0, 2010-10-14 ]
# last mod WmT, 2010-10-14	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MTD_UTILS_CONFIG},y)
HAVE_MTD_UTILS_CONFIG:=y

#DESCRLIST+= "'nti-mtd_utils' -- mtd_utils"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${MTD_UTILS_VERSION},)
MTD_UTILS_VERSION=1.4.4
endif
MTD_UTILS_SRC=${SOURCES}/m/mtd-utils-${MTD_UTILS_VERSION}.tar.bz2

URLS+= ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-${MTD_UTILS_VERSION}.tar.bz2

NTI_MTD_UTILS_TEMP=nti-mtd-utils-${MTD_UTILS_VERSION}

NTI_MTD_UTILS_EXTRACTED=${EXTTEMP}/${NTI_MTD_UTILS_TEMP}/Makefile
NTI_MTD_UTILS_CONFIGURED=${EXTTEMP}/${NTI_MTD_UTILS_TEMP}/common.mk.OLD
NTI_MTD_UTILS_BUILT=${EXTTEMP}/${NTI_MTD_UTILS_TEMP}/sumtool
NTI_MTD_UTILS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/sumtool


# ,-----
# |	Extract
# +-----

${NTI_MTD_UTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/mtd-utils-${MTD_UTILS_VERSION} ] || rm -rf ${EXTTEMP}/mtd-utils-${MTD_UTILS_VERSION}
	bzcat ${MTD_UTILS_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/mtd-utils-${MTD_UTILS_VERSION} ${EXTTEMP}/${NTI_MTD_UTILS_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_MTD_UTILS_CONFIGURED}: ${NTI_MTD_UTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MTD_UTILS_TEMP} || exit 1 ;\
		[ -r common.mk.OLD ] || mv common.mk common.mk.OLD || exit 1 ;\
		cat common.mk.OLD \
			| sed '/^PREFIX/	{ s%/usr%'${NTI_TC_ROOT}'/usr% } ' \
			> common.mk || exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_MTD_UTILS_BUILT}: ${NTI_MTD_UTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MTD_UTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_MTD_UTILS_INSTALLED}: ${NTI_MTD_UTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MTD_UTILS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mtd_utils
nti-mtd_utils: ${NTI_MTD_UTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-mtd_utils

endif	# HAVE_MTD_UTILS_CONFIG
