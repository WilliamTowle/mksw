include ${CFG_ROOT}/ENV/native.mak
ifneq (${HAVE_NATIVE_GCC_VER},)
$(error echo "WARNING! Untested with 'ng' toolchains [fix Config/ENV symlinks], failing" 1>&2)
endif

include ${CFG_ROOT}/fstools/dvdrtools/v0.2.1.mak
include ${CFG_ROOT}/fstools/memdisk/v3.86.mak
#include ${CFG_ROOT}/fstools/memdisk/v4.03.mak
include ${CFG_ROOT}/fstools/memtest86+/v4.10.mak
include ${CFG_ROOT}/fstools/isolinux/v3.86.mak
#include ${CFG_ROOT}/fstools/isolinux/v4.03.mak
