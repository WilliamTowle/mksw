# busybox v1.3.2		[ since v0.60.2, c.2002-11-11 ]
# last mod WmT, 2011-08-22	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_BUSYBOX_CONFIG},y)
HAVE_BUSYBOX_CONFIG:=y

DESCRLIST+= "'cui-busybox' -- busybox"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak


#BUSYBOX_VER:=1.1.1
#BUSYBOX_VER:=1.2.2.1
BUSYBOX_VER:=1.3.2

BUSYBOX_SRC=${SRCDIR}/b/busybox-${BUSYBOX_VER}.tar.bz2
BUSYBOX_PATCHES=

#URLS+=http://www.busybox.net/downloads/legacy/busybox-0.60.5.tar.bz2
URLS+=http://busybox.net/downloads/busybox-${BUSYBOX_VER}.tar.bz2

#BUSYBOX_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_BUSYBOX_TEMP=cui-busybox-${BUSYBOX_VER}
CUI_BUSYBOX_INSTTEMP=${EXTTEMP}/insttemp

CUI_BUSYBOX_EXTRACTED=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/Makefile


NTI_BUSYBOX_TEMP=nti-busybox-${BUSYBOX_VER}
NTI_BUSYBOX_INSTTEMP=${NTI_TC_ROOT}

NTI_BUSYBOX_EXTRACTED=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/Makefile

##

.PHONY: cui-busybox-extracted

cui-busybox-extracted: ${CUI_BUSYBOX_EXTRACTED}

