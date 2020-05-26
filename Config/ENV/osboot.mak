HAVE_EXTRA_TOOLS?=n

#include ${CFG_ROOT}/osboot/grub/v0.97.mak
#include ${CFG_ROOT}/osboot/grub/v1.99.mak
include ${CFG_ROOT}/osboot/grub/v2.00.mak

include ${CFG_ROOT}/osboot/isolinux/v3.86.mak

include ${CFG_ROOT}/osboot/memdisk/v3.86.mak
include ${CFG_ROOT}/osboot/memtest86+/v4.20.mak
include ${CFG_ROOT}/osboot/ms-sys/v2.5.3.mak

include ${CFG_ROOT}/osboot/syslinux/v3.86.mak
#include ${CFG_ROOT}/osboot/syslinux/v4.03.mak
#include ${CFG_ROOT}/osboot/syslinux/v5.10.mak
#include ${CFG_ROOT}/osboot/syslinux/v6.03.mak

ifeq (${HAVE_EXTRA_TOOLS},y)
include ${CFG_ROOT}/fstools/e2fsprogs/v1.43.1.mak
#include ${CFG_ROOT}/fstools/dosfstools/v3.0.26.mak
include ${CFG_ROOT}/fstools/dosfstools/v3.0.28.mak
#include ${CFG_ROOT}/fstools/dosfstools/v4.0.mak
# TODO: debootstrap? unsquashfs?
endif
