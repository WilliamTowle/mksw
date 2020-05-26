# debootstrap v1.0.46		[ since v1.0.46, c.2013-05-01 ]
# last mod WmT, 2013-05-01	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_DEBOOTSTRAP_CONFIG},y)
HAVE_DEBOOTSTRAP_CONFIG:=y

#DESCRLIST+= "'nti-debootstrap' -- debootstrap"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DEBOOTSTRAP_VERSION},)
DEBOOTSTRAP_VERSION=1.0.46
endif

DEBOOTSTRAP_SRC=${SOURCES}/d/debootstrap_${DEBOOTSTRAP_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.46.tar.gz

NTI_DEBOOTSTRAP_TEMP=nti-debootstrap-${DEBOOTSTRAP_VERSION}
NTI_DEBOOTSTRAP_EXTRACTED=${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP}/README
NTI_DEBOOTSTRAP_CONFIGURED=${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP}/.configure.done
NTI_DEBOOTSTRAP_BUILT=${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP}/debootstrap
NTI_DEBOOTSTRAP_INSTALLED=${NTI_TC_ROOT}/usr/bin/debootstrap


# ,-----
# |	Extract
# +-----

${NTI_DEBOOTSTRAP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP}
	zcat ${DEBOOTSTRAP_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/debootstrap-${DEBOOTSTRAP_VERSION} ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP}


# ,-----
# |	Configure
# +-----


${NTI_DEBOOTSTRAP_CONFIGURED}: ${NTI_DEBOOTSTRAP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		touch $@ \
	)


# ,-----
# |	Build
# +-----

${NTI_DEBOOTSTRAP_BUILT}: ${NTI_DEBOOTSTRAP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_DEBOOTSTRAP_INSTALLED}: ${NTI_DEBOOTSTRAP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DEBOOTSTRAP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-debootstrap
nti-debootstrap: ${NTI_DEBOOTSTRAP_INSTALLED}

ALL_NTI_TARGETS+= nti-debootstrap
#NTARGETS+= nti-native-gcc nti-debootstrap

endif	# HAVE_DEBOOTSTRAP_CONFIG
