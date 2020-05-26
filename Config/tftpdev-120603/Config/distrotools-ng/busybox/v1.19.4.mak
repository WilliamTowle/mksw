# busybox v1.19.4		[ since v0.60.2, c.2002-11-11 ]
# last mod WmT, 2012-03-26	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_BUSYBOX_CONFIG},y)
HAVE_BUSYBOX_CONFIG:=y

DESCRLIST+= "'cui-busybox' -- busybox"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
endif

#CUI_BUSYBOX_VER:=1.1.0
#CUI_BUSYBOX_VER:=1.16.2
#CUI_BUSYBOX_VER:=1.17.3
#CUI_BUSYBOX_VER:=1.18.0
#CUI_BUSYBOX_VER:=1.18.1
#CUI_BUSYBOX_VER:=1.18.4
#CUI_BUSYBOX_VER:=1.18.5
#CUI_BUSYBOX_VER:=1.19.2
#CUI_BUSYBOX_VER:=1.19.3
CUI_BUSYBOX_VER:=1.19.4
CUI_BUSYBOX_SRC=${SRCDIR}/b/busybox-${CUI_BUSYBOX_VER}.tar.bz2
CUI_BUSYBOX_PATCHES=

#URLS+=http://www.busybox.net/downloads/legacy/busybox-0.60.5.tar.bz2
URLS+=http://busybox.net/downloads/busybox-${CUI_BUSYBOX_VER}.tar.bz2

#CUI_BUSYBOX_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_BUSYBOX_TEMP=cui-busybox-${CUI_BUSYBOX_VER}
CUI_BUSYBOX_INSTTEMP=${EXTTEMP}/insttemp

CUI_BUSYBOX_EXTRACTED=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/configure

.PHONY: cui-busybox-extracted

cui-busybox-extracted: ${CUI_BUSYBOX_EXTRACTED}

