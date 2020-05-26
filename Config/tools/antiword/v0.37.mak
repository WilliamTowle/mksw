# antiword v0.37		[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2012-10-24	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_ANTIWORD_CONFIG},y)
HAVE_ANTIWORD_CONFIG:=y

#DESCRLIST+= "'nti-antiword' -- antiword"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ANTIWORD_VERSION},)
ANTIWORD_VERSION=0.37
endif

ANTIWORD_SRC=${SOURCES}/a/antiword-0.37.tar.gz
URLS+= http://www.winfield.demon.nl/linux/antiword-${ANTIWORD_VERSION}.tar.gz


NTI_ANTIWORD_TEMP=nti-antiword-${ANTIWORD_VERSION}

NTI_ANTIWORD_EXTRACTED=${EXTTEMP}/${NTI_ANTIWORD_TEMP}/antiword.h
NTI_ANTIWORD_CONFIGURED=${EXTTEMP}/${NTI_ANTIWORD_TEMP}/Makefile.OLD
NTI_ANTIWORD_BUILT=${EXTTEMP}/${NTI_ANTIWORD_TEMP}/antiword
NTI_ANTIWORD_INSTALLED=${NTI_TC_ROOT}/usr/bin/antiword


## ,-----
## |	Extract
## +-----

${NTI_ANTIWORD_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/antiword-${ANTIWORD_VERSION} ] || rm -rf ${EXTTEMP}/antiword-${ANTIWORD_VERSION}
	zcat ${ANTIWORD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ANTIWORD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ANTIWORD_TEMP}
	mv ${EXTTEMP}/antiword-${ANTIWORD_VERSION} ${EXTTEMP}/${NTI_ANTIWORD_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ANTIWORD_CONFIGURED}: ${NTI_ANTIWORD_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ANTIWORD_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^GLOBAL_INSTALL_DIR/ s%/usr.*%'${NTI_TC_ROOT}'/usr/bin%' \
			| sed '/^GLOBAL_RESOURCES_DIR/ s%/usr.*%'${NTI_TC_ROOT}'/usr/share/antiword%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_ANTIWORD_BUILT}: ${NTI_ANTIWORD_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ANTIWORD_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ANTIWORD_INSTALLED}: ${NTI_ANTIWORD_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ANTIWORD_TEMP} || exit 1 ;\
		make global_install \
	)

##

.PHONY: nti-antiword
nti-antiword: ${NTI_ANTIWORD_INSTALLED}

ALL_NTI_TARGETS+= nti-antiword

endif	# HAVE_ANTIWORD_CONFIG
