# Config/ENV/tui.mak

# -----
# toolchain: buildtype.mak sets CFG_ROOT
include Config/ENV/buildtype.mak


# -----
# supported packages

#include ${CFG_ROOT}/tui/Tron/v1.0.mak
#include ${CFG_ROOT}/tui/bastet/v0.41.mak
#include ${CFG_ROOT}/tui/frotz/v2.43.mak
#include ${CFG_ROOT}/tui/hinversi/v0.8.2.mak
#include ${CFG_ROOT}/tui/linux_logo/v5.11.mak
#include ${CFG_ROOT}/tui/lynx/v2.8.8.mak
include ${CFG_ROOT}/tui/n2048/v0.1.mak
#include ${CFG_ROOT}/tui/vitetris/v0.57.mak
include ${CFG_ROOT}/tui/vttest/v20140305.mak
