/* zerohere: dump zeroes to a file and delete it */

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define VER "1.0"
#define VERDATE "2021-05-07"

#define CHUNK_SIZE 32768

#ifdef ON_WINDOWS
 #define WRITE_STRING "wbS"
#else
 #define WRITE_STRING "wb"
#endif

static const char filename[] = "__zero_here_file__";
static FILE *fp;

void sighandler(const int signum)
{
	(void)signum;
	if (fp) fclose(fp);
	remove(filename);
	printf("Aborted. Zero file deleted. Are you happy now?\n");
	exit(EXIT_FAILURE);
}

int main(void)
{
	static char fill[CHUNK_SIZE];

	signal(SIGINT, sighandler);

	memset(fill, 0, CHUNK_SIZE);
	fp = fopen(filename, WRITE_STRING);
	if (!fp) goto error_open;
	printf("zerohere %s (%s), Copyright (C) by Jody Bruchon <jody@jodybruchon.com>\n", VER, VERDATE);
	printf("Writing zero file. This will take a long time...probably many hours.\n");
	printf("\nFile name is: '%s'\n\n", filename);
	while (fwrite(fill, CHUNK_SIZE, 1, fp) == 1) continue;
	fclose(fp);
	remove(filename);
	printf("Zero file completed and erased. Have an empty day!\n");
	exit(EXIT_SUCCESS);
error_open:
	printf("Could not open file '%s' for writing\n", filename);
	exit(EXIT_FAILURE);
}