${CUI_BUSYBOX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_BUSYBOX_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_BUSYBOX_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${BUSYBOX_SRC}
ifneq (${BUSYBOX_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${BUSYBOX_PATCHES} ; do \
			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${BUSYBOX_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/busybox-${BUSYBOX_VER} ${EXTTEMP}/${CUI_BUSYBOX_TEMP}


##

.PHONY: nti-busybox-extracted

nti-busybox-extracted: ${NTI_BUSYBOX_EXTRACTED}

${NTI_BUSYBOX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_BUSYBOX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BUSYBOX_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${BUSYBOX_SRC}
ifneq (${BUSYBOX_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${BUSYBOX_PATCHES} ; do \
			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${BUSYBOX_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/busybox-${BUSYBOX_VER} ${EXTTEMP}/${NTI_BUSYBOX_TEMP}


# ,-----
# |	Configure
# +-----

CUI_BUSYBOX_CONFIGURED=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/.config.old

.PHONY: cui-busybox-configured

cui-busybox-configured: cui-busybox-extracted ${CUI_BUSYBOX_CONFIGURED}

${CUI_BUSYBOX_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_BUSYBOX_TEMP} || exit 1 ;\
		(	case ${BUSYBOX_VER} in \
			1.1.[01]) \
				echo 'USING_CROSS_COMPILER=y' ;\
				echo 'PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CROSS_COMPILER_PREFIX="'${CTI_TC_ROOT}'/usr/bin/'${CTI_SPEC}'-"' ;\
				echo 'CONFIG_LOGIN=y' ;\
				echo 'CONFIG_USE_BB_PWD_GRP=y' ;\
				echo 'CONFIG_FEATURE_SHADOWPASSWDS=y' ;\
				echo 'CONFIG_USE_BB_SHADOW=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_EDITING=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y' \
			;; \
			1.2.2.1) \
				echo 'USING_CROSS_COMPILER=y' ;\
				echo 'PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CROSS_COMPILER_PREFIX="'${CTI_TC_ROOT}'/usr/bin/'${CTI_SPEC}'-"' ;\
 				echo 'CONFIG_FEATURE_COMMAND_EDITING=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y' \
			;; \
			1.3.2) \
				echo 'CONFIG_PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
 				echo 'CONFIG_FEATURE_COMMAND_EDITING=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y' \
			;; \
			*) \
				echo "busybox: CONFIGURE: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
				exit 1 \
			;; \
			esac ;\
			echo '# CONFIG_STATIC is not set' ;\
			echo 'CONFIG_FEATURE_SH_IS_ASH=y' ;\
			echo 'CONFIG_ASH=y' ;\
			echo '# CONFIG_FEATURE_SH_IS_HUSH is not set' ;\
			echo '# CONFIG_HUSH is not set' ;\
			echo '# CONFIG_FEATURE_SH_IS_LASH is not set' ;\
			echo '# CONFIG_LASH is not set' ;\
			echo '# CONFIG_FEATURE_SH_IS_MSH is not set' ;\
			echo '# CONFIG_MSH is not set' ;\
			echo 'CONFIG_BASENAME=y' ;\
			echo 'CONFIG_DATE=y' ;\
			echo 'CONFIG_DIRNAME=y' ;\
			echo 'CONFIG_DMESG=y' ;\
			echo 'CONFIG_CAT=y' ;\
			echo 'CONFIG_CHGRP=y' ;\
			echo 'CONFIG_CHMOD=y' ;\
			echo 'CONFIG_CHOWN=y' ;\
			echo 'CONFIG_CHROOT=y' ;\
			echo 'CONFIG_CP=y' ;\
			echo 'CONFIG_DD=y' ;\
			echo 'CONFIG_DF=y' ;\
			echo 'CONFIG_DU=y' ;\
			echo 'CONFIG_ECHO=y' ;\
			echo 'CONFIG_ENV=y' ;\
			echo 'CONFIG_EXPR=y' ;\
			echo 'CONFIG_EXPR=y' ;\
			echo 'CONFIG_FALSE=y' ;\
			echo 'CONFIG_TRUE=y' ;\
			echo 'CONFIG_FDFORMAT=y' ;\
			echo 'CONFIG_FDISK=y' ;\
			echo '# FDISK_SUPPORT_LARGE_DISKS is not set' ;\
			echo 'CONFIG_FEATURE_FDISK_WRITABLE=y' ;\
			echo 'CONFIG_FEATURE_FDISK_ADVANCED=y' ;\
			echo 'CONFIG_GREP=y' ;\
			echo '# CONFIG_GZIP is not set' ;\
			echo 'CONFIG_HALT=y' ;\
			echo 'CONFIG_REBOOT=y' ;\
			echo 'CONFIG_HEAD=y' ;\
			echo 'CONFIG_TAIL=y' ;\
			echo 'CONFIG_HOSTNAME=y' ;\
			echo 'CONFIG_IFCONFIG=y' ;\
			echo 'CONFIG_ROUTE=y' ;\
			echo 'CONFIG_INIT=y' ;\
			echo 'CONFIG_FEATURE_USE_INITTAB=y' ;\
			echo 'CONFIG_LN=y' ;\
			echo 'CONFIG_LS=y' ;\
			echo 'CONFIG_MKDIR=y' ;\
			echo '# CONFIG_MKE2FS is not set' ;\
			echo '# CONFIG_E2FSCK is not set' ;\
			echo 'CONFIG_MKFS_MINIX=y' ;\
			echo 'CONFIG_FSCK_MINIX=y' ;\
			echo 'CONFIG_MKNOD=y' ;\
			[ -r ${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include/asm/page.h' ] && echo 'CONFIG_MKSWAP=y' ;\
			echo 'CONFIG_SWAPONOFF=y' ;\
			echo 'CONFIG_MKTEMP=y' ;\
			echo 'CONFIG_MORE=y' ;\
			echo 'CONFIG_MOUNT=y' ;\
			echo 'CONFIG_FEATURE_MOUNT_LOOP=y' ;\
			echo 'CONFIG_FEATURE_MOUNT_NFS=y' ;\
			echo 'CONFIG_UMOUNT=y' ;\
			echo 'CONFIG_KILL=y' ;\
			echo 'CONFIG_LOSETUP=y' ;\
			echo 'CONFIG_MV=y' ;\
			echo 'CONFIG_PASSWD=y' ;\
			echo 'CONFIG_ADDUSER=y' ;\
			echo 'CONFIG_ADDGROUP=y' ;\
			echo 'CONFIG_USE_BB_PWD_GROUP=y' ;\
			echo 'CONFIG_PING=y' ;\
			echo 'CONFIG_PS=y' ;\
			echo 'CONFIG_PWD=y' ;\
			echo 'CONFIG_RM=y' ;\
			echo 'CONFIG_RMDIR=y' ;\
			echo '# CONFIG_SED is not set' ;\
			echo 'CONFIG_SLEEP=y' ;\
			echo 'CONFIG_SORT=y' ;\
			[ "${BUSYBOX_VER}" = '1.1.0' ] && echo '# CONFIG_FEATURE_SORT_BIG is not set' ;\
			[ "${BUSYBOX_VER}" = '1.1.1' ] && echo '# CONFIG_FEATURE_SORT_BIG is not set' ;\
			echo 'CONFIG_STTY=y' ;\
			echo 'CONFIG_TTY=y' ;\
			echo 'CONFIG_SYNC=y' ;\
			echo '# CONFIG_TAR is not set' ;\
			echo 'CONFIG_FEATURE_TAR_GZIP=y' ;\
			echo 'CONFIG_TEE=y' ;\
			echo 'CONFIG_TEST=y' ;\
			echo 'CONFIG_TOP=y' ;\
			echo 'CONFIG_TOUCH=y' ;\
			echo 'CONFIG_TR=y' ;\
			echo 'CONFIG_UNAME=y' ;\
			echo 'CONFIG_UNIQ=y' ;\
			echo 'CONFIG_VI=y' ;\
			echo 'CONFIG_WHOAMI=y' ;\
			echo 'CONFIG_YES=y' ;\
			echo '# CONFIG_HALT is not set' ;\
			echo '# CONFIG_MESG is not set' ;\
			echo '# CONFIG_POWEROFF is not set' ;\
			echo '# CONFIG_REBOOT is not set' ;\
			echo '# CONFIG_START_STOP_DAEMON is not set' ;\
			echo 'CONFIG_INSTALL_APPLET_SYMLINKS=y' \
		) > .config || exit 1 ;\
		yes '' | ( make \
			  HOSTCC=${NTI_GCC} \
			  oldconfig ) || exit 1 ;\
		case ${BUSYBOX_VER} in \
		1.1.[01]|1.2.2.1|1.3.2) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD ;\
			cat Rules.mak.OLD \
				| sed	' /HOSTCC/	s%g*cc%'${NTI_GCC}'% ; /[(]CROSS[)]/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_GCC} | sed 's/gcc$$//'`'" ; fi)% ' > Rules.mak || exit 1 ;\
			[ -r applets/busybox.mkll.OLD ] || mv applets/busybox.mkll applets/busybox.mkll.OLD ;\
			cat applets/busybox.mkll.OLD \
				| sed	' /.HOSTCC/	s%.HOSTCC%'${NTI_GCC}'% ' \
				> applets/busybox.mkll \
				|| exit 1 \
		;; \
		*) \
			echo "busybox: CONFIGURE Makefile: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)	|| exit 1

##


NTI_BUSYBOX_CONFIGURED=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/.config.old

.PHONY: nti-busybox-configured

nti-busybox-configured: nti-busybox-extracted ${NTI_BUSYBOX_CONFIGURED}

${NTI_BUSYBOX_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		(	case ${BUSYBOX_VER} in \
			1.1.[01]) \
				echo 'USING_CROSS_COMPILER=n' ;\
				echo 'PREFIX="'${NTI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CROSS_COMPILER_PREFIX="'`echo ${NUI_CC_PREFIX} | sed 's/g$$//'`'"' ;\
				echo 'CONFIG_LOGIN=y' ;\
				echo 'CONFIG_USE_BB_PWD_GRP=y' ;\
				echo 'CONFIG_FEATURE_SHADOWPASSWDS=y' ;\
				echo 'CONFIG_USE_BB_SHADOW=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_EDITING=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y' \
			;; \
			1.2.2.1|1.3.2) \
				echo 'USING_CROSS_COMPILER=n' ;\
				echo 'PREFIX="'${NTI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CROSS_COMPILER_PREFIX="'`echo ${NUI_CC_PREFIX} | sed 's/g$$//'`'"' ;\
 				echo 'CONFIG_FEATURE_COMMAND_EDITING=y' ;\
				echo 'CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y' \
			;; \
			*) \
				echo "busybox: CONFIGURE: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
				exit 1 \
			;; \
			esac ;\
			echo '# CONFIG_STATIC is not set' ;\
			echo 'CONFIG_APP_UDHCPD=y' ;\
			echo 'CONFIG_APP_UDHCPC=y' ;\
			echo 'CONFIG_APP_DUMPLEASES=y' ;\
			echo 'CONFIG_WGET=y' ;\
			echo 'CONFIG_INSTALL_APPLET_SYMLINKS=y' \
		) > .config || exit 1 ;\
		yes '' | ( make \
			  HOSTCC=${NUI_CC_PREFIX}cc \
			  oldconfig ) || exit 1 ;\
		case ${BUSYBOX_VER} in \
		1.1.[01]|1.2.2.1|1.3.2) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD ;\
			cat Rules.mak.OLD \
				| sed	' /HOSTCC/	s%g*cc%'${NUI_CC_PREFIX}'cc% (CROSS)%$$% ' > Rules.mak || exit 1 ;\
			[ -r applets/busybox.mkll.OLD ] || mv applets/busybox.mkll applets/busybox.mkll.OLD ;\
			cat applets/busybox.mkll.OLD \
				| sed	' /.HOSTCC/	s%.HOSTCC%'${NUI_CC_PREFIX}'cc% ' \
				> applets/busybox.mkll \
				|| exit 1 \
		;; \
		*) \
			echo "busybox: CONFIGURE Makefile: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)	|| exit 1



# ,-----
# |	Build
# +-----

CUI_BUSYBOX_BUILT=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/busybox

.PHONY: cui-busybox-built
cui-busybox-built: cui-busybox-configured ${CUI_BUSYBOX_BUILT}

${CUI_BUSYBOX_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_BUSYBOX_TEMP} || exit 1 ;\
		case ${BUSYBOX_VER} in \
		1.1.[01]|1.2.2.1|1.3.2) \
			make VERBOSE=y \
		;; \
		*) \
			echo "BUILD: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	) || exit 1

