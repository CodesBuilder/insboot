#include <stdio.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

extern const char helpmsg;

int main(int argc, char** argv) {
	if (argc != 3) {
		puts("Bad command usage");
		return 1;
	}

	char bscode[440];

	// Bootstrap code FP
	FILE* bscfp;
	if (!(bscfp = fopen(argv[1], "rb"))) {
		puts("Error opening bootstrap code");
		return 1;
	}
	if (!fread(bscode, sizeof(bscode), 1, bscfp)) {
		fclose(bscfp);
		puts("Error reading bootstrap code");
		return 1;
	}
	fclose(bscfp);

	// Device FP
	int dev = open(argv[2], O_RDONLY);
	if (dev < 0) {
		puts("Error opening device");
		return 1;
	}
	close(dev);

	return 0;
}