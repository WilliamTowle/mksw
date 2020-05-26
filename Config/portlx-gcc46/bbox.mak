#!/usr/bin/make

include ${CFG_ROOT}/ENV/buildtype.mak

URLS+= http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

BBOX_SUBDIR=	cui-busybox-${BUSYBOX_VERSION}
BBOX_ARCHIVE=	${SOURCES}/b/busybox-${BUSYBOX_VERSION}.tar.bz2

BBOX_EXTRACTED=  ${EXTTEMP}/${BBOX_SUBDIR}/Makefile
BBOX_CONFIGURED= ${EXTTEMP}/${BBOX_SUBDIR}/.config.old
BBOX_BUILT= ${EXTTEMP}/${BBOX_SUBDIR}/busybox
BBOX_INSTALLED= ${INSTTEMP}/bin/busybox


## ,-----
## |	Extract
## +-----

${BBOX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	bzcat ${BBOX_ARCHIVE} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/busybox-${BUSYBOX_VERSION} ${EXTTEMP}/${BBOX_SUBDIR}


## ,-----
## |	Configure
## +-----

# Configuration of cross compiler via Makefile since v1.16.x
# CONFIG_INETD/NSLOOKUP unset because NFS support requires UCLIBC_HAS_RPC
${BBOX_CONFIGURED}: ${BBOX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${BBOX_SUBDIR} || exit 1 ;\
		 [ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		 cat Makefile.OLD \
		  	| sed   ' /^ARCH/       	s%=.*%= '${TARGCPU}'%' \
		  	| sed   ' /^CROSS_COMPILE/      s%=.*%= '${TARGSPEC}'-%' \
		  	> Makefile || exit 1 ;\
		(	echo 'CONFIG_PREFIX="'${INSTTEMP}'"' ;\
			echo '# CONFIG_STATIC is not set' ;\
			echo 'CONFIG_FEATURE_SH_IS_ASH=y' ;\
			echo 'CONFIG_ASH=y' ;\
			echo '# CONFIG_FEATURE_IPV6 is not set' ;\
			echo 'CONFIG_FEATURE_USE_INITTAB=y' ;\
			echo 'CONFIG_INIT=y' ;\
			echo 'CONFIG_CAT=y' ;\
			echo 'CONFIG_HALT=y' ;\
			echo '# CONFIG_INETD is not set' ;\
			echo '# CONFIG_NSLOOKUP is not set' ;\
			echo 'CONFIG_REBOOT=y' ;\
			echo 'CONFIG_IFCONFIG=y' ;\
			echo 'CONFIG_LS=y' ;\
			echo 'CONFIG_ROUTE=y' ;\
			echo 'CONFIG_STTY=y' \
		) > .config ;\
		yes '' | ( make HOSTCC=/usr/bin/gcc oldconfig ) || exit 1 \
	)


## ,-----
## |	Build
## +-----

${BBOX_BUILT}: ${BBOX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${BBOX_SUBDIR} || exit 1 ;\
		make KBUILD_VERBOSE=1 \
	)


## ,-----
## |	Install
## +-----

# TODO: install to $INSTTEMP...
${BBOX_INSTALLED}: ${BBOX_BUILT}
	echo "*** (i) INSTALL -> $@ ***"
	( cd ${EXTTEMP}/${BBOX_SUBDIR} || exit 1 ;\
		make install \
	)

.PHONY: cui-bbox
cui-bbox: ${BBOX_INSTALLED}