##

NTI_BUSYBOX_BUILT=${EXTTEMP}/${NTI_BUSYBOX_TEMP}/busybox

.PHONY: nti-busybox-built
nti-busybox-built: nti-busybox-configured ${NTI_BUSYBOX_BUILT}

${NTI_BUSYBOX_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		case ${BUSYBOX_VER} in \
		1.1.[01]|1.2.2.1|1.3.2) \
			make VERBOSE=y \
		;; \
		*) \
			echo "BUILD: Unexpected BUSYBOX_VER ${BUSYBOX_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	) || exit 1




# ,-----
# |	Install
# +-----

CUI_BUSYBOX_INSTALLED=${CUI_BUSYBOX_INSTTEMP}/bin/busybox

.PHONY: cui-busybox-installed

cui-busybox-installed: cui-busybox-built ${CUI_BUSYBOX_INSTALLED}

${CUI_BUSYBOX_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_BUSYBOX_INSTTEMP}
	( cd ${EXTTEMP}/${CUI_BUSYBOX_TEMP} || exit 1 ;\
		make install || exit 1 \
	) || exit 1

##

NTI_BUSYBOX_INSTALLED=${NTI_BUSYBOX_INSTTEMP}/bin/busybox

.PHONY: nti-busybox-installed

nti-busybox-installed: nti-busybox-built ${NTI_BUSYBOX_INSTALLED}

${NTI_BUSYBOX_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${NTI_BUSYBOX_INSTTEMP}
	( cd ${EXTTEMP}/${NTI_BUSYBOX_TEMP} || exit 1 ;\
		make install || exit 1 \
	) || exit 1

##

.PHONY: cui-busybox
cui-busybox: cti-cross-gcc cui-uClibc-rt cui-busybox-installed

CTARGETS+= cui-busybox

.PHONY: nti-busybox
nti-busybox: nti-busybox-installed

NTARGETS+= nti-busybox

endif	# HAVE_BUSYBOX_CONFIG
