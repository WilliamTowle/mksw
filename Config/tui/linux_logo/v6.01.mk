# linux_logo v6.01		[ since v?.??, c.????-??-?? ]
# last mod WmT, 2024-05-16	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LINUX_LOGO_CONFIG},y)
HAVE_LINUX_LOGO_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LINUX_LOGO_VERSION},)
#LINUX_LOGO_VERSION=5.0
#LINUX_LOGO_VERSION=5.11
LINUX_LOGO_VERSION=6.01
endif

LINUX_LOGO_SRC=${DIR_DOWNLOADS}/l/linux_logo-${LINUX_LOGO_VERSION}.tgz
# Older version at http://metalab.unc.edu/pub/Linux/logos/penguins/
LINUX_LOGO_URL=http://www.deater.net/weave/vmwprod/linux_logo/linux_logo-${LINUX_LOGO_VERSION}.tar.gz


# Dependencies
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_LINUX_LOGO_TEMP=${DIR_EXTTEMP}/nti-linux_logo-${LINUX_LOGO_VERSION}

NTI_LINUX_LOGO_EXTRACTED=${NTI_LINUX_LOGO_TEMP}/configure
NTI_LINUX_LOGO_CONFIGURED=${NTI_LINUX_LOGO_TEMP}/logo_config
NTI_LINUX_LOGO_BUILT=${NTI_LINUX_LOGO_TEMP}/linux_logo
NTI_LINUX_LOGO_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/linux_logo


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-linux_logo-uriurl:
	@echo "${LINUX_LOGO_SRC} ${LINUX_LOGO_URL}"

show-all-uriurl:: show-nti-linux_logo-uriurl


${NTI_LINUX_LOGO_EXTRACTED}: | nti-sanity ${LINUX_LOGO_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LINUX_LOGO_TEMP} ARCHIVES=${LINUX_LOGO_SRC} EXTRACT_OPTS='--strip-components=1'
#| ${NTI_LINUX_LOGO_EXTRACTED}:
#| 	echo "*** $@ (EXTRACTED) ***"
#| 	[ ! -d ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION} ] || rm -rf ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION}
#| 	zcat ${LINUX_LOGO_SRC} | tar xvf - -C ${EXTTEMP}
#| 	[ ! -d ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}
#| 	mv ${EXTTEMP}/linux_logo-${LINUX_LOGO_VERSION} ${EXTTEMP}/${NTI_LINUX_LOGO_TEMP}


${NTI_LINUX_LOGO_CONFIGURED}: ${NTI_LINUX_LOGO_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
	  CC=${NUI_HOST_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr/ \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/cd po && /	{ s%^%ifneq ($${XGETTEXT},)\n% ; s%$$%\nendif% }' \
			> Makefile \
	)


${NTI_LINUX_LOGO_BUILT}: ${NTI_LINUX_LOGO_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
		make || exit 1 \
	)


${NTI_LINUX_LOGO_INSTALLED}: ${NTI_LINUX_LOGO_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_LINUX_LOGO_TEMP} || exit 1 ;\
		make install || exit 1 \
	)


##

USAGE_TEXT+= "'nti-linux-logo' - build linux_logo for NTI toolchain"

.PHONY: nti-linux-logo
nti-linux-logo: nti-ncurses ${NTI_LINUX_LOGO_INSTALLED}


all-nti-targets:: nti-linux-logo

endif	# HAVE_LINUX_LOGO_CONFIG