${CUI_BUSYBOX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_BUSYBOX_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_BUSYBOX_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_BUSYBOX_SRC}
ifneq (${CUI_BUSYBOX_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_BUSYBOX_PATCHES} ; do \
			make -C ${TOPLEV} extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_BUSYBOX_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/busybox-${CUI_BUSYBOX_VER} ${EXTTEMP}/${CUI_BUSYBOX_TEMP}


# ,-----
# |	Configure
# +-----

CUI_BUSYBOX_CONFIGURED=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/.config.old

.PHONY: cui-busybox-configured

cui-busybox-configured: cui-busybox-extracted ${CUI_BUSYBOX_CONFIGURED}

${CUI_BUSYBOX_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_BUSYBOX_TEMP} || exit 1 ;\
		(	case ${CUI_BUSYBOX_VER} in \
			1.1.0) \
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
			1.16.2) \
				echo 'CONFIG_PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CONFIG_FEATURE_EDITING=y' ;\
				echo 'CONFIG_FEATURE_EDITING_FANCY_KEYS=y' ;\
				echo 'CONFIG_FEATURE_TAB_COMPLETION=y' \
			;; \
			1.17.[123]) \
				echo 'CONFIG_PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CONFIG_FEATURE_EDITING=y' ;\
				echo 'CONFIG_FEATURE_EDITING_FANCY_KEYS=y' ;\
				echo 'CONFIG_FEATURE_TAB_COMPLETION=y' ;\
				echo '# CONFIG_LFS is not set' \
			;; \
			1.18.[0145]) \
				echo 'CONFIG_PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CONFIG_FEATURE_EDITING=y' ;\
				echo 'CONFIG_FEATURE_EDITING_FANCY_KEYS=y' ;\
				echo 'CONFIG_FEATURE_TAB_COMPLETION=y' ;\
				echo '# CONFIG_LFS is not set' ;\
				echo '# CONFIG_NSLOOKUP is not set' ;\
				echo '# CONFIG_FEATURE_IPV6 is not set' \
			;; \
			1.19.[234]) \
				echo 'CONFIG_PREFIX="'${CUI_BUSYBOX_INSTTEMP}'"' ;\
				echo 'CONFIG_FEATURE_EDITING=y' ;\
				echo 'CONFIG_FEATURE_EDITING_FANCY_KEYS=y' ;\
				echo 'CONFIG_FEATURE_TAB_COMPLETION=y' ;\
				echo '# CONFIG_LFS is not set' ;\
				echo '# CONFIG_NSLOOKUP is not set' ;\
				echo '# CONFIG_FEATURE_IPV6 is not set' ;\
				echo '# CONFIG_UBIATTACH is not set' ;\
				echo '# CONFIG_UBIDETACH is not set' ;\
				echo '# CONFIG_UBIMKVOL is not set' ;\
				echo '# CONFIG_UBIRMVOL is not set' ;\
				echo '# CONFIG_UBIRSVOL is not set' ;\
				echo '# CONFIG_UBIUPDATEVOL is not set' \
			;; \
			*) \
				echo "busybox: CONFIGURE: Unexpected CUI_BUSYBOX_VER ${CUI_BUSYBOX_VER}" 1>&2 ;\
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
			echo 'CONFIG_PING=y' ;\
			echo 'CONFIG_PS=y' ;\
			echo 'CONFIG_PWD=y' ;\
			echo 'CONFIG_RM=y' ;\
			echo 'CONFIG_RMDIR=y' ;\
			echo '# CONFIG_SED is not set' ;\
			echo 'CONFIG_SLEEP=y' ;\
			echo 'CONFIG_SORT=y' ;\
			[ "${CUI_BUSYBOX_VER}" = '1.1.0' ] && echo '# CONFIG_FEATURE_SORT_BIG is not set' ;\
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
			  HOSTCC=${NTI_SPEC}-gcc \
			  oldconfig ) || exit 1 ;\
		case ${CUI_BUSYBOX_VER} in \
		1.1.0|1.2.2.1) \
			[ -r Rules.mak.OLD ] || mv Rules.mak Rules.mak.OLD ;\
			cat Rules.mak.OLD \
				| sed	' /HOSTCC/	s%g*cc%'${NTI_SPEC}'-gcc% ; /[(]CROSS[)]/	s%$$(CROSS)%$$(shell if [ -n "$${CROSS}" ] ; then echo $${CROSS} ; else echo "'`echo ${NTI_SPEC}-gcc | sed 's/gcc$$//'`'" ; fi)% ' > Rules.mak || exit 1 ;\
			[ -r applets/busybox.mkll.OLD ] || mv applets/busybox.mkll applets/busybox.mkll.OLD ;\
			cat applets/busybox.mkll.OLD \
				| sed	' /.HOSTCC/	s%.HOSTCC%'${NTI_GCC}'% ' \
				> applets/busybox.mkll \
				|| exit 1 \
		;; \
		1.16.2|1.17.[123]|1.18.[0145]|1.19.[234]) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
			cat Makefile.OLD \
				| sed	' /^ARCH/	s%=.*%= '${CTI_CPU}'%' \
				| sed	' /^CROSS_COMPILE/	s%=.*%= '${CTI_TC_ROOT}'/usr/bin/'${CTI_SPEC}'-%' \
				> Makefile || exit 1 ;\
			[ -r util-linux/fdisk.c.OLD ] || mv util-linux/fdisk.c util-linux/fdisk.c.OLD || exit 1 ;\
			cat util-linux/fdisk.c.OLD \
				| sed 's/lseek64/lseek/ ; s/off64_t/off_t/g' \
				> util-linux/fdisk.c || exit 1 \
		;; \
		*) \
			echo "busybox: CONFIGURE Makefile: Unexpected CUI_BUSYBOX_VER ${CUI_BUSYBOX_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)



# ,-----
# |	Build
# +-----

CUI_BUSYBOX_BUILT=${EXTTEMP}/${CUI_BUSYBOX_TEMP}/busybox

.PHONY: cui-busybox-built
cui-busybox-built: cui-busybox-configured ${CUI_BUSYBOX_BUILT}

## KBUILD_VERBOSE since v1.4.x

${CUI_BUSYBOX_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_BUSYBOX_TEMP} || exit 1 ;\
		case ${CUI_BUSYBOX_VER} in \
		1.1.0|1.2.2.1) \
			make VERBOSE=y \
		;; \
		1.16.2|1.17.[123]|1.18.[0145]|1.19.[234]) \
			make KBUILD_VERBOSE=1 || exit 1 \
		;; \
		*) \
			echo "BUILD: Unexpected CUI_BUSYBOX_VER ${CUI_BUSYBOX_VER}" 1>&2 ;\
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


.PHONY: cui-busybox
cui-busybox: cti-cross-gcc cui-uClibc-rt cui-busybox-installed

CTARGETS+= cui-busybox

endif	# HAVE_BUSYBOX_CONFIG
