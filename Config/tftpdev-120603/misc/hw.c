#include <stdio.h>
#ifndef SIMPLE
#ifdef __linux__
#include <linux/uts.h>
#endif
#endif

int main()
{
#ifdef UTS_SYSNAME
	printf("hw - %s - %s %s\n", UTS_SYSNAME, __DATE__, __TIME__);
#else
	printf("hw - %s %s\n", __DATE__, __TIME__);
#endif
	return 0;
}
