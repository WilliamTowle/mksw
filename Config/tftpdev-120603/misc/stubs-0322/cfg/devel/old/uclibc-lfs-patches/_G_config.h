#ifndef _G_config_h
#define _G_config_h 1

#include <sys/types.h>

#define __need_size_t
#define __need_wchar_t
#define __need_wint_t
#define __need_NULL
#define __need_ptrdiff_t

#include <stddef.h>

#ifndef __c_mbstate_t_defined
# define __c_mbstate_t_defined	1

typedef struct {
  int count;
  wint_t value;
} __c_mbstate_t;

#endif

#undef __need_mbstate_t

typedef size_t _G_size_t;

typedef __off_t _G_fpos_t;
typedef __off64_t _G_fpos64_t;

#define _G_ssize_t	__ssize_t
#define _G_off_t	__off_t
#define _G_off64_t	__off64_t
#define	_G_pid_t	__pid_t
#define	_G_uid_t	__uid_t
#define _G_wchar_t	wchar_t
#define _G_wint_t	wint_t
#define _G_stat64	stat64

typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));

#define _G_HAVE_BOOL 1
#define _G_HAVE_ATEXIT 1
#define _G_HAVE_SYS_CDEFS 1
#define _G_HAVE_SYS_WAIT 1
#define _G_NEED_STDARG_H 1
#define _G_va_list __gnuc_va_list
#define _G_HAVE_MMAP 1
#define _G_BUFSIZ 8192
#define _G_NAMES_HAVE_UNDERSCORE 0
#define _G_VTABLE_LABEL_HAS_LENGTH 1

#ifndef _G_USING_THUNKS
# define _G_USING_THUNKS	1
#endif /* _G_USING_THUNKS */

#define _G_VTABLE_LABEL_PREFIX "__vt_"
#define _G_VTABLE_LABEL_PREFIX_ID __vt_
#define _G_INTERNAL_CCS	"UCS4"
#define _G_HAVE_WEAK_SYMBOL 1

#define _NO_STDIO_GLIBC_CUSTOM_STREAMS

#if defined __cplusplus || defined __STDC__
# define _G_ARGS(ARGLIST) ARGLIST
#else
# define _G_ARGS(ARGLIST) ()
#endif

#endif	/* _G_config.h */
